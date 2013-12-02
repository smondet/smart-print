open Document

type t =
  | Var of string
  | App of t * t
  | Fun of string * t
  | Let of string * t * t
  | Tuple of t list

let rec pp (paren : bool) (e : t) : Document.t =
  let if_parens d =
    if paren then parens d else d in
  match e with
  | Var x -> !^ x
  | App (e1, e2) -> group (if_parens (pp true e1 ^^ nest 2 @@ pp true e2))
  | Fun (x, e) -> group (parens (!^ "fun" ^^ !^ x ^^ !^ "->" ^^ nest 2 @@ pp false e))
  | Let (x, e1, e2) ->
    group (!^ "let" ^^ !^ x ^^ !^ "=" ^^ nest 2 (pp false e1) ^^ !^ "in" ^^ new_line ^^ pp false e2)
  | Tuple es -> group_all @@ parens @@ separate (!^ "," ^^ space) (es |> List.map (fun e -> nest 2 @@ pp false e))

let es = [
  App (Var "f", Var "x");
  App (Var "fdsgoklkmeee", Var "xdsgsdg");
  Fun ("x", App (Var "fdsgo", App (Var "x", Var "xdsgsdg")));
  Fun ("x", App (Var "fdsgo", App (Var "xffd", Var "xdsgsdg")));
  Tuple [];
  Tuple [Var "x"; Var "y"];
  Tuple (List.map (fun x -> Var x) ["kjh"; "lj"; "iop"; "rt"; "vbn"; "hjk"; "gkgytuuhi"]);
  Let ("x", Var "x", Var "y");
  Let ("x", Fun ("x", App (Var "fdsgo", App (Var "x", Var "xdsgsdg"))), Var "y")]