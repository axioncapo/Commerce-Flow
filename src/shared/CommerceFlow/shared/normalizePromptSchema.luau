local validatePromptOptions = require(script.Parent.validation.validatePromptOptions)

return function(runtime, promptOptions)
    return validatePromptOptions(runtime, promptOptions)
end
