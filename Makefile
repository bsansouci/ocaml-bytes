DESTDIR=
prefix=/usr/local
exec_prefix=${prefix}
LIBDIR=$(DESTDIR)${exec_prefix}/lib/bytes
HAS_BYTES=no

OCAMLC   = 
OCAMLOPT = 

all: no.@OCAMLBEST@

no.byte: bytes.cma
no.opt: no.byte bytes.cmxa bytes.cmxs

yes.byte:
yes.opt: yes.byte

bytes.cmi: bytes.mli
	$(OCAMLC) -c bytes.mli

bytes.cmo: bytes.cmi bytes.ml
	$(OCAMLC) -c bytes.ml

bytes.cmx: bytes.cmi bytes.ml
	$(OCAMLOPT) -c bytes.ml

bytes.cma: bytes.cmo
	$(OCAMLC) -a bytes.cmo -o bytes.cma

bytes.cmxa: bytes.cmx
	$(OCAMLOPT) -a bytes.cmx -o bytes.cmxa

bytes.cmxs: bytes.cmx
	$(OCAMLOPT) -shared bytes.cmx -o bytes.cmxs

clean:
	rm -f bytes.cmi bytes.cmo bytes.cmx bytes.cma bytes.cmxa bytes.cmxs bytes.a bytes.o

distclean: clean
	rm -f config.log config.status Makefile

install: install.no.@OCAMLBEST@

install.META:
	mkdir -p "$(LIBDIR)"
	cp -f META.no "$(LIBDIR)"/META

install.yes.byte: install.META
install.yes.opt: install.yes.byte

install.no.byte: no.byte install.META
	cp -f bytes.cmi bytes.cmo bytes.cma "$(LIBDIR)"

install.no.opt: no.opt install.no.byte
	cp -f bytes.a bytes.cmx bytes.cmxa bytes.cmxs "$(LIBDIR)"

uninstall:
	rm -rf "$(LIBDIR)"

.PHONY: all no.byte no.opt yes.byte yes.opt install \
	install.META install.no.byte install.yes.byte \
	install.no.opt install.yes.opt uninstall clean distclean
