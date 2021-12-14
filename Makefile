build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

clean:
	dune clean

start:
	dune exec bin/main.exe

install-deps:
	opam install lablTk
	opam install lablgl

zip:
	rm -f ocaml-trail.zip
	zip -r ocaml-trail.zip . -x@exclude.lst

doc:
	dune build @doc