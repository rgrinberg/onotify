OCAMLMKLIB	= ocamlmklib
OCAMLBUILD	= ocamlbuild
OCAMLBUILDFLAGS	= -build-dir $(BUILDDIR)

INC	   	= GNUmakefile.include

-include $(INC)

PREFIX	  ?= /usr/local
LIBDIR	  ?= /usr/local/lib/ocaml/site-lib
BUILDDIR  ?= _build


.PHONY: build
build: _build/src/stubs/libinotify_stubs.a
	@$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/build.otarget


.PHONY: conf
conf:
	@rm -f $(INC)
	@echo 'PREFIX   ?= $(PREFIX)'	>> $(INC)
	@echo 'LIBDIR   ?= $(LIBDIR)' 	>> $(INC)
	@echo 'BUILDDIR ?= $(BUILDDIR)'	>> $(INC)

.PHONY: clean
	@rm -f GNUmakefile.include
	@$(OCAMLBUILD) $(OCAMLBUILDFLAGS) -clean


_build/src/stubs/libinotify_stubs.a _build/src/stubs/dllinotify_stubs.so: _build/src/stubs/inotify_stubs.o
	@$(OCAMLMKLIB) -o _build/src/stubs/inotify_stubs $^

_build/src/stubs/inotify_stubs.o: src/stubs/inotify_stubs.c
	@$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/stubs/inotify_stubs.o


