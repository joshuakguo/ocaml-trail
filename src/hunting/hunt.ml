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
      game.shooter.x <-
        (if game.over = false then min (max coord 10.) 800.
        else game.shooter.x);
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
      game.food <- game.food + (20 * game.kill);
      game.over <- game.ammo = 0 || game.kill = 5;
      game.bullet_list <-
        (if game.over = true then [] else game.bullet_list);
      game

let draw_text ?(font = Glut.BITMAP_HELVETICA_18) y s =
  GlMat.load_identity ();
  let width = float_of_int (Glut.bitmapLength ~font ~str:s) in
  GlPix.raster_pos ~x:(400. -. (width /. 2.)) ~y ();
  GlDraw.color (1., 1., 1.);
  String.iter (fun c -> Glut.bitmapCharacter ~font ~c:(Char.code c)) s

let render game =
  match game.over with
  | true ->
      let end_text =
        match game.kill with
        | 5 ->
            Printf.sprintf
              "You brought 100 pounds of meat back to the caravan."
        | 0 -> Printf.sprintf "You were unable to shoot any food."
        | _ ->
            Printf.sprintf "You brought "
            ^ string_of_int (20 * game.kill)
            ^ " pounds of meat back to the caravan."
      in
      draw_text 262.5 end_text;
      let continue_text =
        Printf.sprintf "Press SPACE BAR to continue"
      in
      draw_text 45. continue_text
  | false ->
      Shooter.render game.shooter;
      List.iter Bullet.render game.bullet_list;
      List.iter Animals.render game.animal_list
