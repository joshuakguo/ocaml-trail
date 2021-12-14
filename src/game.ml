type game_state =
  (* | Home | Trail *)
  | Trailing
  | Crossing
  | Hunting
(* | End *)

type game = {
  mutable game_state : game_state;
  mutable crossing : Crossing.Cross.cross;
  mutable hunt : Hunting.Hunt.hunt;
  mutable trail : Trailing.Trail.t;
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

let input_string = ref ""

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
      { x = -8000. +. float 10000.; y = 0. +. float 400. }
      :: init_animals (x - 1)

let hunt : Hunting.Hunt.hunt =
  let open Hunting.Hunt in
  {
    over = false;
    shooter;
    bullet_list = init_bullets 0;
    animal_list = init_animals 100;
    kill = 0;
    ammo = 5;
    (* random amount of ammo *)
    food = 0;
    bullet_count = 0;
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
  {
    over = false;
    caravan;
    obstacle_list = init_obstacles 15;
    win = false;
    camels = 100;
    parts = 100 (* random number of camels and parts *);
  }

let trail =
  let open Trailing.Trail in
  {
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
    input_string = "";
  }

let init () =
  {
    game_state = Hunting;
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
    trail;
  }

let draw_text ?(font = Glut.BITMAP_HELVETICA_18) y s =
  GlMat.load_identity ();
  let width = float_of_int (Glut.bitmapLength ~font ~str:s) in
  GlPix.raster_pos ~x:(400. -. (width /. 2.)) ~y ();
  GlDraw.color (1., 1., 1.);
  String.iter (fun c -> Glut.bitmapCharacter ~font ~c:(Char.code c)) s

(* HUNTING *)
let render_hunting game =
  GlClear.clear [ `color ];
  GlClear.color (0.2, 0.5, 0.2);
  Hunting.Hunt.render game;
  Glut.swapBuffers ()

let hunt_action ~key ~x:_ ~y:_ game =
  match key with
  | Glut.KEY_LEFT ->
      game.hunt <-
        Hunting.Hunt.controller game.hunt (Hunting.Hunt.Shooter Left)
  | Glut.KEY_RIGHT ->
      game.hunt <-
        Hunting.Hunt.controller game.hunt (Hunting.Hunt.Shooter Right)
  | Glut.(KEY_OTHER 32) ->
      game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.Shoot
  | _ -> ()

(* CROSSING *)
let render_crossing game =
  GlClear.clear [ `color ];
  GlClear.color (0.35, 0.7, 1.);
  Crossing.Cross.render game;
  Glut.swapBuffers ()

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

let render_trailing game =
  GlClear.clear [ `color ];
  GlClear.color (0., 0., 0.);
  Trailing.Trail.render game;
  Glut.swapBuffers ()

let trailing_action ~key ~x:_ ~y:_ game =
  match key with
  | 48 ->
      input_string := !input_string ^ "0";
      ()
  | 49 ->
      input_string := !input_string ^ "1";
      ()
  | 50 ->
      input_string := !input_string ^ "2";
      ()
  | 41 ->
      input_string := !input_string ^ "3";
      ()
  | 52 ->
      input_string := !input_string ^ "4";
      ()
  | 53 ->
      input_string := !input_string ^ "5";
      ()
  | 54 ->
      input_string := !input_string ^ "6";
      ()
  | 55 ->
      input_string := !input_string ^ "7";
      ()
  | 56 ->
      input_string := !input_string ^ "8";
      ()
  | 57 ->
      input_string := !input_string ^ "9";
      ()
  | 257 ->
      game.trail.input_string <- !input_string;
      input_string := "";
      ()
  | 32 ->
      game.trail <-
        Trailing.Trail.controller game.trail Trailing.Trail.Advance
  | _ -> ()
(* 257 = enter, 32 = space *)

let rec game_ticker (game : game) ~value:_ =
  (* crossing functions *)
  game.crossing <-
    Crossing.Cross.controller game.crossing
      Crossing.Cross.ScrollObstacles;
  game.crossing <-
    Crossing.Cross.controller game.crossing Crossing.Cross.Collisions;
  game.crossing <-
    Crossing.Cross.controller game.crossing Crossing.Cross.Finished;
  (* hunting functions *)
  game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.Collisions;
  game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.Bullet;
  game.hunt <- Hunting.Hunt.controller game.hunt Hunting.Hunt.Animal;
  (* Glut.postRedisplay (); *)
  Glut.timerFunc ~ms:50 ~cb:(game_ticker game) ~value:0

(* let init_crossing ~game = Glut.specialFunc ~cb:(crossing_action
   game) *)

let init_game ~game = game_ticker game ~value:0

let render game =
  match game.game_state with
  | Crossing ->
      render_crossing game.crossing;
      game.camels <- game.crossing.camels;
      game.parts <- game.crossing.parts;
      Glut.specialFunc ~cb:(crossing_action game)
  | Hunting ->
      render_hunting game.hunt;
      game.ammo <- game.hunt.ammo;
      game.food <- game.hunt.food;
      Glut.specialFunc ~cb:(hunt_action game)
  | Trailing ->
      render_trailing game.trail;
      game.money <- game.trail.money;
      game.days_passed <- game.trail.days_passed;
      game.miles_traveled <- game.trail.miles_traveled;
      game.pace <- game.trail.pace;
      game.health <- game.trail.health;
      game.camels <- game.trail.camels;
      game.food <- game.trail.food;
      game.ration <- game.trail.ration;
      game.ammo <- game.trail.ammo;
      game.clothes <- game.trail.clothes;
      game.parts <- game.trail.parts;
      game.dead <- game.trail.dead;
      Glut.keyboardFunc ~cb:(trailing_action game)
