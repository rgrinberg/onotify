# Copyright (C) 2010 Ludovic Stordeur <ludovic@okazoo.eu>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; version 2.1 only. with the special
# exception on linking described in file LICENSE.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.


MKDIR_P		 = mkdir -p
RM_F		 = rm -f
GIT_ARCHIVE	 = git archive
CP_R		 = cp -r
SCP_R		 = scp -r
CONFIG		 = GNUmakefile.config

include $(CONFIG)

OCAMLBUILD	 = $(OCAMLDIST)/bin/ocamlbuild
OCAMLMKLIB	 = $(OCAMLDIST)/bin/ocamlmklib
DISTNAME 	 = $(PKGNAME)-$(PKGVER)
DISTREV 	?= HEAD
LIBSTUBS	 = dllinotify_stubs.so libinotify_stubs.a
LIBFILES	 = $(foreach ext,mli cmi a cma cmxa, $(BUILDDIR)/src/inotify.$(ext))
LIBFILES	+= $(foreach file, $(LIBSTUBS), $(BUILDDIR)/src/stubs/$(file))
OCAMLFORGE_URL	 = lstordeur@ssh.ocamlcore.org:/home/groups/onotify/htdocs

.PHONY: build
build: lib stubs doc

.PHONY: lib
lib:
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/inotify.otarget

.PHONY: stubs
stubs:
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/stubs/inotify_stubs.otarget

.PHONY: doc
doc:
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) src/inotify.docdir/index.html


.PHONY: test
test: stubs
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) tests/test_inotify.byte tests/test_inotify.native

.PHONY: clean distclean
clean:
	$(P)$(OCAMLBUILD) $(OCAMLBUILDFLAGS) -clean

distclean: clean
	$(P)$(RM_F) $(CLEANFILES)


.PHONY: install
install: build
	$(P)$(MKDIR_P) $(LIBDIR)
	$(P)$(MKDIR_P) $(DOCDIR)/html
	$(P)$(OCAMLFIND) install $(OCAMLFINDFLAGS) onotify META $(LIBFILES)
	$(P)$(CP_R) LICENSE $(DOCDIR)/
	$(P)$(CP_R) $(BUILDDIR)/src/inotify.docdir/* $(DOCDIR)/html/
	
.PHONY: dist
dist:
	$(P)$(GIT_ARCHIVE) --prefix=$(DISTNAME)/ $(DISTREV) . | bzip2 > $(DISTNAME).tar.bz2

.PHONY: push-website
push-website:
	$(P)$(SCP_R) website/* $(OCAMLFORGE_URL)/

.PHONY: push-api-doc
push-api-doc: doc
	$(P)$(SCP_R) inotify.docdir/* $(OCAMLFORGE_URL)/api/

