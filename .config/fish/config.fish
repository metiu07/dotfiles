#  _____  _       _                           __  _
# |  ___|(_) ___ | |__     ___  ___   _ __   / _|(_)  __ _
# | |_   | |/ __|| '_ \   / __|/ _ \ | '_ \ | |_ | | / _` |
# |  _|  | |\__ \| | | | | (__| (_) || | | ||  _|| || (_| |
# |_|    |_||___/|_| |_|  \___|\___/ |_| |_||_|  |_| \__, |
#                                                    |___/

# Initlialize aliases
source ~/.config/fish/aliases

# Vim
# `fish_key_reader` - check the SEQUENCE
# `bind -f`         - show possible commands
fish_vi_key_bindings
bind \cO -M insert 'cd -; commandline -f repaint'
bind \cO 'cd -; commandline -f repaint'
bind \cF -M insert accept-autosuggestion
bind \cF accept-autosuggestion
bind \cP -M insert up-or-search
bind \cN -M insert down-or-search
bind \cE -M insert end-of-line
bind \cE end-of-line
bind \cA -M insert beginning-of-line
bind \cA beginning-of-line

# Let theme prompt handle the virtualenv indicator
set -gx VIRTUAL_ENV_DISABLE_PROMPT YES

# Pure theme configuration
# set -g pure_symbol_prompt '❯'  # Default
# set -g pure_symbol_prompt ''  # RPI
# set -g pure_symbol_prompt ''  # RPI
# set -g pure_symbol_prompt ''  # RPI
# set -g pure_symbol_prompt '拾'  # School
set -g pure_symbol_prompt 'ﬦ'  # Default

# Bob the fish theme configuration
# set -g theme_nerd_fonts yes
# set -g theme_display_date no
# set -g theme_display_vi no

# Set TERM to allow for true color in terminal
set -gx TERM "tmux-256color"

# Customize path variable
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.cargo/bin

# Set EDITOR and VISUAL, prior emacs -> nvim -> vim -> nano
if command -v nvim >/dev/null 2>&1
	set -gx EDITOR nvim
	set -gx VISUAL nvim
	# Also preffer nvim over vim
	functions -e vim; alias vim='nvim'
else if command -v vim >/dev/null 2>&1
	set -gx EDITOR vim
	set -gx VISUAL vim
else
	set -gx EDITOR nano
	set -gx VISUAL nano
end

# Setup the ls aliases preffer exa
if command -v exa >/dev/null 2>&1
	functions -e ls; alias ls='exa --icons --group-directories-first'
	functions -e ll; alias ll='exa --icons -laF --group-directories-first'
	functions -e lll; alias lll='exa -laF --icons --tree --level=2 --group-directories-first'
else if command -v lsd >/dev/null 2>&1
	functions -e ls; alias ls='lsd -F --group-dirs first --color=auto'
	functions -e ll; alias ll='lsd -FlA --group-dirs first --date=relative --blocks=permission,user,size,date,name --color=auto'
end

if command -v bat >/dev/null 2>&1
	functions -e cat; alias cat='bat -n'
	functions -e bat; alias rat='bat -nA'
end

alias notif='notify-send "Task finished" "Exit code: $status"'

# Set vim configuration
set -gx VIMINIT "source ~/.config/vim/vimrc"

# Set ipython configuration home
set -gx IPYTHONDIR "$HOME/.config/ipython"

# Set weechat configuration home
set -gx WEECHAT_HOME "$HOME/.config/weechat"

# Set taskwarrior and timewarrior configuration
set -gx TASKRC ~/.config/task/.taskrc
set -gx TIMEWARRIORDB ~/.config/task/.timewarrior.cfg

# Makepkg should build packages with all available threads
set -gx MAKEFLAGS '-j'(nproc)

# Abbreviations
#
# Default python enviroment directory
set -l DEFAULT_ENV_DIR env
# Sourcing the python environment
abbr -a -g E ". $DEFAULT_ENV_DIR/bin/activate.fish"
# Sourcing the global python environment
abbr -a -g EE "source_global"
# Creating the python environment
abbr -a -g EC "python3 -m venv $DEFAULT_ENV_DIR"
# Deactivate the python environment
abbr -a -g D "deactivate"

# Reload fish configuration
abbr -a -g RE ". ~/.config/fish/config.fish"

# Pacman helpers
abbr -a -g SYU "sudo pacman -Syu"
abbr -a -g SS "pacman -Ss"
abbr -a -g SI "pacman -Si"
abbr -a -g QL "pacman -Ql | grep "

# Add ssh-key
abbr -a -g SA "_ssh-add"

# Git shortcut
abbr -a -g g "git"

# This is a fish alias to automatically change the directory to the last visited
# one after ranger quits.
function cdranger -d 'Ranger stay in directory after exit.'
	set dir (mktemp -t ranger_cd.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosedir=$dir $argv
	cd (cat $dir)
	rm $dir
	commandline -f repaint
end

function ranger-open -d 'Interactive ranger opener using xdg-open.'
	set dir (mktemp -t ranger_open.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosefile=$dir $argv
	echo (cat $dir)
	nohup xdg-open (cat $dir) > /dev/null &
	rm $dir
end

function ranger-wallpaper -d 'Interactive ranger wallpaper setter using feh.'
	set dir (mktemp -t ranger_open.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosefile=$dir $argv $HOME/Pictures
	echo (cat $dir)
    wallpaper (cat $dir)
	rm $dir
end

function ranger-wal -d 'Interactive ranger wallpaper and theme generator using feh and wal.'
	set dir (mktemp -t ranger_open.XXX)
	set ranger_bin (which ranger)
	$ranger_bin --choosefile=$dir $argv $HOME/Pictures
	echo (cat $dir)
	wallpaper (cat $dir)
	wal -ni (cat $dir)
	rm $dir
end


# TODO: Create function to detect terminal emulator
# TODO: Create backup function (cpbackup <file> -> cp <file> <file>.backup)

function _wallpaper_sway -d 'Set the wallpaper on sway.'
	killall -q swaybg
	nohup swaybg -i "$argv[1]" -m fill 2>&1 >/dev/null &
end

function _wallpaper_feh -d 'Set the wallpaper with feh.'
	# TODO: Not implemented
	echo "Not implemented"
end

# TODO: Add a way to blur the image
function wallpaper -d 'Set the wallpaper.'
	if [ (count $argv) -eq 1 ];
		set _wallpaper_path "$argv[1]"
	else
		# TODO: If the are no wallpapers set the solid color
		set _wallpaper_path (fd . ~/Pictures/Wallpapers | shuf -n 1)
		# set _wallpaper_path (mktemp -t wallpaper.XXX)
		# set _random_wallpaper (fd . ~/Pictures/Wallpapers | shuf -n 1)
		# convert "$_random_wallpaper" -blur 0x5 "$_wallpaper_path"
	end

	# TODO: Create function to detect window manager
	_wallpaper_sway "$_wallpaper_path"
end

function _tmux_send_command -d 'Send command through tmux if its running.'
	if [ -n "$TMUX" ];
		printf "\ePtmux;\e%s\e\\" $argv[1]
	else
		echo $argv[1]
	end
end

function _urxvt_command -d 'Issue urxvt command'
	[ (count $argv) -ne 2 ]; and return

	set -l command (printf "\e]%s;%s\007" "$argv[2]" "$argv[1]")
	_tmux_send_command $command
end

function _urxvt_set_font -d 'Set the urxvt font'
	[ (count $argv) -ne 2 ]; and return

	set -l formated_font (printf "xft:%s:pixelsize=21:antialias=true, xft:Inconsolata Nerd Font Mono:style=Medium:pixelsize=21" $selected_font)
	set -l command (printf "\e]%s;%s\007" "$argv[2]" "$formated_font")
	_tmux_send_command $command
end

function _alacritty_set_font  -d 'Set the font in alacritty terminal'
    sed -i "s/^\(\s*family:\)\(.*\)/\1 $argv[1]/g" ~/.config/alacritty/alacritty.yml
end

function color-switcher -d 'Change terminal color.'

	# Provide default value, if called without paramters
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

# TODO: Create fzf alternative
# TODO: Create dmenu alternative
# TODO: User can change default selecter via the variable
function _rofi_select_font -d 'Select the font using rofi'
	string trim (fc-list | grep -i ttf | cut -d: -f2 | sort -ru | rofi -dmenu -i)
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
	set -l selected_font (_rofi_select_font)
	[ -z "$selected_font" ]; and return

	# Format the font string
	# set -l formated_font (printf "xft:%s:pixelsize=21" $selected_font)
    # set -l formated_font (printf "xft:%s:pixelsize=21, xft:Inconsolata Nerd Font Mono:style=Medium:pixelsize=21" $selected_font)

	# Set the font
    # _urxvt_command $formated_font $argv[1]
    _alacritty_set_font "$selected_font"
end

function random-font -d 'Change terminal font to random one.'
	set -l selected_font (fc-list | grep -i ttf | cut -d: -f2 | sort -u | shuf | head -n1)
	[ -z "$selected_font" ]; and return
	echo "$selected_font"

	# Set the font
	# _urxvt_set_font $formated_font 710
	_alacritty_set_font "$selected_font"
end

# TODO: Create separate package for terminal functions
function terminal-control -d 'Entry point for terminal control.'

	# TODO: Those can be maybe global variables, that are destoried at the end
	# of this script? Also other references can be updated accordingly.
	set -l ESCAPE_NORMAL      710
	set -l ESCAPE_BOLD        711
	set -l ESCAPE_ITALICS     712
	set -l ESCAPE_BOLDITALICS 713
	set -l ESCAPE_FG          10
	set -l ESCAPE_BG          11

	# TODO: Better handle italics, style prob cannot be medium for all fonts
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

function wal-theme -d 'Interactive theme setter for wal.'
	# Let user select the theme
	set -l selected_theme (wal --theme | grep -vF : | cut -d ' ' -f 3 | sort -u | rofi -dmenu -i)
	[ -z "$selected_theme" ]; and return

	wal --theme "$selected_theme"
end

function mm -d "Interactive Makefile"
	# TODO: Display the name of the default rule invoked with "make"
	set -l _makefile "Makefile"
	[ (count $argv) -eq 1 ] && set -l _makefile $argv[1]
	[ ! -f "$_makefile" ] && return
	set -l make_target (cat "$_makefile" | grep -P '^[^\.][\w-]*:([^=].*|)$' | sed 's/\(.*\):.*/\1/' | uniq | fzf --height 15 --prompt "Select make target: " --layout=reverse --preview="sed -n '/^{1}\s*:/,/^\$/p' '$_makefile'")
    [ -z "$make_target" ] && return
	make "$make_target"
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

function ff -d "Interactive find file"
	set -l _dir '.'
	[ (count $argv) -eq 1 ] && set -l _dir $argv[1]
	# TODO: Handle multiselection
	# TODO: Check if anything was selected?
	# TODO: Allow to provide custom query to open a new file?
	# TODO: Fzf info=inline looks nice
	set -l selected_file (fd --hidden --type f -E '.git' -E 'env' . "$_dir" | fzf -m --prompt "Select a file: ")
	[ -z "$selected_file" ] && return
	realpath $selected_file
end

function fp -d "Interactive find file in project"
	# TODO: Rice fzf here
	set -l project_dir (command ls ~/dev | fzf --height 15 --prompt "Select a project: " --layout=reverse)
	[ -z "$project_dir" ] && return
	pushd "$HOME/dev/$project_dir"
	ff
	popd
end

function vimp -d "Interactive vim open file in a project"
	# TODO: Rice fzf here
	set -l project_dir (command ls ~/dev | fzf --height 15 --prompt "Select a project: " --layout=reverse)
    [ -z "$project_dir" ] && return
	pushd "$HOME/dev/$project_dir"
	vim (ff)
	popd
end

function source_global -d "Interactive source python env"
	# TODO: Handle multiselection
	# TODO: Can we preview packages in the venv?
	set -l _env (fd -I -t d -d 4 '^v?env' "$HOME" | fzf --height 15 --prompt "Select environment to source: " --layout=reverse)
	[ -z "$_env" ] && return
	set -l _activate_file "$_env/bin/activate.fish"
	[ -f "$_activate_file" ] && source "$_activate_file" || echo "Cannot find file: \"$_activate_file\""
end

# TODO: Create separate package for docker functions
# TODO: Maybe swap the order of selected_container and argv, this is preffered I think
function _select-docker-container -d "Helper function to select docker container"
	set -l preview_format "Name:\t\t{{.Names}}\nCommand:\t{{.Command}}\nStatus:\t\t{{.Status}}\nSize:\t\t{{.Size}}\nPorts:\t\t{{.Ports}}\nMounts:\t\t{{.Mounts}}\nNetworks:\t{{.Networks}}"
	set -l containers (sudo docker ps --format "{{.Names}}" $argv)
	set -l selected_container (echo "$containers" | tr ' ' '\n' | fzf --preview="sudo docker ps --filter 'name={1}' --format '$preview_format'" | cut -d " " -f 2)
	echo "$selected_container"
end

function docker-bash -d "Spawn bash in docker"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	sudo docker exec -it "$selected_container" bash $argv
end

function docker-attach -d "Attach to a docker container"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	sudo docker attach "$selected_container"
end

function docker-kill -d "Kill docker container"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	sudo docker kill "$selected_container" $argv
end

function docker-restart -d "Restart docker container"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	sudo docker restart "$selected_container" $argv
end

function docker-log -d "Display container logs"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	sudo docker logs "$selected_container" $argv
end

function docker-rmi -d "Remove docker images"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	sudo docker rmi "$selected_container" $argv
end

function _ssh-add -d "Add new ssh-key to the ssh-agent"
	# Startup the ssh-agent if not running
	[ -z "$SSH_AGENT_PID" ] && eval (ssh-agent -c)

	set -l _key (fd 'id_.*[^\.][^p][^u][^b]$' ~/.ssh/ | fzf --height 15 --prompt "Select a key to add: " --layout=reverse)
	# TODO: Check if they _key is valid
	ssh-add "$_key"
end

function _ttest -d "Test terminal capabilities"

	# curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt

	echo -e "\e[1mbold\e[0m"
	echo -e "\e[3mitalic\e[0m"
	echo -e "\e[4munderline\e[0m"
	echo -e "\e[9mstrikethrough\e[0m"
	echo -e "\e[31mHello World\e[0m"
	echo -e "\x1B[31mHello World\e[0m"

	msgcat --color=test

	# If the color ramp is perfectly smooth, true color is supported.
	# Source: https://gist.github.com/XVilka/8346728
	awk 'BEGIN{
		s="/\\\\/\\\\/\\\\/\\\\/\\\\"; s=s s s s s s s s;
		for (colnum = 0; colnum<77; colnum++) {
			r = 255-(colnum*255/76);
			g = (colnum*510/76);
			b = (colnum*255/76);
			if (g>255) g = 510-g;
			printf "\033[48;2;%d;%d;%dm", r,g,b;
			printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
			printf "%s\033[0m", substr(s,colnum+1,1);
		}
		printf "\n";
	}'
end

function color_picker -d "Color picker functionality"
	set -l PIXEL (slurp -p)
	set -l COLOR (grim -g "$PIXEL" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-)
	notify-send -t 10000 "$COLOR"
	echo "$COLOR" | sed -n 's/.*\(#......\).*/\1\n/p' | wl-copy
end
