# Source alias file
source ~/.config/fish/aliases

set -g theme_display_date no
set -g theme_display_vi no

set -gx VIRTUAL_ENV_DISABLE_PROMPT YES

set -gx MAKEFLAGS '-j'(nproc)

# Dynamicaly set the background color
# TODO: Move to aliases?
abbr -a -g white_bg 'printf "\033Ptmux;\033\033]11;white\007\033\\\\"'
abbr -a -g black_bg 'printf "\033Ptmux;\033\033]11;black\007\033\\\\"'
