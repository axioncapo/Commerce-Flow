local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local client = require(script.Parent.init)
local normalizePromptSchema = require(script.Parent.Parent.shared.normalizePromptSchema)

return function(runtime, promptOptions)
    local normalizedPrompt = normalizePromptSchema(runtime, promptOptions)
    local response = client.getRemotes().preparePrompt:InvokeServer({
        domainName = runtime.domainName,
        productKey = runtime.productKey,
        gift = normalizedPrompt.gift,
        giftTarget = normalizedPrompt.giftTarget,
    })

    assert(type(response) == "table" and response.ok == true, if type(response) == "table" then response.message else "preparePrompt failed")

    if response.usesDeveloperProduct then
        MarketplaceService:PromptProductPurchase(Players.LocalPlayer, response.promptProductId)
        return
    end

    local connection = nil

    connection = MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, wasPurchased)
        if player ~= Players.LocalPlayer or gamepassId ~= runtime.gamepassId then
            return
        end

        if connection ~= nil then
            connection:Disconnect()
            connection = nil
        end

        if wasPurchased then
            client.getRemotes().completeGamepassPrompt:FireServer({
                domainName = runtime.domainName,
                productKey = runtime.productKey,
            })
        end
    end)

    MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, response.promptProductId)
end
