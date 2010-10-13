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


use strict;
use warnings;

my $state = 'HEADER';

while (<>) {
    if ($state eq 'HEADER') {
	# Remove the title
	next if /^\s+Onotify\s+$/;

	# Remove any blank line
	next if /^\s*$/;

	# Change state when encountering the first section.
	$state = 'CORE' if /^[^\s]/;
    }

    if ($state eq 'DEAD_SECTION') {
	if (/^[^\s]/) {
	    $state = 'CORE';
	} else {
	    next;
	}
    }

    if ($state eq 'CORE') {
	# Remove the 'Current status' and 'Références' sections
	if (/^(Current status|Références)\s*$/) {
	    $state = 'DEAD_SECTION';
	    next
	}
	# Underline sections
	if (/^([^\s].*)\s*/) {
	    print "\n";
	    print;
	    print '*'x(length $1)."\n";
	    <>; # Eat the following blank line
	    next;
	}

	# Remove link refs
	s/\[\d+\]//g;
    }

    # Reaching this point, the line can be outputed.
    print;
}

    