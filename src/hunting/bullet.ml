type bullet = {
  mutable x : float;
  mutable y : float;
}

let collision_area bullet =
  (bullet.x -. 5., bullet.y -. 5., bullet.x +. 5., bullet.y +. 5.)

let move bullet = bullet.y <- bullet.y -. 8.

let render_bullet_at ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (1., 1., 1.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-1., -1.); (-1., 1.); (1., 1.); (1., -1.) ];
  GlDraw.ends ()

let approach ~pace =
  let y = pace in
  fun bullet ->
    bullet.y <- bullet.y +. y;
    (* bullet.x <- bullet.x; *)
    bullet

let render bullet = render_bullet_at ~x:bullet.x ~y:bullet.y