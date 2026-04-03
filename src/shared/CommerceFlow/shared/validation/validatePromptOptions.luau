return function(runtime, promptOptions)
    if promptOptions == nil then
        promptOptions = {}
    end

    assert(type(promptOptions) == "table", `Prompt options expected as table`)

    if promptOptions.gift ~= nil then
        assert(type(promptOptions.gift) == "boolean", `Prompt options.gift expected as boolean`)
    end

    local normalizedGiftTarget = nil

    if promptOptions.giftTarget ~= nil then
        if type(promptOptions.giftTarget) == "number" then
            normalizedGiftTarget = promptOptions.giftTarget
        else
            assert(typeof(promptOptions.giftTarget) == "Instance" and promptOptions.giftTarget:IsA("Player"), `Prompt options.giftTarget expected as number or Player`)
            normalizedGiftTarget = promptOptions.giftTarget.UserId
        end
    end

    local normalized = {
        gift = promptOptions.gift == true,
        giftTarget = normalizedGiftTarget,
    }

    if normalized.gift then
        assert(runtime.canGift, `"{runtime.domainName}.{runtime.productKey}" does not support gifting`)
        assert(normalized.giftTarget ~= nil, `Prompt options.giftTarget expected when gift = true`)

        if runtime.kind == "gamepass" then
            assert(runtime.giftProductId ~= nil, `"{runtime.domainName}.{runtime.productKey}" requires giftProduct to gift gamepasses`)
        end
    else
        normalized.giftTarget = nil
    end

    return normalized
end
