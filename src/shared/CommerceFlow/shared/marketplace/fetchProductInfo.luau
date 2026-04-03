local MarketplaceService = game:GetService("MarketplaceService")

local purchaseType = require(script.Parent.Parent.constants.purchaseType)

return function(productId: number)
    local success, response = pcall(function()
        return MarketplaceService:GetProductInfo(productId, Enum.InfoType.Product)
    end)

    assert(success, `Failed to fetch developer product info for {productId}: {response}`)
    assert(type(response) == "table", `MarketplaceService:GetProductInfo expected table response for product {productId}`)

    return {
        id = productId,
        assetId = if type(response.AssetId) == "number" then response.AssetId else nil,
        name = if type(response.Name) == "string" then response.Name else tostring(productId),
        description = if type(response.Description) == "string" then response.Description else "",
        priceInRobux = if type(response.PriceInRobux) == "number" then response.PriceInRobux else nil,
        iconImageAssetId = if type(response.IconImageAssetId) == "number" then response.IconImageAssetId else nil,
        isForSale = response.IsForSale ~= false,
        kind = purchaseType.product,
    }
end
