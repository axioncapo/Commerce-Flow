local RunService = game:GetService("RunService")

local liveCache = require(script.Parent.Parent.liveCache)
local purchaseSource = require(script.Parent.Parent.constants.purchaseSource)
local purchaseType = require(script.Parent.Parent.constants.purchaseType)
local createPurchaseSignal = require(script.Parent.Parent.signals.createPurchaseSignal)
local getProductInfo = require(script.Parent.Parent.getProductInfo)

return function(domainRuntime, productKey: string, schema)
    local purchaseSignal = createPurchaseSignal.new()

    local runtime = {
        kind = purchaseType.gamepass,
        runtimeId = liveCache.nextRuntimeId("gamepass"),
        runtimeToken = liveCache.getRuntimeToken(domainRuntime.domainName, productKey),
        domainName = domainRuntime.domainName,
        productKey = productKey,
        gamepassId = schema.gamepassId,
        giftProductId = schema.giftProduct,
        canGift = schema.canGift,
        purchaseOnceTime = schema.purchaseOnceTime,
        confirmationHook = schema.confirmationHook,
        reward = schema.reward,
        purchaseSignal = purchaseSignal,
    }

    function runtime:getProductInfo()
        return getProductInfo(self)
    end

    function runtime:prompt(promptOptions)
        assert(RunService:IsClient(), `"{self.domainName}.{self.productKey}:prompt()" is client-only`)
        local promptGamepass = require(script.Parent.Parent.Parent.client.promptGamepass)
        return promptGamepass(self, promptOptions)
    end

    function runtime:OnPurchase(callback)
        assert(RunService:IsServer(), `"{self.domainName}.{self.productKey}:OnPurchase()" is server-only`)
        return purchaseSignal:connect(callback)
    end

    function runtime:rewardUser(rewardedPlayer: Player, options)
        assert(RunService:IsServer(), `"{self.domainName}.{self.productKey}:rewardUser()" is server-only`)
        assert(typeof(rewardedPlayer) == "Instance" and rewardedPlayer:IsA("Player"), `rewardedPlayer expected as Player`)

        local rewardPurchase = require(script.Parent.Parent.Parent.server.rewardPurchase)
        local normalizedOptions = options or {}

        local rewardResult = rewardPurchase({
            runtime = self,
            buyerPlayer = normalizedOptions.buyerPlayer or rewardedPlayer,
            buyerUserId = normalizedOptions.buyerUserId or rewardedPlayer.UserId,
            rewardedPlayer = rewardedPlayer,
            source = normalizedOptions.source or purchaseSource.manual,
            promptOptions = {
                gift = normalizedOptions.gift == true,
                giftTarget = if normalizedOptions.gift == true then (normalizedOptions.giftTarget or rewardedPlayer.UserId) else nil,
            },
            receiptToken = normalizedOptions.receiptToken,
        })

        assert(rewardResult.handled, rewardResult.message or `Failed to reward "{self.domainName}.{self.productKey}" manually`)

        return rewardResult.purchaseRecord
    end

    return table.freeze(runtime)
end
