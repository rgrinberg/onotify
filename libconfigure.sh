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


msg()		{ if $verbose; then echo "$1"; fi		    ;}
checking()	{ if $verbose; then echo -n "Checking $1 ... "; fi  ;}

echoerr()	{ echo "$1" >&2					    ;}
error()		{ echoerr "Error: $1"				    ;}
fatal()		{ error "$1" && exit 1				    ;}

find_program()	{ which "$1" 2>/dev/null			    ;}
config()	{ echo "$1" >> $buildconf			    ;}
config_file()	{ msg "Configuring $1"; sed -re "$2" $1.in > $1	    ;}

check_help_request() {
    case $# in
	1)
	    case $1 in
		-h|--help) print_usage
	    esac
    esac
}


check_ocamldist() {
    for tool in \
	ocamlc ocamlopt ocamlc.opt ocamlopt.opt ocamlbuild ocamlmklib ; do
	checking "for $tool"
	if [ -f $1/bin/$tool -a -x $1/bin/$tool ] ; then
	    msg 'yes'
	else
	    msg 'no'
	    return 1
	fi
    done

    return 0
}

find_ocamldist() {
    checking 'for ocamlbuild in $PATH'
    ocamlbuild=`find_program ocamlbuild`
    if [ $? -eq 0 ] ; then
	msg $ocamlbuild
	ocamldist=`dirname $ocamlbuild`/..
	ocamldist=`readlink -f $ocamldist`
	msg "Checking whether $ocamldist contains a valid OCaml distribution"
	if ! check_ocamldist "$ocamldist" ; then
	    return 1
	fi
    else
	msg 'no'
	return 1
    fi
}



check_ocamlfind() {
    [ -f $1/bin/ocamlfind -a -x $1/bin/ocamlfind ]
}

find_ocamlfind() {
    checking "for ocamlfind in the installation path ($1)"
    if check_ocamlfind "$1" ; then
	msg 'yes'
	ocamlfind_in_installdir=true
	ocamlfind=$1/bin/ocamlfind
	return 0
    else
	msg 'no'
    fi

    checking 'for ocamlfind in $PATH'
    ocamlfind=`find_program ocamlfind`
    if [ $? -eq 0 ] ; then
	msg $ocamlfind
	msg 'Deactivating the update of the ocamlfind ld.conf'
	OCAMLFINDFLAGS="$OCAMLFINDFLAGS -ldconf ignore"
	return 0
    else
	msg 'no'
    fi
    
    return 1
}

__find_lib() {
    __search_path=`echo $OCAMLINCLUDES | tr , ' '`
    __search_path="$__search_path "`$ocamldist/bin/ocamlc -where`

    for p in $__search_path ; do
	if [ -f $p/$1.cmi ] && [ -f $p/$1.$2 ] ; then
	    echo $p
	    return 0
	fi
    done

    return 1
}

find_byte_lib()	    { __find_lib $1 cma					;}
find_native_lib()   { __find_lib $1 cmxa				;}
find_lib()	    { find_byte_lib $1 >/dev/null && find_native_lib $1 ;}

