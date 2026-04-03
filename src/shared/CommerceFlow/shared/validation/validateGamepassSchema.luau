local gamepassTypes = require(script.Parent.Parent.Parent.types.gamepassTypes)

return function(schema): gamepassTypes.NormalizedGamepassSchema
    assert(type(schema) == "table", `Gamepass schema expected as table`)
    assert(type(schema.gamepassId) == "number", `Gamepass schema.gamepassId expected as number`)
    assert(type(schema.reward) == "function", `Gamepass schema.reward expected as function`)

    if schema.giftProduct ~= nil then
        assert(type(schema.giftProduct) == "number", `Gamepass schema.giftProduct expected as number`)
    end

    if schema.canGift ~= nil then
        assert(type(schema.canGift) == "boolean", `Gamepass schema.canGift expected as boolean`)
    end

    if schema.purchaseOnceTime ~= nil then
        assert(type(schema.purchaseOnceTime) == "boolean", `Gamepass schema.purchaseOnceTime expected as boolean`)
    end

    if schema.confirmationHook ~= nil then
        assert(type(schema.confirmationHook) == "function", `Gamepass schema.confirmationHook expected as function`)
    end

    local canGift = if schema.canGift == nil then schema.giftProduct ~= nil else schema.canGift

    if canGift then
        assert(schema.giftProduct ~= nil, `Gamepass schema.giftProduct expected when gifting is enabled`)
    end

    return {
        gamepassId = schema.gamepassId,
        giftProduct = schema.giftProduct,
        canGift = canGift,
        purchaseOnceTime = if schema.purchaseOnceTime == nil then true else schema.purchaseOnceTime,
        confirmationHook = schema.confirmationHook,
        reward = schema.reward,
    }
end
