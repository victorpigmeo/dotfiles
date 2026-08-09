-- Auto-close pairs: typing ( [ { " ' ` inserts the matching close, skips over an
-- existing close instead of doubling it, and deletes both halves on backspace.
-- check_ts uses treesitter (see treesitter.lua) to avoid pairing inside strings
-- and comments.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
  },
}
