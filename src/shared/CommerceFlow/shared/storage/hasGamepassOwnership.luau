local MarketplaceService = game:GetService("MarketplaceService")

local purchaseType = require(script.Parent.Parent.constants.purchaseType)

return function(userId: number, runtime)
    assert(type(userId) == "number", `userId expected as number`)
    assert(runtime.kind == purchaseType.gamepass, `hasGamepassOwnership can only validate gamepass runtimes`)

    local success, result = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(userId, runtime.gamepassId)
    end)

    assert(success, `Failed to validate gamepass ownership for {runtime.domainName}.{runtime.productKey}: {result}`)

    return result == true
end
