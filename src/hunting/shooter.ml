type shooter = {
  mutable x : float;
  y : float;
}

let render_shooter_at ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (0.51, 1., 0.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-20., -20.); (-20., 20.); (20., 20.); (20., -20.) ];
  GlDraw.ends ()

let render shooter = render_shooter_at ~x:shooter.x ~y:shooter.y
