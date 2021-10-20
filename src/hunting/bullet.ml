type bullet = {
  mutable x : float;
  mutable y : float;
}

let collision_area bullet =
  (bullet.x -. 5., bullet.y -. 5., bullet.x +. 5., bullet.y +. 5.)

let out_of_bound ~bounds =
  let x1, y1, x2, y2 = bounds in
  fun (x, y) -> x < x1 || x > x2 || y < y1 || y > y2

let in_bound ~bounds =
  let check = out_of_bound ~bounds in
  fun bullet -> not @@ check (bullet.x, bullet.y)

(* let approach ~pace = let y = pace in fun bullet -> bullet.y <-
   bullet.y -. y; bullet *)

let render_bullet_at ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (1., 1., 1.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-5., -5.); (-5., 5.); (5., 5.); (5., -5.) ];
  GlDraw.ends ()

let approach ~pace =
  let y = pace in
  fun bullet ->
    bullet.y <- bullet.y +. y;
    bullet

let render bullet = render_bullet_at ~x:bullet.x ~y:bullet.y