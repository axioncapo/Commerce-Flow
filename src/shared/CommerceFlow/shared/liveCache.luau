local HttpService = game:GetService("HttpService")

local purchaseType = require(script.Parent.constants.purchaseType)

local state = {
    serverInitialized = false,
    clientInitialized = false,
    domainsByName = {},
    runtimesByToken = {},
    runtimesByProductId = {},
    runtimesByGamepassId = {},
    runtimesByGiftProductId = {},
    pendingPromptsByUserId = {},
}

local liveCache = {}

function liveCache.markServerInitialized(): boolean
    if state.serverInitialized then
        return false
    end

    state.serverInitialized = true
    return true
end

function liveCache.markClientInitialized(): boolean
    if state.clientInitialized then
        return false
    end

    state.clientInitialized = true
    return true
end

function liveCache.nextRuntimeId(prefix: string): string
    return `{prefix}_{HttpService:GenerateGUID(false)}`
end

function liveCache.getRuntimeToken(domainName: string, productKey: string): string
    return `{domainName}:{productKey}`
end

function liveCache.hasDomain(domainName: string): boolean
    return state.domainsByName[domainName] ~= nil
end

function liveCache.hasProductId(productId: number): boolean
    return state.runtimesByProductId[productId] ~= nil
end

function liveCache.hasGamepassId(gamepassId: number): boolean
    return state.runtimesByGamepassId[gamepassId] ~= nil
end

function liveCache.hasGiftProductId(giftProductId: number?): boolean
    if giftProductId == nil then
        return false
    end

    return state.runtimesByGiftProductId[giftProductId] ~= nil
end

function liveCache.registerDomain(domainRuntime)
    assert(not state.domainsByName[domainRuntime.domainName], `Domain "{domainRuntime.domainName}" is already registered`)
    state.domainsByName[domainRuntime.domainName] = domainRuntime
end

function liveCache.registerRuntime(runtime)
    assert(not state.runtimesByToken[runtime.runtimeToken], `Runtime "{runtime.runtimeToken}" is already registered`)

    if runtime.kind == purchaseType.product then
        assert(not state.runtimesByProductId[runtime.productId], `ProductId {runtime.productId} is already registered`)
        state.runtimesByProductId[runtime.productId] = runtime
    else
        assert(not state.runtimesByGamepassId[runtime.gamepassId], `GamepassId {runtime.gamepassId} is already registered`)
        state.runtimesByGamepassId[runtime.gamepassId] = runtime

        if runtime.giftProductId ~= nil then
            assert(not state.runtimesByGiftProductId[runtime.giftProductId], `Gift product {runtime.giftProductId} is already registered`)
            state.runtimesByGiftProductId[runtime.giftProductId] = runtime
        end
    end

    state.runtimesByToken[runtime.runtimeToken] = runtime
end

function liveCache.getDomain(domainName: string)
    return state.domainsByName[domainName]
end

function liveCache.getRuntime(domainName: string, productKey: string)
    return state.runtimesByToken[liveCache.getRuntimeToken(domainName, productKey)]
end

function liveCache.getRuntimeByToken(runtimeToken: string)
    return state.runtimesByToken[runtimeToken]
end

function liveCache.getRuntimeByProductId(productId: number)
    return state.runtimesByProductId[productId]
end

function liveCache.getRuntimeByGamepassId(gamepassId: number)
    return state.runtimesByGamepassId[gamepassId]
end

function liveCache.getRuntimeByGiftProductId(giftProductId: number)
    return state.runtimesByGiftProductId[giftProductId]
end

function liveCache.registerPendingPrompt(userId: number, promptProductId: number, promptData)
    local userPrompts = state.pendingPromptsByUserId[userId]

    if userPrompts == nil then
        userPrompts = {}
        state.pendingPromptsByUserId[userId] = userPrompts
    end

    userPrompts[promptProductId] = promptData
end

function liveCache.getPendingPrompt(userId: number, promptProductId: number)
    local userPrompts = state.pendingPromptsByUserId[userId]

    if userPrompts == nil then
        return nil
    end

    return userPrompts[promptProductId]
end

function liveCache.clearPendingPrompt(userId: number, promptProductId: number)
    local userPrompts = state.pendingPromptsByUserId[userId]

    if userPrompts == nil then
        return
    end

    userPrompts[promptProductId] = nil

    if next(userPrompts) == nil then
        state.pendingPromptsByUserId[userId] = nil
    end
end

function liveCache.clearPendingPrompts(userId: number)
    state.pendingPromptsByUserId[userId] = nil
end

return liveCache
