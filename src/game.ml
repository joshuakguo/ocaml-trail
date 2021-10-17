type gameState = (* | Home | Trail | Hunting *)
  | Crossing
(* | End *)

type game = {
  game_state : gameState;
  caravan : Crossing.Caravan.caravan;
  money : int;
  days_passed : int;
  miles_traveled : int;
  pace : int;
  health : int;
  camels : int;
  food : int;
  ration : int;
  ammo : int;
  clothes : int;
  parts : int;
  dead : bool;
}

(* type profile = | Farmer of game | Carpenter of game | Banker of
   game *)

let caravan =
  let open Crossing.Caravan in
  { x = 225.; y = 50. }

let init () =
  {
    game_state = Crossing;
    caravan;
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
  }

let render_crossing game =
  GlClear.clear [ `color ];
  (* [GlClear.clear] needed before every render function to clear the
     background color *)
  Crossing.Caravan.render game.caravan;
  Glut.swapBuffers ()
(* I don't actually know what [Glut.swapBuffers] does. I think we need
   it after every render though. *)

let render game =
  match game.game_state with
  | Crossing -> render_crossing game
(* | _ -> render_crossing game *)
