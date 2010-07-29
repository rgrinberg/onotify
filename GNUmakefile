MKDIR_P		= mkdir -p
RM_F		= rm -f
GIT_ARCHIVE	= git archive
CP_R		= cp -r

CONFIG		= GNUmakefile.config
include $(CONFIG)

OCAMLBUILD	 = $(OCAMLDIST)/bin/ocamlbuild
OCAMLMKLIB	 = $(OCAMLDIST)/bin/ocamlmklib
DISTNAME 	 = $(PKGNAME)-$(PKGVER)
DISTREV 	?= HEAD
LIBFILES	 = $(foreach ext,a cma cmxa d.cma, $(BUILDDIR)/src/inotify.$(ext))
BUILDSTUBS	 = $(BUILDDIR)/src/stubs



.PHONY: build
build: lib doc

.PHONY: lib doc
lib: $(BUILDDIR)/src/stubs/libinotify_stubs.a
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/inotify.otarget

doc:
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/inotify.docdir/index.html

.PHONY: clean
clean:
	$(P)$(RM_F) $(CLEANFILES)
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) -clean

.PHONY: install
install: build
	$(P)$(MKDIR_P) $(LIBDIR)
	$(P)$(MKDIR_P) $(DOCDIR)/html
	$(P)$(OCAMLFIND) install $(OCAMLFINDFLAGS) inotify META $(LIBFILES)
	$(P)$(CP_R) LICENSE $(DOCDIR)/
	$(P)$(CP_R) $(BUILDDIR)/src/inotify.docdir/* $(DOCDIR)/html/
	
.PHONY: dist
dist:
	$(P)$(GIT_ARCHIVE) --prefix=$(DISTNAME)/ $(DISTREV) . | bzip2 > $(DISTNAME).tar.bz2




$(BUILDSTUBS)/libinotify_stubs.a $(BUILDSTUBS)/dllinotify_stubs.so: $(BUILDSTUBS)/inotify_stubs.o
	$(P)$(OCAMLMKLIB) -o $(BUILDSTUBS)/inotify_stubs $^

$(BUILDSTUBS)/inotify_stubs.o: src/stubs/inotify_stubs.c
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/stubs/inotify_stubs.o


