type animal = {
  mutable x : float;
  mutable y : float;
}

type collision = Bullet.bullet

type direction =
  | Left
  | Right

type action =
  | MoveShooter of direction
  | Shoot
  | MoveAnimal
  | MoveBullet
  | CheckCollision

type game = {
  mutable over : bool;
  mutable energy : int;
  mutable animal : int;
  mutable bullets : int;
}

let collisionBounds animal =
  (animal.x -. 5., animal.y -. 5., animal.x +. 5., animal.y +. 5.)
