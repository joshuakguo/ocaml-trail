let init () =
  {
    dead = false;
    score = 0;
    days_passed = 0;
    money = 0;
    miles_traveled = 0;
    camels = 0;
    health = 80;
    pace = 50;
    food = 0;
    ration = 0;
    ammo = 0;
    clothes = 0;
    parts = 0;
  }

let dead = if health <= 0 then true else false
