local MarketplaceService = game:GetService("MarketplaceService")

local purchaseType = require(script.Parent.Parent.constants.purchaseType)

return function(gamepassId: number)
    local success, response = pcall(function()
        return MarketplaceService:GetProductInfo(gamepassId, Enum.InfoType.GamePass)
    end)

    assert(success, `Failed to fetch gamepass info for {gamepassId}: {response}`)
    assert(type(response) == "table", `MarketplaceService:GetProductInfo expected table response for gamepass {gamepassId}`)

    return {
        id = gamepassId,
        assetId = if type(response.AssetId) == "number" then response.AssetId else nil,
        name = if type(response.Name) == "string" then response.Name else tostring(gamepassId),
        description = if type(response.Description) == "string" then response.Description else "",
        priceInRobux = if type(response.PriceInRobux) == "number" then response.PriceInRobux else nil,
        iconImageAssetId = if type(response.IconImageAssetId) == "number" then response.IconImageAssetId else nil,
        isForSale = response.IsForSale ~= false,
        kind = purchaseType.gamepass,
    }
end
