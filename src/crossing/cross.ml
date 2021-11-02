type cross = {
  mutable over : bool;
  mutable caravan : Caravan.caravan;
  mutable obstacle_list : Obstacle.obstacle list;
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

(* let in_bounds ~bounds =
  let x1, y1, x2, y2 = bounds in
  fun (x, y) -> x > x1 && x < x2 && y > y1 && y < y2 *)

let in_bounds_both ~bounds =
  let x1, y1, x2, y2 = bounds in
  fun (xa, ya, xb, yb) -> xa > x1 && xb < x2 && ya > y1 && yb < y2

(* let in_bounds_obstacle_notthisone = let open Obstacle in let check =
   in_bounds ~bounds:(0., 25., 800., 500.) in fun crossing -> try Some
   (List.find (fun obstacle -> check (obstacle.x, obstacle.y))
   crossing.obstacle_list) with | Not_found -> None *)

let check_bounds ~bounds =
  (* let open Obstacle in *)
  let check = in_bounds_both ~bounds in
  fun obstacle -> check (Obstacle.collision_area obstacle)

let collect_collisions (crossing : cross) =
  (* let in_bound_obstacles =
    List.filter
      (check_bounds ~bounds:(0., 0., 800., 525.))
      crossing.obstacle_list
  in *)
  List.find_opt
    (check_bounds ~bounds:(Caravan.collision_area crossing.caravan))
    (* (check_bounds ~bounds: (380., 420., 80., 120.)) *)
    (* in_bound_obstacles *)
    crossing.obstacle_list

let controller (crossing : cross) = function
  | Move direction ->
      let operator =
        match direction with
        | Left -> ( -. )
        | Right -> ( +. )
      in
      let coord = operator crossing.caravan.x 30. in
      crossing.caravan.x <- min (max coord 10.) 800.;
      crossing
  | ScrollObstacles ->
      let pace = 1. in
      let approach_obstacles = Obstacle.approach ~pace in
      crossing.obstacle_list <-
        List.map approach_obstacles crossing.obstacle_list;
      crossing
  | Collisions ->
      (match collect_collisions crossing with
      | None -> ()
      | Some _ -> crossing.over <- true);
      crossing

(* let key_to_action ~key = match key with | Glut.KEY_LEFT -> Some (Move
   Left) | Glut.KEY_RIGHT -> Some (Move Right) | _ -> None *)

(* let cross_ticker (game : Cross) = match game.over with | true -> Some
   (* close window render? *) | false -> render game *)

(* let background_render = GlMat.load_identity (); GlMat.translate3
   (400., 275., 0.); GlDraw.color (0.2, 0.4, 1.); GlDraw.begins `quads;
   List.iter GlDraw.vertex2 [ (-300., -200.); (300., 200.); (-300.,
   200.); (300., -200.) ]; GlDraw.ends () *)

(* let render_crossing_over =
  GlClear.clear [ `color ];
  GlMat.load_identity ();
  GlMat.translate3 (400., 277.5, 0.);
  GlDraw.color (1., 1., 1.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-350., -222.5); (-350., 222.5); (350., 222.5); (-350., -222.5) ];
  GlDraw.color (0., 0., 0.);
  GlDraw.ends ();
  let game_over_text = Printf.sprintf "YOU CRASHED!" in
  Style.write_string 400. 277.5 game_over_text;
  Glut.swapBuffers () *)

let render (crossing : cross) =
  match crossing.over with
  | true -> Caravan.render crossing.caravan;
  (* Caravan.render crossing.caravan *)
  | false ->
      (* background, obstacles, then caravan, rn it's background,
         caravan, obstacles *)
      Caravan.render crossing.caravan;
      List.iter Obstacle.render crossing.obstacle_list
