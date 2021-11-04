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

(* let rec collision ~animals ~bullets = match animals with | [] -> [] |
   h :: t -> ( let check = Bullet.in_bound
   ~bounds:(Animals.collision_area h) in match List.find_opt check
   bullets with | None -> collision ~animals:t ~bullets | Some bullet ->
   { animal = h; bullet } :: collision ~animals:t ~bullets) *)

(* let in_bounds_both ~bounds = let x1, y1, x2, y2 = bounds in fun (xa,
   ya, xb, yb) -> xa > x1 && xb < x2 && ya > y1 && yb < y2

   let check_bounds ~bounds = let check = in_bounds_both ~bounds in fun
   animal -> check (Animals.collision_area animal) *)

let rec collision ~animals ~bullets =
  let open Bullet in
  match animals with
  | [] -> []
  | hd :: tl -> (
      let checkHit = in_bound ~bounds:(Animals.collision_area hd) in
      match List.find_opt checkHit bullets with
      | None -> collision ~animals:tl ~bullets
      | Some bullet ->
          { bullet; animal = hd } :: collision ~animals:tl ~bullets)

(* let rec collision1 ~animals ~bullets = let open Bullet in match
   animals with | [] -> [] | hd :: tl -> ( let checkHit = in_bounds_both
   ~bounds:(Animals.collision_area hd) in match List.find_opt checkHit
   bullets with | None -> collision ~animals:tl ~bullets | Some bullet
   -> { bullet; animal = hd } :: collision1 ~animals:tl ~bullets) *)

(* let rec collect_collisions ~animals ~bullets = match animals with | h
   :: t -> List.filter (check_bounds ~bounds:(Animals.collision_area h))
   bullets @ collect_collisions ~animals:t ~bullets | [] -> [] *)

(* let rec this stupid dumb = let x = collect_collisions ~animals:stupid
   ~bullets:dumb in match dumb with | [] -> None | h :: t when h = x ->
   Some t | h1 :: t1 -> h1 :: this stupid t1 *)

let collisions ~game =
  collision ~animals:game.animal_list ~bullets:game.bullet_list

(* let rec rem_bullet blst h = match blst with | h1 :: t1 when h1 =
   h.bullet -> t1 | h2 :: t2 -> h2 :: rem_bullet t2 h | [] -> []

   let rec rem_animal alst h = match alst with | h1 :: t1 when h1 =
   h.animal -> t1 | h2 :: t2 -> h2 :: rem_animal t2 h | [] -> []

   let remove_bullet clst blst = match clst with | [] -> [] | h :: _ ->
   rem_bullet blst h

   let remove_animal clst alst = match clst with | [] -> [] | h :: _ ->
   rem_animal alst h *)

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
      (* if game.ammo > 0 then *)
      game.bullet_list <-
        game.bullet_list
        @ [ { x = game.shooter.x; y = game.shooter.y } ];
      game.ammo <- game.ammo - 1;
      game
  | Bullet ->
      let bullets = List.map Bullet.move game.bullet_list in
      (* game.bullet_list <- List.filter (Bullet.in_bound ~bounds:(0.,
         0., 800., 525.)) bullets; *)
      game.bullet_list <- bullets;
      game
  | MoveAnimal -> let pace = 20. in let approach_animal =
     Animals.approach ~pace in game.animal_list <- List.map
     approach_animal game.animal_list; game
  | Collisions ->
      (* let animal_collisions = collisions ~game in game.animal_list <-
         List.filter (fun animal -> match List.find_opt (fun collide ->
         collide.animal == animal) animal_collisions with | None -> true
         | _ -> false) game.animal_list; game.bullet_list <- List.filter
         (fun bullet -> match List.find_opt (fun collide ->
         collide.bullet == bullet) animal_collisions with | None -> true
         | _ -> false) game.bullet_list; *)
      (* match collisions ~game with | [] -> game | h :: t -> *)
      (* game.bullet_list <- []; *)
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

      (* game.bullet_list <- remove_bullet (collisions ~game)
         game.bullet_list; game.animal_list <- remove_animal (collisions
         ~game) game.animal_list; *)
      game.kill <- game.kill + 1;
      game.food <- game.food + (10 * game.kill);
      game.over <- game.ammo = 0 || game.kill = 3;
      game

let render game =
  match game.over with
  | true -> Shooter.render game.shooter
  | false ->
      Shooter.render game.shooter;
      List.iter Bullet.render game.bullet_list;
      List.iter Animals.render game.animal_list
