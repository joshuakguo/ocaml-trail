type game_state =
  (* | Home | Trail | Hunting *)
  | Crossing
  | Hunting
(* | End *)

type game = {
  mutable game_state : game_state;
  mutable crossing : Crossing.Cross.cross;
  mutable hunt : Hunting.Hunt.hunt;
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
}

(* type profile = | Farmer of game | Carpenter of game | Banker of
   game *)

let shooter : Hunting.Shooter.shooter =
  let open Hunting.Shooter in
  { x = 400.; y = 480. }

let bullets lst ammo =
  let rec helper l = function
    | 0 -> l
    | ammo -> helper (List.rev_append lst l) (ammo - 1)
  in
  List.rev (helper [] ammo)

let init_bullets ammo =
  let open Hunting.Bullet in
  bullets [ { x = shooter.x; y = shooter.y } ] ammo

let rec init_animals x : Hunting.Animals.animal list =
  let open Random in
  ignore @@ init;
  let open Hunting.Animals in
  match x with
  | 0 -> []
  | _ ->
      { x = -20000. +. float 20700.; y = 0. +. float 400. }
      :: init_animals (x - 1)

let hunt : Hunting.Hunt.hunt =
  let open Hunting.Hunt in
  {
    over = false;
    shooter;
    bullet_list = init_bullets 0;
    animal_list = init_animals 100;
    kill = 0;
    ammo = 1000;
    (* random amount of ammo *)
    food = 0;
  }

let rec init_obstacles x : Crossing.Obstacle.obstacle list =
  let open Random in
  ignore @@ init;
  let open Crossing.Obstacle in
  match x with
  | 0 -> []
  | _ ->
      { x = -20. +. float 750.; y = 1000. -. float 750. }
      :: init_obstacles (x - 1)

let caravan : Crossing.Caravan.caravan =
  let open Crossing.Caravan in
  { x = 400.; y = 100. }

let crossing =
  let open Crossing.Cross in
  { over = false; caravan; obstacle_list = init_obstacles 15 }

let init () =
  {
    game_state = Hunting;
    (* game_state = Crossing; *)
    crossing;
    money = 0;
    days_passed = 0;
    miles_traveled = 0;
    pace = 50;
    health = 80;
    camels = 0;
    food = 0;
    ration = 0;
    ammo = 0;
    clothes = 0;
    parts = 0;
    dead = false;
    hunt;
  }

(* HUNTING *)
let render_hunting game =
  GlClear.clear [ `color ];
  Hunting.Hunt.render game;
  Glut.swapBuffers ()

let hunt_action ~key ~x:_ ~y:_ game =
  match key with
  | Glut.KEY_LEFT ->
      game.hunt <-
        Hunting.Hunt.controller game.hunt
          (Hunting.Hunt.MoveShooter Left)
  | Glut.KEY_RIGHT ->
      game.hunt <-
        Hunting.Hunt.controller game.hunt
          (Hunting.Hunt.MoveShooter Right)
  | Glut.(KEY_OTHER 32) ->
      game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.Shoot
  | _ -> ()

(* CROSSING *)
let render_crossing game =
  GlClear.clear [ `color ];
  Crossing.Cross.render game;
  Glut.swapBuffers ()

(* let rec animal_ticker (game : game) ~value:_ = game.hunt <-
   Hunting.Hunt.controller game.hunt Hunting.Hunt.MoveAnimal;
   Glut.timerFunc ~ms:500 ~cb:(animal_ticker game) ~value:0 *)

(* let rec bullet_ticker (game : game) ~value:_ = game.hunt <-
   Hunting.Hunt.controller game.hunt Hunting.Hunt.Bullet; Glut.timerFunc
   ~ms:50 ~cb:(bullet_ticker game) ~value:0 *)

(* let rec animal_coll_ticker (game : game) ~value:_ = game.hunt <-
   Hunting.Hunt.controller game.hunt Hunting.Hunt.Collisions;
   Glut.timerFunc ~ms:100 ~cb:(animal_coll_ticker game) ~value:0 *)

(* let init_hunt ~game = Glut.specialFunc ~cb:(hunt_action game) *)
(* Glut.timerFunc ~ms:500 ~cb:(animal_ticker game) ~value:0;
   Glut.timerFunc ~ms:500 ~cb:(bullet_ticker game) ~value:0 *)

(* let crossing_key_to_action ~key ~x ~y = match key with |
   Glut.KEY_LEFT -> Some (Crossing.Cross.Move Left) | Glut.KEY_RIGHT ->
   Some (Crossing.Cross.Move Right) | _ -> None

   let crossing_controller game fun_action ~key ~x ~y = match fun_action
   ~key ~x ~y with | Some action -> game := Crossing.Cross.controller
   !game action | None -> () *)

let crossing_action ~key ~x:_ ~y:_ game =
  match key with
  | Glut.KEY_LEFT ->
      game.crossing <-
        Crossing.Cross.controller game.crossing
          (Crossing.Cross.Move Left)
  | Glut.KEY_RIGHT ->
      game.crossing <-
        Crossing.Cross.controller game.crossing
          (Crossing.Cross.Move Right)
  | _ -> ()

let rec game_ticker (game : game) ~value:_ =
  (* crossing functions *)
  game.crossing <-
    Crossing.Cross.controller game.crossing
      Crossing.Cross.ScrollObstacles;
  game.crossing <-
    Crossing.Cross.controller game.crossing Crossing.Cross.Collisions;
  (* hunting functions *)
  game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.Collisions;
  game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.Bullet;
  game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.MoveAnimal;
  (* Glut.postRedisplay (); *)
  Glut.timerFunc ~ms:50 ~cb:(game_ticker game) ~value:0

(* let init_crossing ~game = Glut.specialFunc ~cb:(crossing_action
   game) *)

let init_game ~game = game_ticker game ~value:0

let render game =
  match game.game_state with
  | Crossing ->
      render_crossing game.crossing;
      Glut.specialFunc ~cb:(crossing_action game)
  | Hunting ->
      render_hunting game.hunt;
      Glut.specialFunc ~cb:(hunt_action game)
