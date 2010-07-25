OCAMLMKLIB	= ocamlmklib
OCAMLBUILD	= ocamlbuild
OCAMLBUILDFLAGS	= -build-dir $(BUILDDIR)
CONFIG		= GNUmakefile.config

include $(CONFIG)

LIBFILES = $(foreach ext,a cma cmxa, $(BUILDDIR)/src/inotify.$(ext))

.PHONY: build
build: $(BUILDDIR)/src/stubs/libinotify_stubs.a
	@$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/inotify.otarget

.PHONY: clean
clean:
	@rm -f $(CONFIG)
	@$(OCAMLBUILD) $(OCAMLBUILDFLAGS) -clean

.PHONY: install
install: build
	@mkdir -p $(LIBDIR)
	$(OCAMLFIND) install $(OCAMLFINDFLAGS) inotify META $(LIBFILES)


$(BUILDDIR)/src/stubs/libinotify_stubs.a $(BUILDDIR)/src/stubs/dllinotify_stubs.so: $(BUILDDIR)/src/stubs/inotify_stubs.o
	@$(OCAMLMKLIB) -o $(BUILDDIR)/src/stubs/inotify_stubs $^

$(BUILDDIR)/src/stubs/inotify_stubs.o: src/stubs/inotify_stubs.c
	@$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/stubs/inotify_stubs.o


