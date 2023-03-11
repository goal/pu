local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return {
    enable_tab_bar = false,

	font = wezterm.font("FiraCode Nerd Font Mono"),
	font_size = 16.0,

	-- https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
	-- 0, r, &, $, =~ !~, i, .-, :-, .=, 567
	harfbuzz_features = { "zero", "ss01", "ss03", "ss04", "ss07", "cv05", "cv25", "cv26", "cv32", "onum" },

	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },

	keys = {
		-- Split
		{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{
			key = "\\",
			mods = "LEADER",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
	},

	mouse_bindings = {
		-- Right click paste
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action.PasteFrom("PrimarySelection"),
		},
	},
}
