local appendPurchaseReceipt = require(script.Parent.Parent.shared.storage.appendPurchaseReceipt)
local buildPurchaseRecord = require(script.Parent.Parent.shared.buildPurchaseRecord)
local firePurchaseSignals = require(script.firePurchaseSignals)
local hasGamepassOwnership = require(script.Parent.Parent.shared.storage.hasGamepassOwnership)
local hasPurchasedBefore = require(script.Parent.Parent.shared.storage.hasPurchasedBefore)
local purchaseSource = require(script.Parent.Parent.shared.constants.purchaseSource)
local purchaseType = require(script.Parent.Parent.shared.constants.purchaseType)
local resolveRewardTarget = require(script.Parent.Parent.shared.resolveRewardTarget)
local validateConfirmationResult = require(script.Parent.Parent.shared.validation.validateConfirmationResult)

return function(context)
    local runtime = context.runtime
    local promptOptions = context.promptOptions or {
        gift = false,
        giftTarget = nil,
    }

    local buyerUserId = context.buyerUserId or (context.buyerPlayer and context.buyerPlayer.UserId)
    assert(type(buyerUserId) == "number", `buyerUserId expected as number`)

    local rewardedPlayer = context.rewardedPlayer
    local rewardedUserId = rewardedPlayer and rewardedPlayer.UserId or nil

    if rewardedPlayer == nil then
        local resolvedPlayer, resolvedUserId = resolveRewardTarget(context.buyerPlayer, promptOptions)
        rewardedPlayer = resolvedPlayer
        rewardedUserId = resolvedUserId
    end

    assert(rewardedPlayer ~= nil, `rewardedPlayer expected after reward target resolution`)
    assert(type(rewardedUserId) == "number", `rewardedUserId expected as number`)

    local blockedReason = nil
    local shouldCheckSingleOwnership = runtime.purchaseOnceTime or runtime.kind == purchaseType.gamepass

    if runtime.kind == purchaseType.gamepass then
        local ownsGamepass = hasGamepassOwnership(rewardedUserId, runtime)

        if context.source == purchaseSource.ownership then
            if not ownsGamepass then
                blockedReason = "gamepass ownership was not confirmed"
            end
        elseif ownsGamepass then
            blockedReason = "rewarded player already owns the gamepass"
        end
    end

    if blockedReason == nil and shouldCheckSingleOwnership then
        local alreadyPurchased = hasPurchasedBefore(rewardedUserId, runtime)

        if alreadyPurchased then
            blockedReason = "purchaseOnceTime already consumed by rewarded player"
        end
    end

    local purchaseRecord = buildPurchaseRecord(runtime, {
        purchaseId = context.purchaseId,
        receiptToken = context.receiptToken,
        buyerPlayer = context.buyerPlayer,
        buyerUserId = buyerUserId,
        rewardedPlayer = rewardedPlayer,
        rewardedUserId = rewardedUserId,
        promptOptions = promptOptions,
        source = context.source,
        confirmed = blockedReason == nil,
        confirmationReason = blockedReason,
    })

    if blockedReason == nil and runtime.confirmationHook ~= nil then
        local hookSuccess, hookResult = pcall(runtime.confirmationHook, purchaseRecord)

        if not hookSuccess then
            return {
                handled = false,
                message = hookResult,
            }
        end

        local confirmation = validateConfirmationResult(hookResult)

        if not confirmation.approved then
            blockedReason = confirmation.reason or "confirmationHook denied the purchase"
            purchaseRecord.confirmed = false
            purchaseRecord.confirmationReason = blockedReason
        end
    end

    if blockedReason == nil then
        local rewardSuccess, rewardError = pcall(runtime.reward, rewardedPlayer, purchaseRecord)

        if not rewardSuccess then
            return {
                handled = false,
                message = rewardError,
            }
        end

        purchaseRecord.confirmed = true
    else
        purchaseRecord.confirmed = false
        purchaseRecord.confirmationReason = blockedReason
    end

    local appendSuccess, appendError = pcall(appendPurchaseReceipt, purchaseRecord)

    if not appendSuccess then
        return {
            handled = false,
            message = appendError,
        }
    end

    if purchaseRecord.confirmed then
        firePurchaseSignals(runtime, rewardedPlayer, purchaseRecord)
    end

    return {
        handled = true,
        confirmed = purchaseRecord.confirmed,
        purchaseRecord = purchaseRecord,
    }
end
