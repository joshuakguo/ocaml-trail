type hunt = {
  mutable over : bool;
  mutable shooter : Shooter.shooter;
  mutable bullet_list : Bullet.bullet list;
  mutable animal_list : Animals.animal list;
  mutable kill : int;
  mutable ammo : int;
  mutable food : int;
  mutable bullet_count : int;
}

type direction =
  | Left
  | Right

type event =
  | Shooter of direction
  | Shoot
  | Bullet
  | Animal
  | Collisions

type collision = {
  bullet : Bullet.bullet;
  animal : Animals.animal;
}

exception NoBullets

let rec collision ~animals ~bullets =
  match animals with
  | [] -> []
  | hd :: tl -> (
      let check_hit =
        Bullet.in_bound ~bounds:(Animals.collision_area hd)
      in
      match List.find_opt check_hit bullets with
      | None -> collision ~animals:tl ~bullets
      | Some bullet ->
          { bullet; animal = hd } :: collision ~animals:tl ~bullets)

let collisions ~game =
  collision ~animals:game.animal_list ~bullets:game.bullet_list

let in_bounds_complete ~bounds =
  let x1, y1, x2, y2 = bounds in
  fun (xa, ya, xb, yb) -> xa > x1 && xb < x2 && ya > y1 && yb < y2

let check_bounds_complete ~bounds =
  let check = in_bounds_complete ~bounds in
  fun animal -> check (Animals.collision_area animal)

let in_bound_animals ~game =
  let in_bound =
    List.filter
      (check_bounds_complete ~bounds:(0., 0., 800., 525.))
      game.animal_list
  in
  List.length in_bound = 0

let no_more_bullets game =
  let bullets = List.map Bullet.move game.bullet_list in
  List.length
    (List.filter (Bullet.in_bound ~bounds:(0., 0., 800., 525.)) bullets)
  = 0

let control_shooter game direction =
  let operator =
    match direction with
    | Left -> ( -. )
    | Right -> ( +. )
  in
  let coord = operator game.shooter.x 20. in
  game.shooter.x <- min (max coord 10.) 800.;
  game

let control_shoot game =
  game.bullet_list <-
    (if game.bullet_count >= game.ammo then game.bullet_list
    else
      game.bullet_list @ [ { x = game.shooter.x; y = game.shooter.y } ]);
  game.bullet_count <- game.bullet_count + 1;
  game

let control_bullet game =
  let bullets = List.map Bullet.move game.bullet_list in
  game.bullet_list <-
    List.filter (Bullet.in_bound ~bounds:(0., 0., 800., 525.)) bullets;
  game

let control_animal game =
  let pace = 10. in
  let approach_animal = Animals.approach ~pace in
  game.animal_list <- List.map approach_animal game.animal_list;
  game

let control_collisions game =
  if not game.over then (
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
    game.over <-
      (game.bullet_count > game.ammo && no_more_bullets game = true)
      || game.kill = 5
      || in_bound_animals ~game = true;
    game)
  else game

let controller game = function
  | Shooter direction -> control_shooter game direction
  | Shoot -> control_shoot game
  | Bullet -> control_bullet game
  | Animal -> control_animal game
  | Collisions -> control_collisions game

let draw_text ?(font = Glut.BITMAP_HELVETICA_18) y s =
  GlMat.load_identity ();
  let width = float_of_int (Glut.bitmapLength ~font ~str:s) in
  GlPix.raster_pos ~x:(400. -. (width /. 2.)) ~y ();
  GlDraw.color (1., 1., 1.);
  String.iter (fun c -> Glut.bitmapCharacter ~font ~c:(Char.code c)) s

let game_over game =
  let end_text =
    if game.kill = 5 then
      Printf.sprintf
        "You can only bring 100 pounds of meat back to the caravan."
    else if game.bullet_count > game.ammo && no_more_bullets game = true
    then
      Printf.sprintf "You ran out of ammo. You brought "
      ^ string_of_int game.food ^ " pounds of meat back to the caravan."
    else if in_bound_animals ~game = true then
      Printf.sprintf "You brought "
      ^ string_of_int game.food ^ " pounds of meat back to the caravan."
    else Printf.sprintf "You were unable to shoot any food."
  in
  draw_text 262.5 end_text;
  let continue_text = Printf.sprintf "Press SPACE BAR to continue" in
  draw_text 45. continue_text

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
