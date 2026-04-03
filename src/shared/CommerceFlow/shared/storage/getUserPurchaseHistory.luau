local DataStoreService = game:GetService("DataStoreService")

local purchaseHistoryStore = DataStoreService:GetDataStore("CommerceFlowPurchaseHistory")

return function(userId: number)
    assert(type(userId) == "number", `userId expected as number`)

    local history = purchaseHistoryStore:GetAsync(`user:{userId}`)

    if type(history) ~= "table" then
        return {}
    end

    return history
end
