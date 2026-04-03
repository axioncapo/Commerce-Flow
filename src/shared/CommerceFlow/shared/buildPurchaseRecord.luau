local HttpService = game:GetService("HttpService")

return function(runtime, context)
    local purchaseId = if context.purchaseId ~= nil then tostring(context.purchaseId) else HttpService:GenerateGUID(false)
    local receiptToken = if context.receiptToken ~= nil then tostring(context.receiptToken) else purchaseId

    return {
        purchaseId = purchaseId,
        purchaseType = runtime.kind,
        productKey = runtime.productKey,
        productId = runtime.productId,
        gamepassId = runtime.gamepassId,
        buyerUserId = context.buyerUserId,
        rewardedUserId = context.rewardedUserId,
        gifting = context.promptOptions.gift,
        giftTarget = context.promptOptions.giftTarget,
        source = context.source,
        purchasedAt = if context.purchasedAt ~= nil then context.purchasedAt else os.time(),
        confirmed = context.confirmed == true,
        domainName = runtime.domainName,
        receiptToken = receiptToken,
        confirmationReason = context.confirmationReason,
        buyer = {
            userId = context.buyerUserId,
            name = if context.buyerPlayer ~= nil then context.buyerPlayer.Name else nil,
        },
        rewarded = {
            userId = context.rewardedUserId,
            name = if context.rewardedPlayer ~= nil then context.rewardedPlayer.Name else nil,
        },
    }
end
