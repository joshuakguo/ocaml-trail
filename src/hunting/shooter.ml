type shooter = {
  mutable x : float;
  y : float;
}

let out_of_bound ~bounds =
  let x1, y1, x2, y2 = bounds in
  fun (x, y) -> x < x1 || x > x2 || y < y1 || y > y2

let in_bound ~bounds =
  let check = out_of_bound ~bounds in
  fun shooter -> not @@ check (shooter.x, shooter.y)

let move shooter = shooter.x <- shooter.x -. 8.

let render_shooter_at ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (0.51, 1., 0.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-2., -2.); (-2., 2.); (2., 2.); (2., -2.) ];
  GlDraw.ends ()

let render shooter = render_shooter_at ~x:shooter.x ~y:shooter.y
