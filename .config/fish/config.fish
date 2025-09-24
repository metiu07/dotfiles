#  _____  _       _                           __  _
# |  ___|(_) ___ | |__     ___  ___   _ __   / _|(_)  __ _
# | |_   | |/ __|| '_ \   / __|/ _ \ | '_ \ | |_ | | / _` |
# |  _|  | |\__ \| | | | | (__| (_) || | | ||  _|| || (_| |
# |_|    |_||___/|_| |_|  \___|\___/ |_| |_||_|  |_| \__, |
#                                                    |___/

if test (uname) = "Darwin"

    function mac-notify-send -d "Send a notification on MacOS"
        osascript -e "display notification \"$argv\" with title \"Notification\""
    end

    eval "$(/opt/homebrew/bin/brew shellenv)"

    alias base64="gbase64"
    alias grep="ggrep"
    alias date="gdate"
    alias mktemp="gmktemp"
    alias nproc="sysctl -n hw.ncpu"
    alias split="gsplit"
    alias wl-copy="pbcopy"
    alias wl-paste="pbpaste"
    alias notify-send="mac-notify-send"
    alias alert="osascript -e 'display notification DONE with title "Notification"'; bell"

    # gke-gcloud-auth-plugin
    source (brew --prefix)/share/google-cloud-sdk/path.fish.inc

    # setup fzf
    fzf --fish | source

    # Setup test containers with rancher
    set -x TESTCONTAINERS_HOST_OVERRIDE (rdctl shell ip a show rd0 | awk '/inet / {sub("/.*",""); print $2}')

    # Fix the keybindings in the `man` pager
    set -gx MANPAGER "less"
else if test (uname) = "Linux"
    alias alert="notify-send -u critical -t 360000 DONE; bell"
end

# Initialize aliases
source ~/.config/fish/aliases

# Vim
# `fish_key_reader` - check the SEQUENCE
# `bind -f`         - show possible commands

# Use fzf_key_bindings if installed
# TODO: Maybe I can replace this with `fzf --fish | source` also on Linux
if functions -q fzf_key_bindings
    fzf_key_bindings
end

# Let theme prompt handle the virtualenv indicator
set -gx VIRTUAL_ENV_DISABLE_PROMPT YES

# Disable the greeting message
set -gx fish_greeting ""

# Enable starship
if command -v starship >/dev/null 2>&1
    source (starship init fish --print-full-init | sed 's/fish_vi_key_bindings/fish_vi_colemak_key_bindings/' | psub)
end

# Enable zoxide
zoxide init fish | source

# Customize path variable
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.cargo/bin
set -gx PATH $PATH $HOME/.yarn/bin
set -gx PATH /usr/lib/cargo/bin $PATH 
set -gx PATH /usr/local/bin $PATH 

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

# Set the fzf color theme (https://github.com/junegunn/fzf/wiki/Color-schemes)
# Light
set -x FZF_DEFAULT_OPTS "\
   --color light
   --bind=\"ctrl-k:down,ctrl-e:up\""
# Gruvbox
# set -x FZF_DEFAULT_OPTS "\
#    --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
#    --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
#    --bind=\"ctrl-k:down,ctrl-e:up\""
# Nord
# set -x FZF_DEFAULT_OPTS "\
#    --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C \
#    --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B"

# Set the colorscheme for gh cli
set -x GLAMOUR_STYLE light

# Forbid poetry from always asking for the password
set -gx PYTHON_KEYRING_BACKEND keyring.backends.null.Keyring

# Forbid pip from installing packages globally
set -gx PIP_REQUIRE_VIRTUALENV 1

# Setup the ls aliases preffer exa
if command -v eza >/dev/null 2>&1
    # eza must be first since, it also setups exa alias
	functions -e ls; alias ls='eza --group-directories-first'
	functions -e ll; alias ll='eza --icons -lag --group-directories-first'
	functions -e lll; alias lll='eza -la --icons --tree --level=2 --group-directories-first'
	functions -e llll; alias llll='eza -la --icons --tree --group-directories-first'
else if command -v exa >/dev/null 2>&1
	functions -e ls; alias ls='exa --icons --group-directories-first'
	functions -e ll; alias ll='exa --icons -laFg --group-directories-first'
	functions -e lll; alias lll='exa -laF --icons --tree --level=2 --group-directories-first'
	functions -e llll; alias llll='exa -laF --icons --tree --group-directories-first'
else if command -v lsd >/dev/null 2>&1
	functions -e ls; alias ls='lsd -F --group-dirs first --color=auto'
	functions -e ll; alias ll='lsd -FlA --group-dirs first --date=relative --blocks=permission,user,size,date,name --color=auto'
end

if command -v bat >/dev/null 2>&1
	functions -e cat; alias cat='bat -pp'
	functions -e ccat; alias ccat='bat -nAP'
	functions -e rat; alias rat='command cat'
end
if command -v batcat >/dev/null 2>&1
	functions -e cat; alias cat='batcat -pp'
	functions -e bat; alias bat='batcat -nAP'
	functions -e rat; alias rat='command cat'
end

alias notif='notify-send "Task finished" "Exit code: $status"'

# Set make aliases
# make: Compile with available threads
alias make='make -j(nproc)'
# makei: Compile install target with available threads
alias makei='make install -j(nproc); alert'
# make1: Compiler with all threads except one, let the system keep some resources
alias make1='make -j(nproc --ignore=1)'

# Set ipython configuration home
set -gx IPYTHONDIR "$HOME/.config/ipython"

# Set weechat configuration home
set -gx WEECHAT_HOME "$HOME/.config/weechat"

# Set taskwarrior and timewarrior configuration
set -gx TASKRC ~/.config/task/.taskrc
set -gx TIMEWARRIORDB ~/.config/task/.timewarrior.cfg

# Set kubectl configuration file
set -gx KUBECONFIG "$HOME/.config/kube/config"

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
abbr -a -g EC "python3 -m venv $DEFAULT_ENV_DIR && . $DEFAULT_ENV_DIR/bin/activate.fish"
# Recreate the python environment
abbr -a -g ER "rm -r $DEFAULT_ENV_DIR; python3 -m venv $DEFAULT_ENV_DIR && . $DEFAULT_ENV_DIR/bin/activate.fish"
# Create temporary python environment
abbr -a -g ET "temp_env"
# Deactivate the python environment
abbr -a -g D "deactivate"

# Reload fish configuration
abbr -a -g RE ". ~/.config/fish/config.fish"

# Pacman helpers
abbr -a -g SYU "sudo pacman -Syu --needed"
abbr -a -g SS "pacman -Ss"
abbr -a -g SI "pacman -Si"
abbr -a -g QI "pacman -Qi"
abbr -a -g QL "pacman -Ql | grep "

# Powerprofilesctl helpers
abbr -a -g P "powerprofilesctl"
abbr -a -g PP "powerprofilesctl launch --profile performance"
abbr -a -g PS "powerprofilesctl set"

# Add ssh-key
abbr -a -g SA "_ssh-add"
abbr -a -g SL "ssh-add -l"

# Cargo shortcut
abbr -a -g c "cargo"

# Git shortcut
abbr -a -g g "git"

# Docker shortcut
abbr -a -g d "docker"

# Kubectl shortcut
abbr -a -g k "kubectl"

# Docker abbrs
abbr -a -g DR "docker run --rm -it --detach-keys=\"ctrl-@\""
abbr -a -g DRR "docker run --rm -it --detach-keys=\"ctrl-@\" -w /app -v (pwd):/app"
abbr -a -g DRRR "docker run --rm -it --detach-keys=\"ctrl-@\" --network none -w /app -v (pwd):/app"

# This is skip the pacman check for a missing command.
# See: https://github.com/fish-shell/fish-shell/issues/7841
function fish_command_not_found
    __fish_default_command_not_found_handler $argv
end

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

function _alacritty_set_font -d 'Set the font in alacritty terminal'
    if [ -f ~/.config/alacritty/alacritty.toml ]
        _alacritty_set_font_toml "$argv[1]"
    else if [ -f ~/.config/alacritty/alacritty.yml ]
        _alacritty_set_font_yaml "$argv[1]"
    else
        echo "Cannot find alacritty config file"
    end
end

function _alacritty_set_font_yaml  -d 'Set the font in alacritty terminal YAML config'
    sed -i --follow-symlinks "s/^\(\s*family:\)\(.*\)/\1 $argv[1]/g" ~/.config/alacritty/alacritty.yml
end

function _alacritty_set_font_toml  -d 'Set the font in alacritty terminal TOML config'
    # alacritty msg config --window-id -1 "font.normal.family = \"$argv[1]\""
    # alacritty msg config --window-id -1 "font.bold.family = \"$argv[1]\""
    sed -i --follow-symlinks "s/^\(\s*family\s*=\s*\)\"\(.*\)\"/\1\"$argv[1]\"/g" ~/.config/alacritty/alacritty.toml
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

function _font_list -d 'List available font families'
	# fc-list | grep -i ttf | cut -d: -f2 | sort -ru
	# fc-list -f '%{family}\n' | awk '!x[$0]++' | sort -ru
	# TODO: For some reason alacritty loads the wrong font if the family
	# contains ','. For now strip everyting that is before the ','. (This is a hack)
	# fc-list -f '%{family}\n' | awk '!x[$0]++' | sed 's/\(.*\),.*/\1/' | sort -ru
	fc-list -f '%{family}\n' | awk '!x[$0]++' | sed 's/.*,\(.*\)/\1/' | grep -vi 'nerd font mono' | grep -vi 'stix' | sort -ru
end

# TODO: Create dmenu alternative
# TODO: User can change default selecter via env variable
function _rofi_select_font -d 'Select the font using rofi'
	string trim (_font_list | rofi -dmenu -i)
end

function _fzf_select_font -d 'Select the font using fzf'
	string trim (_font_list | fzf -i --bind 'tab:execute(fish -c "_alacritty_set_font {}")')
end

# TODO: Create new function with default fallbacks e.g
# User will pick dejavu font but this function will also by default append other fonts
# so everything in shell works just fine
function font-switcher -d 'Change terminal font.'
	# TODO: multi-select

	# Provide default value, if called without parameters
	if [ (count $argv) -eq 0 ]
		set argv $argv 710
	end

	# Let user select the font
	set -l selected_font (_fzf_select_font)
	[ -z "$selected_font" ]; and return

	# Format the font string
	# set -l formated_font (printf "xft:%s:pixelsize=21" $selected_font)
    # set -l formated_font (printf "xft:%s:pixelsize=21, xft:Inconsolata Nerd Font Mono:style=Medium:pixelsize=21" $selected_font)

	# Set the font
    # _urxvt_command $formated_font $argv[1]
    _alacritty_set_font "$selected_font"
end

function random-favorite-font -d 'Change termin font to a random one picked from favorites.'
    set -l favorite_fonts "Comic Mono" \
    # "Source Code Pro Medium" \
    "UbuntuMono Nerd Font" \
    "agave Nerd Font" \
    "VictorMono Nerd Font" \
    "JetBrains Mono Light" \
    "Iosevka Nerd Font" \
    "Anonymice Nerd Font" \
    "TerminessTTF Nerd Font" \
    "FiraCode Nerd Font" \
    "InconsolataLGC Nerd Font"

    set -l pick_one (random choice $favorite_fonts)

    echo "Random font is: $pick_one"

    _alacritty_set_font "$pick_one"
end

function random-nerd-font -d 'Change terminal font to random Nerd font'
	set -l selected_font (_font_list | grep -i nerd | shuf -n1)
	[ -z "$selected_font" ]; and return
	echo "$selected_font"

	# Set the font
	# _urxvt_set_font $formated_font 710
	_alacritty_set_font "$selected_font"
end

function random-font -d 'Change terminal font to random one.'
	set -l selected_font (_font_list | shuf -n1)
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

function select_project -d "Interactive select the project from ~/dev"
    set -l project_dir (command ls ~/dev | command fzf --height 15 --prompt "Select a project: " --layout=reverse --select-1 --query "$argv[1]")
    realpath ~/dev/$project_dir
end

function vimp -d "Interactive vim open file in a project"
    # TODO: Take one optional argument with the name of the project
    # TODO: Rice fzf here
    set -l project_dir (command ls ~/dev | command fzf --height 15 --prompt "Select a project: " --layout=reverse)
    [ -z "$project_dir" ] && return
    cd "$HOME/dev/$project_dir"
    set -l selected_file (ff)
    
    # Try to setup python venv
    # Vim python tools work better from project venv (they can see deps, etc.)
    set -l poetry_env (poetry env info -p)
    test $status -eq 0 && . "$poetry_env/bin/activate.fish"
    [ -e "$DEFAULT_ENV_DIR" ] && . "$DEFAULT_ENV_DIR/bin/activate.fish"

    # Open the file
    [ -z "$selected_file" ] && return
    vim $selected_file

    # Clean up venv if we can
    functions -n | grep deactivate && deactivate; true
end

alias vimc="pushd $HOME/dev/dotfiles; vim (ff); popd"
alias vimt="vim (mktemp -t note_XXXXXX.md)"
alias vimtt="vim (mktemp)"
alias vimf="vim (ff)"
alias ep="vimp"
alias ec="pushd $HOME/dev/dotfiles; vim (ff); popd"
alias catf="cat (ff)"

function zz -d "Interactive select a project"
    set -l selected_project (select_project "$argv")
	[ -z "$selected_project" ] && return
    cd $selected_project
end

function ee -d "Interactive file picker for vim open"
	set -l selected_file (ff)
	[ -z "$selected_file" ] && return
	vim $selected_file
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
function docker-df -d "Report docker disk space usage"
	docker system df
	# TODO: Add other checks if any
end

function docker-cleanup -d "Clean up docker space"
	# TODO: Add some king of user interaction
	# TODO: Add error handling in case commnads don't have any containers to delete
	docker volume rm (docker volume ls -f dangling=true -q)
	docker rmi (docker images -f "dangling=true" -q)
	docker rm (docker ps -a -f status=exited -q)
end

# TODO: Maybe swap the order of selected_container and argv, this is preffered I think
function _select-docker-container -d "Helper function to select docker container"
	set -l preview_format "Name:\t\t{{.Names}}\nCommand:\t{{.Command}}\nStatus:\t\t{{.Status}}\nSize:\t\t{{.Size}}\nPorts:\t\t{{.Ports}}\nMounts:\t\t{{.Mounts}}\nNetworks:\t{{.Networks}}"
	set -l containers (docker ps --format "{{.Names}}" $argv)
	set -l selected_container (echo "$containers" | tr ' ' '\n' | fzf --preview="docker ps --filter 'name={1}' --format '$preview_format'" | cut -d " " -f 2)
	echo "$selected_container"
end

function docker-bash -d "Spawn bash in docker"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	if [ (count $argv) -eq 0 ];
		docker exec -it --detach-keys="ctrl-@" "$selected_container" bash
	else
		docker exec -it --detach-keys="ctrl-@" "$selected_container" $argv
	end
end

function docker-attach -d "Attach to a docker container"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	docker attach "$selected_container"
end

function docker-kill -d "Kill docker container"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	docker kill "$selected_container" $argv
end

function docker-restart -d "Restart docker container"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	docker restart "$selected_container" $argv
end

function docker-logs -d "Display container logs"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	docker logs "$selected_container" $argv
end

function docker-inspect -d "Inspect docker container"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	docker inspect "$selected_container"
end


function docker-rmi -d "Remove docker images"
	set -l selected_container (_select-docker-container)

	[ -z "$selected_container" ]; and return
	docker rmi "$selected_container" $argv
end

function temp_env -d "Create new temporary virtualenv"
	set dir (mktemp -d venv.XXX --tmpdir)
	python3 -m venv "$dir"
	. "$dir/bin/activate.fish"
end

function _ssh-add -d "Add new ssh-key to the ssh-agent"
	# Startup the ssh-agent if not running
	[ -z "$SSH_AGENT_PID" ] && eval (ssh-agent -c)
	
	# TODO: Filter out keys that are already active
	set -l _key (fd . -E '*.pub' ~/.ssh/ | fzf --height 15 --prompt "Select a key to add: " --layout=reverse)
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

	# Source: https://gist.github.com/XVilka/8346728
	echo "If the color ramp bellow is perfectly smooth, true color is supported."
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

function _progress -d "Display ascii progress bar"
	read progress
	[ -z "$progress" ]; and return
	
	set -l symbol_complete "▰"
	set -l symbol_incomplete "▱"
	# TODO: Add way to change number of total symbols in progressbar - default 10
	set -l complete (math -s0 $progress / 10)
	string repeat --no-newline -n "$complete" "$symbol_complete"
	string repeat -n (math 10 - "$complete") "$symbol_incomplete"
end

# TODO: Add interface picker using fzf
function wireshark_monitor -d "Open wireshark on a given interface"
	[ (count $argv) -ne 1 ]; and return
    set -l IF $argv[1]
    set -l IF_IP (ip a show $IF | grep -m 1 'inet\b' | awk '{print $2}' | cut -d/ -f1)
    wireshark -k -i $IF -f "host $IF_IP" -Y "not arp"
end

function duck
    set -l query (string join '+' $argv)
    w3m "https://duckduckgo.com/lite?q=$query"
end
alias s='duck'

function qr -d "Generate QR code from stdin (split into multiple QR codes if necessary)"
    # Read the whole stdin into a variable
    read -l --null STDIN

    # Generate the QR codes
    echo -n $STDIN | split -b 1500 --filter 'qrencode -o - | display ' > /dev/null

    # Print the original STDIN back to stdout. This is useful when using the from vim.
    echo -n $STDIN
end

function qrc -d "Generate QR code from clipboard contents using qr function"
    wl-paste | qr
end

function json_logs -d "Reformat JSON logs to a more readable format"
    jq -Rr 'fromjson? | "\(.time) \(.severity) \(.message)"'
end

function rsync_dev -d "Continuously sync directory to the server"
    set -l src $argv[1]
    set -l dst $argv[2]
    echo "Syncing $src to $dst using rsync"
    while true
        find $src | entr -d time rsync -rzvhP -f '- env/' -f '- env-tests/' -f '- __pycache__' -f '- target' -f '- *.o' $src $dst
    end
end

function cheat.sh -d "Search for cheatsheets"
    curl "cheat.sh/$argv?style=stata-light"
end

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/matej.kastak/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
