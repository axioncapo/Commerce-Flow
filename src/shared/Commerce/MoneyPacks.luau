local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommerceFlow = require(ReplicatedStorage.Shared.CommerceFlow)

return CommerceFlow.createDomain("money-packs", {
    LargePack = CommerceFlow.createProduct({
        productId = 1;
        canGift = true,
        purchaseOnceTime = false,

        confirmationHook = function(player: Player, receiptData)
            --//confirm some shit here, and return true if player can purchase that
            --// the receipt has all the info to guarantee safe debug/reward
        end, --//that’s not mandatory, it’s just in case you want some extra security before buying something

        reward = function(player, receiptData)
            --// the player param is either the one buying the product or the one they gifted it to; 
            player.Data.Cash.Value += 10000
        end
    })
})