local productTypes = require(script.Parent.Parent.Parent.types.productTypes)

return function(schema): productTypes.NormalizedProductSchema
    assert(type(schema) == "table", `Product schema expected as table`)
    assert(type(schema.productId) == "number", `Product schema.productId expected as number`)
    assert(type(schema.reward) == "function", `Product schema.reward expected as function`)

    if schema.canGift ~= nil then
        assert(type(schema.canGift) == "boolean", `Product schema.canGift expected as boolean`)
    end

    if schema.purchaseOnceTime ~= nil then
        assert(type(schema.purchaseOnceTime) == "boolean", `Product schema.purchaseOnceTime expected as boolean`)
    end

    if schema.confirmationHook ~= nil then
        assert(type(schema.confirmationHook) == "function", `Product schema.confirmationHook expected as function`)
    end

    return {
        productId = schema.productId,
        canGift = if schema.canGift == nil then true else schema.canGift,
        purchaseOnceTime = if schema.purchaseOnceTime == nil then false else schema.purchaseOnceTime,
        confirmationHook = schema.confirmationHook,
        reward = schema.reward,
    }
end
