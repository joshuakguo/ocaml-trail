build:
	obuild configure && obuild build

clean:
	obuild clean

start:
	$(MAKE) build
	./ocaml-trail
	$(MAKE) clean

install-deps:
	opam install obuild
	opam install lablTk
	opam install lablgl