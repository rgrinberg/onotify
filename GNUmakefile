MKDIR_P		= mkdir -p
RM_F		= rm -f
CONFIG		= GNUmakefile.config
GIT_ARCHIVE	= git archive

include $(CONFIG)

OCAMLBUILD	 = $(OCAMLDIST)/bin/ocamlbuild
OCAMLMKLIB	 = $(OCAMLDIST)/bin/ocamlmklib
LIBDIR		 = $(PREFIX)/lib/ocaml/site-lib
DISTNAME 	 = $(PKGNAME)-$(PKGVER)
DISTREV 	?= HEAD
LIBFILES	 = $(foreach ext,a cma cmxa d.cma, $(BUILDDIR)/src/inotify.$(ext))
BUILDSTUBS	 = $(BUILDDIR)/src/stubs

.PHONY: build
build: $(BUILDDIR)/src/stubs/libinotify_stubs.a
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/inotify.otarget

.PHONY: clean
clean:
	$(P)$(RM_F) $(CLEANFILES)
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) -clean

.PHONY: install
install: build
	$(P)$(MKDIR_P) $(LIBDIR)
	$(P)$(OCAMLFIND) install $(OCAMLFINDFLAGS) inotify META $(LIBFILES)

.PHONY: dist
dist:
	$(P)$(GIT_ARCHIVE) --prefix=$(DISTNAME)/ $(DISTREV) . | bzip2 > $(DISTNAME).tar.bz2

.PHONY: test
test:
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) -Is src -libs unix -lflag src/stubs/libinotify_stubs.a tests/test_inotify.native


$(BUILDSTUBS)/libinotify_stubs.a $(BUILDSTUBS)/dllinotify_stubs.so: $(BUILDSTUBS)/inotify_stubs.o
	$(P)$(OCAMLMKLIB) -o $(BUILDSTUBS)/inotify_stubs $^

$(BUILDSTUBS)/inotify_stubs.o: src/stubs/inotify_stubs.c
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/stubs/inotify_stubs.o


