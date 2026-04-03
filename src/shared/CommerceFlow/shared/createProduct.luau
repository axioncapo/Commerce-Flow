local productTypes = require(script.Parent.Parent.types.productTypes)
local purchaseType = require(script.Parent.constants.purchaseType)
local validateProductSchema = require(script.Parent.validation.validateProductSchema)

return function(schema): productTypes.ProductDefinition
    return table.freeze({
        __definitionType = purchaseType.product,
        kind = purchaseType.product,
        schema = validateProductSchema(schema),
    }) :: any
end
