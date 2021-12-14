type t = {
  mutable money : int;
  mutable days_passed : int;
  mutable miles_traveled : int;
  mutable pace : int;
  mutable health : int;
  mutable camels : int;
  mutable food : int;
  mutable ration : int;
  mutable ammo : int;
  mutable clothes : int;
  mutable parts : int;
  mutable dead : bool;
  mutable input_string : string;
}

type s = { mutable river_pos : float }

let scene = { river_pos = 75. }

type event =
  | Choice
  | Advance
  | Arrive
  | Shop

let draw_text ?(font = Glut.BITMAP_HELVETICA_18) y s =
  GlMat.load_identity ();
  let width = float_of_int (Glut.bitmapLength ~font ~str:s) in
  GlPix.raster_pos ~x:(400. -. (width /. 2.)) ~y ();
  GlDraw.color (0., 0., 0.);
  String.iter (fun c -> Glut.bitmapCharacter ~font ~c:(Char.code c)) s

let render_camel ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (0.66, 0.47, 0.32);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-20., -20.); (-20., 20.); (20., 20.); (20., -20.) ];
  GlDraw.ends ()

let render_river ~x =
  GlMat.load_identity ();
  GlMat.translate3 (x, 0., 0.);
  GlDraw.color (0.35, 0.7, 1.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (x, 400.); (x +. 75., 400.); (x +. 75., 190.); (x, 190.) ];
  GlDraw.ends ()

let render_travel game =
  GlMat.load_identity ();
  GlMat.translate3 (0., 0., 0.);
  GlDraw.color (0.8, 0.8, 0.8);
  GlDraw.begins `quads;
  (* gray background for status text *)
  List.iter GlDraw.vertex2
    [ (0., 190.); (800., 190.); (800., 75.); (0., 75.) ];
  GlDraw.ends ();
  let days_text =
    Printf.sprintf "Days passed: " ^ string_of_int game.days_passed
  in
  draw_text 175. days_text;
  let health_text =
    Printf.sprintf "Health: " ^ string_of_int game.health
  in
  draw_text 150. health_text;
  let food_text = Printf.sprintf "Food: " ^ string_of_int game.food in
  draw_text 125. food_text;
  let miles_text =
    Printf.sprintf "Miles traveled: "
    ^ string_of_int game.miles_traveled
  in
  draw_text 100. miles_text

(* let render_choice game = GlMat.load_identity (); GlMat.translate3
   (0., 0., 0.); GlDraw.color (0.8, 0.8, 0.8); GlDraw.begins `quads;
   List.iter GlDraw.vertex2 [ (800., 200.); (800., 200.); (800., 75.);
   (0., 75.) ]; (* ^ not right *) GlDraw.ends (); let days_text =
   Printf.sprintf "Days passed: " ^ string_of_int game.days_passed in
   draw_text 480. days_text; let health_text = Printf.sprintf "Health: "
   ^ string_of_int game.health in draw_text 430. health_text; let
   health_text = Printf.sprintf "You may: " in draw_text 405.
   health_text; let continue_trail_text = Printf.sprintf "1: Continue on
   trail" in draw_text 485. continue_trail_text; let check_supplies_text
   = Printf.sprintf "2: Check supplies" in draw_text 460.
   check_supplies_text; let hunt_text = Printf.sprintf "3: Hunt for
   food" in draw_text 435. hunt_text; let choice_text = Printf.sprintf
   "What is your choice? Enter the number." in draw_text 410.
   choice_text; game *)

let control_choice game =
  match game.input_string with
  | "1" -> game
  | "2" -> game
  | "3" -> game
  | _ -> game

let control_advance game =
  let pace = 25. in
  scene.river_pos <- scene.river_pos +. pace;
  game

let controller game =
  if not game.dead then function
    | Choice -> control_choice game
    | Advance -> control_advance game
    | Arrive -> game
    | Shop -> game
  else function
    | _ -> game

let render game =
  match game.dead with
  | true -> ()
  | false ->
      render_camel ~x:600. ~y:300.;
      render_river ~x:scene.river_pos;
      render_travel game
