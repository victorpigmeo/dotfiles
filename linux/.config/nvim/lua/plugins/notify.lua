-- nvim-notify: animated toast notifications in the top-right. Replaces the
-- default vim.notify (a single flash on the message line) so our messages --
-- e.g. "jdtls project config updated", "jdtls is not running", build OK/FAILED
-- -- show as a lingering, colored popup that's hard to miss. WARN/ERROR are
-- color-coded. History is available via :Notifications.
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    timeout = 3000, -- ms a toast stays before fading
    stages = "fade",
    render = "default",
    top_down = true,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify -- route all vim.notify calls through nvim-notify
  end,
}
