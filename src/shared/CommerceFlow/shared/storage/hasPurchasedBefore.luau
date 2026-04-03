local getUserPurchaseHistory = require(script.Parent.getUserPurchaseHistory)

return function(userId: number, runtime)
    local history = getUserPurchaseHistory(userId)

    for _, purchaseRecord in history do
        if purchaseRecord.confirmed == true
            and purchaseRecord.rewardedUserId == userId
            and purchaseRecord.domainName == runtime.domainName
            and purchaseRecord.productKey == runtime.productKey then
            return true, purchaseRecord
        end
    end

    return false, nil
end
