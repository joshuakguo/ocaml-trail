type animal = {
  mutable x : float;
  mutable y : float;
}

let in_bound ~bounds =
  let out_of_bound ~bounds =
    let x1, y1, x2, y2 = bounds in
    fun (x, y) -> x < x1 || x > x2 || y < y1 || y > y2
  in
  let check = out_of_bound ~bounds in
  fun animal -> not @@ check (animal.x, animal.y)

let move animal = animal.x <- animal.x +. 8.

let render_animal_at ~x ~y =
  GlMat.load_identity ();
  GlMat.translate3 (x, y, 0.);
  GlDraw.color (1., 1., 1.);
  GlDraw.begins `quads;
  List.iter GlDraw.vertex2
    [ (-5., -5.); (-5., 5.); (5., 5.); (5., -5.) ];
  GlDraw.ends ()

let render animal = render_animal_at ~x:animal.x ~y:animal.y