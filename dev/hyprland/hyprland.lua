hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.config({ misc = {
    disable_xdg_env_checks = true,
    disable_hyprland_guiutils_check = true,
    disable_watchdog_warning = true,
    disable_scale_notification = true,
} })

hl.window_rule({ name = "fixture-corner", match = { title = "^phosphor-dev-fixture$" }, float = true, move = "20 20" })
