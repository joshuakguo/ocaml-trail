type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet_list : Bullet.bullet list;
  mutable animal_list : Animals.animal list;
}

type direction =
  | Left
  | Right

type event =
  | MoveShooter of direction
  | Shoot
  | Bullet
  | MoveAnimal
(* | Collision *)

exception NoBullets

let controller game = function
  | MoveShooter direction ->
      let operator =
        match direction with
        | Left -> ( -. )
        | Right -> ( +. )
      in
      let coord = operator game.shooter.x 20. in
      game.shooter.x <- min (max coord 10.) 800.;
      game
  | Shoot ->
      game.bullet_list <-
        game.bullet_list
        @ [ { x = game.shooter.x; y = game.shooter.y } ];
      game
  | Bullet ->
      let bullets = List.map Bullet.move game.bullet_list in
      game.bullet_list <-
        List.filter
          (Bullet.in_bound ~bounds:(0., 0., 700., 700.))
          bullets;
      game
  | MoveAnimal ->
      let pace = 20. in
      let approach_animal = Animals.approach ~pace in
      game.animal_list <- List.map approach_animal game.animal_list;
      game
(* | Collision -> *)

let render game =
  Shooter.render game.shooter;
  List.iter Bullet.render game.bullet_list;
  List.iter Animals.render game.animal_list
