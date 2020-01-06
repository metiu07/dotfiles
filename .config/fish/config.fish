# Source alias file
source ~/.config/fish/aliases

set -g theme_nerd_fonts yes
set -g theme_display_date no
set -g theme_display_vi no

# Set EDITOR and VISUAL, preffer emacs
if command -v emacsclient >/dev/null 2>&1
	set -gx EDITOR "emacsclient -t"
	set -gx VISUAL "emacsclient -t"
else
	set -gx EDITOR /usr/bin/vim
	set -gx VISUAL /usr/bin/vim
end

# Let theme prompt handle the virtualenv indicator
set -gx VIRTUAL_ENV_DISABLE_PROMPT YES

# Makepkg should build packages with all available threads
set -gx MAKEFLAGS '-j'(nproc)

# Abbreviations
#
# Default python enviroment direcotry
set -l DEFAULT_ENV_DIR env
# Sourcing the python environment
abbr -a -g E ". $DEFAULT_ENV_DIR/bin/activate.fish"
# Creating the python environment
abbr -a -g EC "python3 -m venv $DEFAULT_ENV_DIR"

# Dynamicaly set the background color
# TODO: Move to aliases?
abbr -a -g white_bg 'printf "\033Ptmux;\033\033]11;white\007\033\\\\"'
abbr -a -g black_bg 'printf "\033Ptmux;\033\033]11;black\007\033\\\\"'

function fzf-complete -d 'fzf completion and print selection back to commandline'
	# As of 2.6, fish's "complete" function does not understand
	# subcommands. Instead, we use the same hack as __fish_complete_subcommand and
	# extract the subcommand manually.
	set -l cmd (commandline -co) (commandline -ct)
	switch $cmd[1]
		case env sudo
			for i in (seq 2 (count $cmd))
				switch $cmd[$i]
					case '-*'
					case '*=*'
					case '*'
						set cmd $cmd[$i..-1]
						break
				end
			end
	end
	set cmd (string join -- ' ' $cmd)

	set -l complist (complete -C$cmd)
	set -l result
	string join -- \n $complist | sort | eval (__fzfcmd) -m --select-1 --exit-0 --header '(commandline)' | cut -f1 | while read -l r; set result $result $r; end

	set prefix (string sub -s 1 -l 1 -- (commandline -t))
	for i in (seq (count $result))
		set -l r $result[$i]
		switch $prefix
			case "'"
				commandline -t -- (string escape -- $r)
			case '"'
				if string match '*"*' -- $r >/dev/null
					commandline -t --  (string escape -- $r)
				else
					commandline -t -- '"'$r'"'
				end
			case '~'
				commandline -t -- (string sub -s 2 (string escape -n -- $r))
			case '*'
				commandline -t -- (string escape -n -- $r)
		end
		[ $i -lt (count $result) ]; and commandline -i ' '
	end

	commandline -f repaint
end

# Automatically change the directory in fish after closing ranger
#
# This is a fish alias to automatically change the directory to the last visited
# one after ranger quits.
function ranger
	set dir (mktemp -t ranger_cd.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosedir=$dir $argv
	cd (cat $dir)
	rm $dir
	commandline -f repaint
end
funcsave ranger

function ranger-open
	set dir (mktemp -t ranger_open.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosefile=$dir $argv
	echo (cat $dir)
	nohup xdg-open (cat $dir) &
	rm $dir
end

# To bind Ctrl-O to ranger, save this in `~/.config/fish/config.fish`:
bind \co ranger
