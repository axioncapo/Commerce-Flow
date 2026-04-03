local purchaseType = require(script.Parent.constants.purchaseType)
local fetchGamepassInfo = require(script.Parent.marketplace.fetchGamepassInfo)
local fetchProductInfo = require(script.Parent.marketplace.fetchProductInfo)
local productInfoCache = require(script.Parent.marketplace.productInfoCache)

return function(runtime)
    local cacheId = if runtime.kind == purchaseType.product then runtime.productId else runtime.gamepassId
    local cacheKey = `{runtime.kind}:{cacheId}`

    local cachedInfo = productInfoCache.get(cacheKey)

    if cachedInfo ~= nil then
        return cachedInfo
    end

    local productInfo = if runtime.kind == purchaseType.product
        then fetchProductInfo(runtime.productId)
        else fetchGamepassInfo(runtime.gamepassId)

    return productInfoCache.set(cacheKey, productInfo)
end
