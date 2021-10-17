type gameState =
  | Home
  | Trail
  | Hunting
  | Crossing
  | End

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

type profile =
  | Farmer of game
  | Carpenter of game
  | Banker of game

let init () =
  {
    game_state = Home;
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

let render_crossing game = Caravan.render game.caravan

let render game =
  match game.game_state with
  | _ -> render_crossing game