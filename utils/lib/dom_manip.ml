{client{

  open Eliom_content
  open Html5
  open D

  let get_value dom = Js.to_string ((Html5.To_dom.of_input dom)##value)
  let set_value e s = (Html5.To_dom.of_input e)##value <- Js.string s
  let empty_value e = (Html5.To_dom.of_input e)##value <- Js.string ""

  let get_opt_value dom =
    let s = get_value dom in
    if s = "" then None
    else Some s

}}