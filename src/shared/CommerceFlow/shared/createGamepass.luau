local gamepassTypes = require(script.Parent.Parent.types.gamepassTypes)
local purchaseType = require(script.Parent.constants.purchaseType)
local validateGamepassSchema = require(script.Parent.validation.validateGamepassSchema)

return function(schema): gamepassTypes.GamepassDefinition
    return table.freeze({
        __definitionType = purchaseType.gamepass,
        kind = purchaseType.gamepass,
        schema = validateGamepassSchema(schema),
    }) :: any
end
