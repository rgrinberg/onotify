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

.PHONY: stubs
stubs:
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/stubs/inotify_stubs.otarget

.PHONY: build
build: stubs
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
test: stubs
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) tests/test_inotify.native

