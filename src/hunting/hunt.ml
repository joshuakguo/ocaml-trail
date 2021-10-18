type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet : Bullet.bullet;
  mutable animal : Animals.animal;
}

type direction =
  | Left
  | Right

type event =
  | MoveShooter of direction
  | Shoot
  | MoveBullet
(* | MoveAnimal | Collision *)

let controller game = function
  | MoveShooter direction ->
      let operator =
        match direction with
        | Left -> ( -. )
        | Right -> ( +. )
      in
      let coord = operator game.shooter.x 10. in
      game.shooter.x <- min (max coord 10.) 440.;
      game
  | Shoot ->
      game.bullet.x <- game.shooter.x;
      game.bullet.y <- game.shooter.y;
      game
  | MoveBullet ->
      Bullet.move game.bullet;
      game
(* | MoveAnimal -> | Collision -> *)

let render game =
  Shooter.render game.shooter;
  Bullet.render game.bullet;
  Animals.render game.animal
