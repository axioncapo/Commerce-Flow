local createDomainRuntime = require(script.Parent.runtime.createDomainRuntime)
local createGamepassRuntime = require(script.Parent.runtime.createGamepassRuntime)
local createProductRuntime = require(script.Parent.runtime.createProductRuntime)
local liveCache = require(script.Parent.liveCache)
local purchaseType = require(script.Parent.constants.purchaseType)
local validateDomainSchema = require(script.Parent.validation.validateDomainSchema)

return function(domainName: string, entries)
    validateDomainSchema(domainName, entries)
    assert(not liveCache.hasDomain(domainName), `Domain "{domainName}" is already registered`)

    local domainRuntime = createDomainRuntime(domainName)
    local builtItems = {}
    local pendingRuntimes = {}
    local localProductIds = {}
    local localGamepassIds = {}
    local localGiftProductIds = {}

    for productKey, definition in entries do
        local runtime = if definition.kind == purchaseType.product
            then createProductRuntime(domainRuntime, productKey, definition.schema)
            else createGamepassRuntime(domainRuntime, productKey, definition.schema)

        if runtime.kind == purchaseType.product then
            assert(not localProductIds[runtime.productId], `ProductId {runtime.productId} is duplicated inside domain "{domainName}"`)
            assert(not liveCache.hasProductId(runtime.productId), `ProductId {runtime.productId} is already registered`)
            localProductIds[runtime.productId] = true
        else
            assert(not localGamepassIds[runtime.gamepassId], `GamepassId {runtime.gamepassId} is duplicated inside domain "{domainName}"`)
            assert(not liveCache.hasGamepassId(runtime.gamepassId), `GamepassId {runtime.gamepassId} is already registered`)
            localGamepassIds[runtime.gamepassId] = true

            if runtime.giftProductId ~= nil then
                assert(not localGiftProductIds[runtime.giftProductId], `Gift product {runtime.giftProductId} is duplicated inside domain "{domainName}"`)
                assert(not liveCache.hasGiftProductId(runtime.giftProductId), `Gift product {runtime.giftProductId} is already registered`)
                localGiftProductIds[runtime.giftProductId] = true
            end
        end

        builtItems[productKey] = runtime
        pendingRuntimes[productKey] = runtime
        domainRuntime[productKey] = runtime
    end

    domainRuntime.items = table.freeze(builtItems)

    liveCache.registerDomain(domainRuntime)

    for _, runtime in pendingRuntimes do
        liveCache.registerRuntime(runtime)
    end

    return table.freeze(domainRuntime)
end
