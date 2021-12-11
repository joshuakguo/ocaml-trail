type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet_list : Bullet.bullet list;
  mutable animal_list : Animals.animal list;
  mutable kill : int;
  mutable ammo : int;
  mutable food : int;
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
  bullet : Bullet.bullet;
  animal : Animals.animal;
}

exception NoBullets

let rec collision ~animals ~bullets =
  let open Bullet in
  match animals with
  | [] -> []
  | hd :: tl -> (
      let check_hit = in_bound ~bounds:(Animals.collision_area hd) in
      match List.find_opt check_hit bullets with
      | None -> collision ~animals:tl ~bullets
      | Some bullet ->
          { bullet; animal = hd } :: collision ~animals:tl ~bullets)

let collisions ~game =
  collision ~animals:game.animal_list ~bullets:game.bullet_list

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
      game.ammo <- game.ammo - 1;
      game
  | Bullet ->
      let bullets = List.map Bullet.move game.bullet_list in
      game.bullet_list <-
        List.filter
          (Bullet.in_bound ~bounds:(0., 0., 800., 525.))
          bullets;
      game
  | MoveAnimal ->
      let pace = 10. in
      let approach_animal = Animals.approach ~pace in
      game.animal_list <- List.map approach_animal game.animal_list;
      game
  | Collisions ->
      let animal_collisions = collisions ~game in
      game.animal_list <-
        List.filter
          (fun animal ->
            match
              List.find_opt
                (fun col -> col.animal == animal)
                animal_collisions
            with
            | None -> true
            | _ -> false)
          game.animal_list;
      game.bullet_list <-
        List.filter
          (fun bullet ->
            match
              List.find_opt
                (fun col -> col.bullet == bullet)
                animal_collisions
            with
            | None -> true
            | _ -> false)
          game.bullet_list;
      game.kill <- game.kill + List.length animal_collisions;
      game.food <- game.food + (10 * game.kill);
      game.over <- game.ammo = 0 || game.kill = 5;
      game

let render game =
  match game.over with
  | true -> Shooter.render game.shooter
  | false ->
      Shooter.render game.shooter;
      List.iter Bullet.render game.bullet_list;
      List.iter Animals.render game.animal_list
