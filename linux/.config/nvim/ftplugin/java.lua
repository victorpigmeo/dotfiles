-- Java indentation matched to Spotless so hand-typed code stays
-- spotless-compliant: 4 spaces, no tabs. Buffer-local; overrides the 2-space
-- global default from config/options.lua. If your project's Spotless uses a
-- different width -- google-java-format is 2 spaces, or an Eclipse config may
-- use real tabs -- adjust the numbers (or set expandtab = false) here.
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
