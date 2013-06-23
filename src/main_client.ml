{client{

  open Eliom_content
  open Html5
  open D

  let games_div = div ~a:[ a_class ["game_list"; "clearfix"]] []

  let instruction,update_instruction = Dom_react.S.create None

  let main_dom () =
    let instruction_dom =
      Dom_react.S.map (
        function
          | None -> div ~a:[ a_class ["span3"; "instruction"]] []
          | Some g ->
            let controls_dom =
              match g.Chip8_game.controls with
                | Some s ->
                  div [
                    h3 [ pcdata "Controls" ];
                    p (Dom_manip.nl_to_br s);
                  ]
                | None ->
                  div ~a:[ a_style "display:none" ] []
            in
            let instruction_dom =
              match g.Chip8_game.instruction with
                | Some s ->
                  div [
                    h3 [ pcdata "Instruction" ];
                    p (Dom_manip.nl_to_br s)
                  ]
                | None ->
                  div ~a:[ a_style "display:none" ] []
            in
            let information_dom =
              match g.Chip8_game.information with
                | Some s ->
                  div [
                    h3 [ pcdata "Information" ];
                    p (Dom_manip.nl_to_br s)
                  ]
                | None ->
                  div ~a:[ a_style "display:none" ] []
            in

            div ~a:[ a_class ["span3"; "instruction"]] [
              controls_dom;
              instruction_dom ;
              information_dom
            ]
      ) instruction
    in

    div [
      header [
        div [
          span ~a:[ a_class ["logo"]] [];
          span ~a:[ a_class ["logo_txt"]] [ pcdata "OCHIP8" ];
        ]
      ];
      div ~a:[ a_class [ "container"]] [
        Debug.box_dom;
        div ~a:[ a_class ["canvas_div"; "row"]] [
          div ~a:[ a_class ["span9"] ] [ Display.canvas ];
          R.node instruction_dom
        ];
        games_div
      ]
    ]


  let game_dom canvas_js game_name =
    let g = Hashtbl.find Chip8_game.games_htbl game_name in
    div ~a:[
      a_class [ "game"; "span3" ];
      a_onclick (fun _ ->
        update_instruction (Some g);
        canvas_js##scrollIntoView (Js._false);
        Chip8_game.launch_game game_name;
        false
      )
    ] [
      img ~src:g.Chip8_game.img_path ~alt:g.Chip8_game.img_path ();
      span [ pcdata game_name ]
    ]


  let init () =
    Debug.init ();
    Key.init () ;
    let canvas_js = Display.init () in

    Lwt.async (
      fun _ ->
        lwt game_names =
          lwt games = %Chip8_game.available_game () in
          let g = List.map (
              fun g ->
                Hashtbl.add Chip8_game.games_htbl g.Chip8_game.name g ;
                g.Chip8_game.name
            ) games in
          Lwt.return g
        in

        let game_names =
          List.sort (
            fun g1 g2 -> compare g1 g2
          ) game_names
        in

        Manip.replaceAllChild games_div (List.map (game_dom canvas_js) game_names);
        Lwt.return_unit
    );

    Manip.appendToBody (main_dom ())

}}
