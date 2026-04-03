local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommerceFlow = require(ReplicatedStorage.Shared.CommerceFlow)

return CommerceFlow.createDomain("passes", {
    DoubleMoney = CommerceFlow.createGamepass({
        gamepassId = 1; --// gift pass id
        canGift = true,
        giftProduct = 1; --// relative product to send as a gift
        
        confirmationHook = function() --// called when gift product is trying to purchase
            
        end,
        
        reward = function(rewardedPlayer, receiptData)
            --//same things idk what i need to write here
        end
    })
})