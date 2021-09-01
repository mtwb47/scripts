#!/bin/bash -n

#------------------------------------------------------------------------------
# Project Name      -
# Started On        - Sun 29 Aug 21:54:01 BST 2021
# Last Change       - Sun 29 Aug 22:43:32 BST 2021
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#------------------------------------------------------------------------------
# Written for Matt, a YouTube content creator 'The Linux Cast'. This was of
# course heavily inspired by Matt's 'dwminstall.sh' script, and endeavors to do
# generally the same thing, but in an improved way.
#------------------------------------------------------------------------------

GHDomain='https://github.com'

# NerdFonts URL used for 'Hack.zip' when APT is found.
NerdFontsURL="$GHDomain/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip"

# Packages installed by `pacman` in Arch-based distributions.
ArchDeps=(sxhkd alacritty rofi feh base-devel lm_sensors trizen)

# Packages installed by `apt-get` in Ubuntu-based distributions.
UbuntuDeps=(sxhkd kitty rofi build-essential libx11-dev lm-sensors feh)
UbuntuDeps+=(libxinerama-dev sharutils suckless-tools libxft-dev libc6)

#-------------------------------------------------------------------------Begin

function Err {
	printf 'Err: %s\n' "$2" 1>&2
	[ $1 -gt 0 ] && exit $1
}

function DepChk {
	DepCount=0
	for Dep in "$@"; {
		if ! type -P "$Dep" &> /dev/null; then
			Err 0 "Dependency '$Dep' not met."
			let DepCount++
		fi
	}

	(( DepCount > 0 )) && return 1
}

#[ $UID -eq 0 ] || Err 1 'Root access is required for system-wide changes.'

while read; do
	printf '%s\n' "$REPLY"
done <<-EOF

	This installer was written by Terminalforlife, but the DWM configuration
	itself is by a fellow YouTube content creator, The Linux Cast.

	CAUTION: You're about to make various system-wide changes.

EOF

#read -n 1 -ep 'Press any key to continue... '

#----------------------------------------Begin Installing Software Dependencies

printf '* Installing dependencies...\n'

if DepChk pacman; then
	printf 'Found pacman(8) in PATH.\n'

	if ! pacman -S "${ArchDeps[@]}"; then
		Err 1 'Failed to install one or more dependencies with pacman(8).'
	fi
elif DepChk apt-get; then
	printf 'Found apt-get(8) in PATH.\n'

	if apt-get install "${UbuntuDeps[@]}"; then
		#TODO: Add support for cURL.
		if wget -q --show-progress "$NerdFontsURL"; then
			if unzip Hack.zip; then
				if mkdir -p "$HOME"/.local/share/fonts/nerdfonts/Hack; then
					if mv *.ttf "$HOME"/.local/share/fonts/nerdfonts/Hack/; then
						if ! fc-cache -f -v; then
							Err 1 "Failed to regenerate font cache with fc-cache(1)."
						fi
					else
						Err 1 "Failed to move '*.ttf' files with mv(1)."
					fi
				else
					Err 1 "Failed to make 'Hack' directory with mkdir(1)."
				fi
			else
				Err 1 "Failed to uncompress 'Hack.zip' with unzip(1)."
			fi
		else
			Err 1 "Failed to download 'Hack.zip' with wget(1)."
		fi
	else
		Err 1 'Failed to install one or more dependencies with apt-get(8).'
	fi
else
	Err 1 "Neither pacman(8) nor apt-get(8) were found."
fi
