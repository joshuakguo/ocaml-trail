build:
	dune build

clean:
	dune clean

start:
	dune exec bin/main.exe

install-deps:
	opam install lablTk
	opam install lablgl