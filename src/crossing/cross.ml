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
      let coord = operator game.caravan.x 10. in
      game.caravan.x <- min (max coord 10.) 440.;
      game
  | ScrollObstacles ->
      let pace = -10. in
      let approach_obstacles = Obstacle.approach ~pace in
      game.obstacle_list <-
        List.map approach_obstacles game.obstacle_list;
      game
(* | Collisions -> *)

let key_to_action ~key ~x ~y =
  match key with
  | Glut.KEY_LEFT -> Some (Move Left)
  | Glut.KEY_RIGHT -> Some (Move Right)
  | _ -> None

let render game =
  Caravan.render game.caravan;
  List.iter Obstacle.render game.obstacle_list
