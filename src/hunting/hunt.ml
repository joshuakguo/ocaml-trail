type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet_list : Bullet.bullet list;
  mutable animal_list : Animals.animal list;
  mutable kill : int;
  mutable ammo : int
}

type direction =
  | Left
  | Right

type event =
  | MoveShooter of direction
  | Shoot
  | Bullet
  | MoveAnimal
  | Collisions

type collision = {
    bullet: Bullet.bullet;
    animal: Animals.animal;
}

exception NoBullets

let rec collision ~animals ~bullets = match animals with
  | [] -> []
  | h :: t -> let check = Bullet.in_bound ~bounds:
   (Animals.collision_area h) in
   match List.find_opt check bullets with
    | None -> collision ~animals: t ~bullets: bullets
    | Some(bullet) -> { animal = h; bullet; } :: collision ~animals: t
   ~bullets: bullets

let collisions ~game = collision ~animals:game.animal_list
   ~bullets:game.bullet_list

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
          (Bullet.in_bound ~bounds:(0., 0., 800., 800.))
          bullets;
      game.ammo <- game.ammo - 1;
      game
  | MoveAnimal ->
      let pace = 20. in
      let approach_animal = Animals.approach ~pace in
      game.animal_list <- List.map approach_animal game.animal_list;
      game
| Collisions ->
let animal_collisions = collisions ~game in game.animal_list <-
   List.filter (fun animal -> match (List.find_opt (fun collide ->
   collide.animal == animal) animal_collisions) with | None -> true | _
   -> false ) game.animal_list;
   (* game.bullet_list <- match (List.find_opt
   (fun collide -> collide.bullet == bullet) animal_collisions with |
   None -> true | _ -> false) ) game.bullet_list; *)
   game.over <- game.bullet_list = [] || game.kill = 3;
   game
  (* if collide bullet animal then game.kill <- game.kill +
   1; game.food <- game.food + 10; *)

let render (hunt : hunt) =
    match hunt.over with
    | true -> Shooter.render
    hunt.shooter; List.iter Bullet.render hunt.bullet_list; List.iter
    Animals.render hunt.animal_list
    | false ->
      Shooter.render
      hunt.shooter; List.iter Bullet.render hunt.bullet_list; List.iter
      Animals.render hunt.animal_list