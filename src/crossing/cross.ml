type cross = {
  mutable over : bool;
  mutable caravan : Caravan.caravan;
  mutable obstacle_list : Obstacle.obstacle list;
  mutable win : bool;
  mutable camels : int;
  mutable parts : int;
}

type direction =
  | Left
  | Right

(* type collision = { obstacle : Obstacle.obstacle; caravan :
   Caravan.caravan; } *)

type event =
  | Move of direction
  | ScrollObstacles
  | Collisions
  | Finished

let in_bounds_complete ~bounds =
  let x1, y1, x2, y2 = bounds in
  fun (xa, ya, xb, yb) -> xa > x1 && xb < x2 && ya > y1 && yb < y2

let in_bounds_touching ~bounds =
  let x1, y1, x2, y2 = bounds in
  fun (xa, ya, xb, yb) ->
    (xa > x1 && xa < x2 && ya > y1 && ya < y2)
    || (xb > x1 && xb < x2 && yb > y1 && yb < y2)
    || (xb > x1 && xb < x2 && ya > y1 && ya < y2)
    || (xa > x1 && xa < x2 && yb > y1 && yb < y2)

let check_bounds_touching ~bounds =
  let check = in_bounds_touching ~bounds in
  fun obstacle -> check (Obstacle.collision_area obstacle)

let check_bounds_complete ~bounds =
  let check = in_bounds_complete ~bounds in
  fun obstacle -> check (Obstacle.collision_area obstacle)

let collect_collisions ~game =
  let in_bound_obstacles =
    List.filter
      (check_bounds_complete ~bounds:(0., 0., 800., 525.))
      game.obstacle_list
  in
  List.find_opt
    (check_bounds_touching
       ~bounds:(Caravan.collision_area game.caravan))
    (* (check_bounds ~bounds:(380., 420., 80., 120.)) *)
    in_bound_obstacles
(* game.obstacle_list *)

let crossed ~game =
  let in_bound =
    List.filter
      (check_bounds_complete ~bounds:(0., 0., 800., 525.))
      game.obstacle_list
  in
  List.length in_bound = 0

let control_caravan game direction =
  let operator =
    match direction with
    | Left -> ( -. )
    | Right -> ( +. )
  in
  let coord = operator game.caravan.x 30. in
  game.caravan.x <- min (max coord 10.) 800.;
  game

let control_obstacles game =
  let pace = 4. in
  let approach_obstacles = Obstacle.approach ~pace in
  game.obstacle_list <- List.map approach_obstacles game.obstacle_list;
  game

let control_collisions game =
  (match collect_collisions ~game with
  | None -> ()
  | Some _ ->
      if game.camels >= 1 then game.camels <- game.camels - 1
      else game.camels <- game.camels;
      if game.parts >= 2 then game.parts <- game.parts - 2
      else game.parts <- game.parts;
      game.win <- false;
      game.over <- true);
  game

let control_finished game =
  (match crossed ~game with
  | false -> ()
  | true ->
      game.win <- true;
      game.over <- true);
  game

let controller game =
  if not game.over then function
    | Move direction -> control_caravan game direction
    | ScrollObstacles -> control_obstacles game
    | Collisions -> control_collisions game
    | Finished -> control_finished game
  else function
    | _ -> game

let draw_text ?(font = Glut.BITMAP_HELVETICA_18) y s =
  GlMat.load_identity ();
  let width = float_of_int (Glut.bitmapLength ~font ~str:s) in
  GlPix.raster_pos ~x:(400. -. (width /. 2.)) ~y ();
  GlDraw.color (1., 1., 1.);
  String.iter (fun c -> Glut.bitmapCharacter ~font ~c:(Char.code c)) s

let render game =
  match game.over with
  | true ->
      let end_text =
        match game.win with
        | true -> Printf.sprintf "You safely crossed the river."
        | false ->
            (* if game.camels >= 1 then game.camels <- game.camels - 1
               else game.camels <- game.camels; if game.parts >= 2 then
               game.parts <- game.parts - 2 else game.parts <-
               game.parts; *)
            Printf.sprintf
              "You crashed the caravan and lost supplies. You have "
            ^ string_of_int game.camels
            ^ " camel(s) and "
            ^ string_of_int game.parts
            ^ " caravan part(s) left."
      in
      draw_text 262.5 end_text;
      let continue_text =
        Printf.sprintf "Press SPACE BAR to continue"
      in
      draw_text 45. continue_text
  | false ->
      Caravan.render game.caravan;
      List.iter Obstacle.render game.obstacle_list
