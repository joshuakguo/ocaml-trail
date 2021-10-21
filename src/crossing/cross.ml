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
(* | Collisions *)

let controller game = function
  | Move direction ->
      let operator =
        match direction with
        | Left -> ( -. )
        | Right -> ( +. )
      in
      let coord = operator game.caravan.x 30. in
      game.caravan.x <- min (max coord 10.) 800.;
      game
  | ScrollObstacles ->
      let pace = 20. in
      let approach_obstacles = Obstacle.approach ~pace in
      game.obstacle_list <-
        List.map approach_obstacles game.obstacle_list;
      game
(* | Collisions -> *)

(* let key_to_action ~key = match key with | Glut.KEY_LEFT -> Some (Move
   Left) | Glut.KEY_RIGHT -> Some (Move Right) | _ -> None *)

(* let cross_ticker (game : Cross) = match game.over with | true -> Some
   (* close window render? *) | false -> render game *)

(* let background_render = GlMat.load_identity (); GlMat.translate3
   (400., 275., 0.); GlDraw.color (0.2, 0.4, 1.); GlDraw.begins `quads;
   List.iter GlDraw.vertex2 [ (-300., -200.); (300., 200.); (-300.,
   200.); (300., -200.) ]; GlDraw.ends () *)

let render game =
  Caravan.render game.caravan;
  (* background_render; *)
  List.iter Obstacle.render game.obstacle_list