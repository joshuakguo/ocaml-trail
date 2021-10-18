type wave = {
  mutable x : float;
  mutable y : float;
}

let approach ~pace =
  let y = pace in
  fun wave -> wave.y -. y wave

let render_wave () =
  GlDraw.color (0., 0.5, 1.);
  GlDraw.begins `lines;
  List.iter GlDraw.vertex2 [ (0., -1.); (0., 1.) ];
  GlDraw.ends

let render_wave_final wave =
  GlMat.load_identity ();
  GlMat.translate3 (wave.x, wave.y, 0.);
  render_wave ()
