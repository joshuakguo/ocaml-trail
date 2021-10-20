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

(* let obstacle_list = let open Crossing.Obstacle in [ { x = 100.; y =
   300. }; { x = 400.; y = 250. } ] *)

let shooter =
  let open Hunting.Shooter in
  { x = 250.; y = 450. }

let bullets lst ammo =
  let rec helper l = function
    | 0 -> l
    | ammo -> helper (List.rev_append lst l) (ammo - 1)
  in
  List.rev (helper [] ammo)

let bullet_list =
  let open Hunting.Bullet in
  bullets [ { x = 250.; y = 450. } ] 10
(*random number of bullets*)

let hunt =
  let open Hunting.Hunt in
  { over = false; shooter; bullet_list }

let rec init_obstacles x : Crossing.Obstacle.obstacle list =
  let open Random in
  ignore @@ init;
  let open Crossing.Obstacle in
  match x with
  | 0 -> []
  | _ ->
      { x = -30. +. float 750.; y = 1000. -. float 750. }
      :: init_obstacles (x - 1)

let caravan =
  let open Crossing.Caravan in
  { x = 400.; y = 50. }

let crossing =
  let open Crossing.Cross in
  { over = false; caravan; obstacle_list = init_obstacles 10 }

let init () =
  {
    game_state = Crossing;
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

let render_hunting game =
  GlClear.clear [ `color ];
  (* [GlClear.clear] needed before every render function to clear the
     background color *)
  Hunting.Hunt.render game;
  Glut.swapBuffers ()
(* I don't actually know what [Glut.swapBuffers] does. I think we need
   it after every render though. *)

(* CROSSING *)

let render_crossing game =
  GlClear.clear [ `color ];
  (* [GlClear.clear] needed before every render function to clear the
     background color *)
  Crossing.Cross.render game;
  Glut.swapBuffers ()
(* I don't actually know what [Glut.swapBuffers] does. I think we need
   it after every render though. *)

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

let init_crossing_inputs ~game =
  Glut.specialFunc ~cb:(crossing_action game)

let render game =
  match game.game_state with
  | Crossing -> render_crossing game.crossing
  | Hunting -> render_hunting game.hunt
