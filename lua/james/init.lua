vim.loader.enable()

-- delay notifications until nvim-notify is loaded
require("james.util").lazy_notify()

-- configuration
require("james.config.lazy")
