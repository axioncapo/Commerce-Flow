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

    MarketplaceService:PromptProductPurchase(Players.LocalPlayer, response.promptProductId)
end
