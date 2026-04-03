local DataStoreService = game:GetService("DataStoreService")

local purchaseHistoryStore = DataStoreService:GetDataStore("CommerceFlowPurchaseHistory")
local maxHistorySize = 200

local function appendToUserHistory(userId: number, purchaseRecord)
    purchaseHistoryStore:UpdateAsync(`user:{userId}`, function(currentValue)
        local history = if type(currentValue) == "table" then currentValue else {}

        table.insert(history, purchaseRecord)

        while #history > maxHistorySize do
            table.remove(history, 1)
        end

        return history
    end)
end

return function(purchaseRecord)
    appendToUserHistory(purchaseRecord.buyerUserId, purchaseRecord)

    if purchaseRecord.rewardedUserId ~= purchaseRecord.buyerUserId then
        appendToUserHistory(purchaseRecord.rewardedUserId, purchaseRecord)
    end

    return purchaseRecord
end
