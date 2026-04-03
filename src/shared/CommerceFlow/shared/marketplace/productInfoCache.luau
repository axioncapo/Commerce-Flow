local cache = {}

local productInfoCache = {}

function productInfoCache.get(cacheKey: string)
    return cache[cacheKey]
end

function productInfoCache.set(cacheKey: string, productInfo)
    cache[cacheKey] = productInfo
    return productInfo
end

function productInfoCache.clear(cacheKey: string?)
    if cacheKey == nil then
        table.clear(cache)
        return
    end

    cache[cacheKey] = nil
end

return productInfoCache
