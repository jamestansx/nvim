-- delay notifications until nvim-notify is loaded
require("james.utils").editor.lazy_notify()

-- configuration
require("james.config.options")
require("james.config.autocmds")
require("james.config.keymaps")
require("james.config.lazy")
