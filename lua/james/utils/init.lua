return setmetatable({}, {
	__index = function(self, key)
		self[key] = require("james.utils." .. key)
		return self[key]
	end,
})
