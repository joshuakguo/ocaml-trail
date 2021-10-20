type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet_list : Bullet.bullet list;
      (* mutable animal_list : Animals.animal list; *)
}

type direction =
  | Left
  | Right

type shoot = Shot

type event =
  | MoveShooter of direction
  | Bullet

(* | Shoot *)
(* | MoveAnimal | Collision *)

exception NoBullets

(* let remove_hd lst = match lst with | [] -> [] | _ :: t -> t *)

let move_bullet = function
  | [] -> raise NoBullets
  | h :: _ ->
      if Bullet.in_bound ~bounds:(0., 0., 1000., 1000.) h then
        Bullet.approach ~pace:(-10.) h
      else Bullet.approach ~pace:0. h

(* let remove_bullet lst = match lst with | [] -> raise NoBullets | _ ::
   t -> t *)

let controller game = function
  | MoveShooter direction ->
      let operator =
        match direction with
        | Left -> ( -. )
        | Right -> ( +. )
      in
      let coord = operator game.shooter.x 10. in
      if Shooter.in_bound ~bounds:(0., 0., 1000., 1000.) game.shooter
      then game.shooter.x <- min (max coord 10.) 440.
      else game.shooter.x <- game.shooter.x;
      game
  | Bullet -> (
      (* move_bullet game.bullet_list; *)
      match game.bullet_list with
      | [] -> raise NoBullets
      | _ :: t ->
          game.bullet_list <- t;
          game)
(* | MoveAnimal -> | Collision -> *)

let render game =
  Shooter.render game.shooter;
  List.iter Bullet.render game.bullet_list
(* Animals.render game.animal *)
