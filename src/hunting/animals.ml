type animal = {
  mutable x : float;
  y : float;
}

let collision_area animal =
  (animal.x -. 10., animal.y -. 7., animal.x +. 10., animal.y +. 7.)

let approach ~pace =
  let x = pace in
  fun animal ->
    animal.x <- animal.x +. x;
    animal

let render_animal_at ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (0.4, 0.2, 0.05);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-18., -15.); (-18., 15.); (18., 15.); (18., -15.) ];
  GlDraw.ends ()

let render animal = render_animal_at ~x:animal.x ~y:animal.y