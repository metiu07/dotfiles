local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local act = wezterm.action

config.keys = {
    { key = 'UpArrow',   mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ActivateCommandPalette },
}
config.color_scheme = 'Solarized (light) (terminal.sexy)'
-- config.color_scheme = 'Solarized Light (Gogh)'

config.font = wezterm.font("JetBrains Mono", { weight = "Medium", bold = false })
config.font_size = 16.0
config.cell_width = 0.9

-- Add `│` to the boundary, which is a character used by tmux to split panes
config.selection_word_boundary = " \t\n{}[]()\"'`│"

config.enable_tab_bar = false

config.freetype_load_target = "HorizontalLcd"

config.default_cursor_style = "SteadyUnderline"

config.window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
}

config.enable_scroll_bar = false

return config
