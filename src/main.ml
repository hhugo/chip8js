open Eliom_content
open Html5.F

module Chip8 =
  Eliom_registration.App (struct
    let application_name = "chip8"
  end)

let main_handler _ _ =
  let _ : unit client_value = {{
  Eliom_client.onload (
    fun _ ->
      Main_client.init ()
  )
  }} in

  Lwt.return (
    html
      (head (title (pcdata "Chip8 Emu")) [
         meta ~a:([a_charset "utf-8"; a_content "text/html"; a_http_equiv "Content-Type"]) () ;
         meta ~a:([a_name "Description"; a_content "Chip8 Emulator written in ocaml"]) () ;
         meta ~a:([a_property "og:type"; a_content "website"]) () ;
         meta ~a:([a_property "og:url"; a_content ("http://www.chip8.com")]) () ;
         meta ~a:([a_property "og:title"; a_content "Chip8 Emulator written in ocaml"]) () ;
         meta ~a:([a_property "og:site_name"; a_content "www.chip8.com"]) () ;
       ])
      (body [])
  )

let _ =
  Chip8.register_service ~path:[ "" ]
    ~get_params:Eliom_parameter.unit
    main_handler
