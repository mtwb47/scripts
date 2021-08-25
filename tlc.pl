#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# Simple PERL script which endeavours to display the subscriber count for the
# YouTube channel 'The Linux Cast', by parsing the channel's 'about' page. This
# is suitable for use in a bar, such as in a tiling window manager.
#
# Written in an Ubuntu-based distribution with packages:
#
#   libwww-perl (>= 6.31-1)
#   perl (>= 5.22.1-9)
#------------------------------------------------------------------------------

require LWP::UserAgent;

use v5.22.1;
use strict;
use warnings;
use LWP::UserAgent;

my $UA = LWP::UserAgent->new(
	'agent' => 'Mozilla/5.0',
	'protocols_allowed' => ['http', 'https'],
	'max_redirect' => 3,
	'timeout' => 10
);

my $Response = $UA->get('https://www.youtube.com/c/TheLinuxCast/about');
$Response or exit(1);

# As long as you have at least 1 subscriber, the REGEX should work.
foreach (split("\n", $Response->decoded_content())) {
	if (/"label":"(.*) subscribers"}}/) {
		print("$1\n");
		last()
	}
}
