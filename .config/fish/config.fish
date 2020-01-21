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
function ranger -d 'Ranger stay in directory after exit.'
	set dir (mktemp -t ranger_cd.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosedir=$dir $argv
	cd (cat $dir)
	rm $dir
	commandline -f repaint
end
funcsave ranger

function ranger-open -d 'Interactive ranger opener using xdg-open.'
	set dir (mktemp -t ranger_open.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosefile=$dir $argv
	echo (cat $dir)
	nohup xdg-open (cat $dir) > /dev/null &
	rm $dir
end

function _send_command -d 'Send command through tmux if its running.'
	if [ -n "$TMUX" ];
		printf "\ePtmux;\e%s\e\\" $argv[1]
	else
		echo $argv[1]
	end
end

function _urxvt_command -d 'Issue urxvt command'
	[ (count $argv) -ne 2 ]; and return

	set -l command (printf "\e]%s;%s\007" "$argv[2]" "$argv[1]")
	_send_command $command
end

function color-switcher -d 'Change terminal color.'

	# Privide default value, if called without paramters
	if [ (count $argv) -eq 0 ]
	   set argv $argv 11
	end

	# Let user select the color
	set -l colors 'white\nblack\ngreen\nred'
	set -l selected_color ( echo -e $colors | rofi -dmenu -i)
	[ -z "$selected_color" ]; and return

	# Set the color
	_urxvt_command $selected_color $argv[1]
end

# TODO: Create new function with default fallbacks e.g
# User will pick dejavu font but this function will also by default append other fonts
# so everything in shell works just fine
function font-switcher -d 'Change terminal font.'
	# TODO: multi-select

	# Privide default value, if called without paramters
	if [ (count $argv) -eq 0 ]
	   set argv $argv 710
	end

	# Let user select the font
	set -l selected_font (fc-list | grep -i ttf | cut -d: -f2 | sort -ru | rofi -dmenu -i)
	[ -z "$selected_font" ]; and return

	# Format the font string
	# set -l formated_font (printf "xft:%s:pixelsize=21" $selected_font)
	set -l formated_font (printf "xft:%s:pixelsize=21, xft:Inconsolata Nerd Font Mono:style=Medium:pixelsize=21" $selected_font)

	# Set the font
	_urxvt_command $formated_font $argv[1]
end

function random-font -d 'Change terminal font to random one.'
	set -l selected_font (fc-list | grep -i ttf | cut -d: -f2 | sort -u | shuf | head -n1)
	[ -z "$selected_font" ]; and return

	# Format the font string
	set -l formated_font (printf "xft:%s:pixelsize=21:antialias=true, xft:Inconsolata Nerd Font Mono:style=Medium:pixelsize=21" $selected_font)

	echo "$formated_font"
	# Set the font
	_urxvt_command $formated_font 710
end

function terminal-control -d 'Entry point for terminal control.'

	# TODO: Those can be maybe global variables, that are destoried at the end
	# of this script? Also other references can be updated accordingly.
	set -l ESCAPE_NORMAL      710
	set -l ESCAPE_BOLD        711
	set -l ESCAPE_ITALICS     712
	set -l ESCAPE_BOLDITALICS 713
	set -l ESCAPE_FG          10
	set -l ESCAPE_BG          11

	if [ (count $argv) -ge 1 ]
		switch "$argv[1]"
			case font n normal
				font-switcher $ESCAPE_NORMAL
			case b bold
				font-switcher $ESCAPE_BOLD
			case i ita italics
				font-switcher $ESCAPE_ITALICS
			case bi bold-italics
				font-switcher $ESCAPE_BOLDITALICS
			case fg foreground
				color-switcher $ESCAPE_FB
			case bg background
				color-switcher $ESCAPE_BG
			case '*'
				echo 'Invalid command! Aborting...'
		end
	else
		font-switcher $ESCAPE_NORMAL
	end
end

function ranger-wallpaper -d 'Interactive ranger wallpaper setter using feh.'
	set dir (mktemp -t ranger_open.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosefile=$dir $argv $HOME/Pictures
	echo (cat $dir)
	feh --bg-fill (cat $dir)
	rm $dir
end

function ranger-wal -d 'Interactive ranger wallpaper setter using feh and wal.'
	set dir (mktemp -t ranger_open.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosefile=$dir $argv $HOME/Pictures
	echo (cat $dir)
	feh --bg-fill (cat $dir)
	wal -ni (cat $dir)
	rm $dir
end

function wal-theme -d 'Interactive theme setter for wal.'
	# Let user select the theme
	set -l selected_theme (wal --theme | grep -vF : | cut -d ' ' -f 3 | sort -u | rofi -dmenu -i)
	[ -z "$selected_theme" ]; and return

	wal --theme "$selected_theme"
end

# https://github.com/SidOfc/dotfiles/blob/master/config.fish#L67
function kp -d "Kill processes"
	set -l pid (ps -ef | tail -n +1 | fzf --tac -m --header='[kill:process]' | awk '{print $2}')
	[ -z "$pid" ]; and return

	if [ (count $argv) -eq 0 ]
		kill -9 "$pid"
	else
		kill $argv "$pid"
	end
end
