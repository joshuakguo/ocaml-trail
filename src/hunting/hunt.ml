type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet_list : Bullet.bullet list;
      (* mutable animal_list : Animals.animal list; *)
}

type direction =
  | Left
  | Right

type event =
  | MoveShooter of direction
  | Bullet
(* | MoveAnimal | Collision *)

exception NoBullets

let remove_hd lst =
  match lst with
  | [] -> []
  | _ :: t -> t

let rec move_bullet lst =
  match lst with
  | [] -> raise NoBullets
  | h :: _ ->
      if Bullet.in_bound ~bounds:(0., 0., 550., 550.) h then
        Bullet.move h
      else remove_hd lst

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
  | Bullet ->
      (* move_bullet game.bullet_list; *)
      game
(* | MoveAnimal -> | Collision -> *)

let render game =
  Shooter.render game.shooter;
  List.iter Bullet.render game.bullet_list
(* Animals.render game.animal *)
