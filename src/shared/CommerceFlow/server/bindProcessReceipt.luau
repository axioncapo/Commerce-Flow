local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local liveCache = require(script.Parent.Parent.shared.liveCache)
local purchaseSource = require(script.Parent.Parent.shared.constants.purchaseSource)
local rewardPurchase = require(script.Parent.rewardPurchase)

return function()
    MarketplaceService.ProcessReceipt = function(receiptInfo)
        local success, result = pcall(function()
            local buyerPlayer = Players:GetPlayerByUserId(receiptInfo.PlayerId)

            if buyerPlayer == nil then
                return {
                    handled = false,
                    message = `Buyer {receiptInfo.PlayerId} is not in the server`,
                }
            end

            local runtime = liveCache.getRuntimeByProductId(receiptInfo.ProductId)
            local source = purchaseSource.receipt

            if runtime == nil then
                runtime = liveCache.getRuntimeByGiftProductId(receiptInfo.ProductId)
                source = purchaseSource.giftProduct
            end

            if runtime == nil then
                return {
                    handled = false,
                    message = `No runtime registered for developer product {receiptInfo.ProductId}`,
                }
            end

            local promptEntry = liveCache.getPendingPrompt(receiptInfo.PlayerId, receiptInfo.ProductId)

            if promptEntry == nil and (source == purchaseSource.giftProduct or runtime.canGift) then
                return {
                    handled = false,
                    message = `Missing prompt context for {runtime.domainName}.{runtime.productKey}`,
                }
            end

            if promptEntry ~= nil and promptEntry.runtimeToken ~= runtime.runtimeToken then
                return {
                    handled = false,
                    message = `Prompt context did not match runtime "{runtime.domainName}.{runtime.productKey}"`,
                }
            end

            local rewardResult = rewardPurchase({
                runtime = runtime,
                buyerPlayer = buyerPlayer,
                buyerUserId = buyerPlayer.UserId,
                source = source,
                promptOptions = if promptEntry ~= nil then promptEntry.promptOptions else {
                    gift = false,
                    giftTarget = nil,
                },
                purchaseId = receiptInfo.PurchaseId,
                receiptToken = receiptInfo.PurchaseId,
            })

            if rewardResult.handled then
                liveCache.clearPendingPrompt(receiptInfo.PlayerId, receiptInfo.ProductId)
            end

            return rewardResult
        end)

        if not success then
            warn(`[CommerceFlow] ProcessReceipt failed: {result}`)
            return Enum.ProductPurchaseDecision.NotProcessedYet
        end

        if not result.handled then
            warn(`[CommerceFlow] ProcessReceipt retry: {result.message}`)
            return Enum.ProductPurchaseDecision.NotProcessedYet
        end

        return Enum.ProductPurchaseDecision.PurchaseGranted
    end
end
