type person = {money; days_passed; miles_passed; pace; health; camels; food; 
rations; ammo; clothes; parts ; dead}
[]
type profile = Farmer of person | Carpenter of person | Banker of person

let init () =
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
  }