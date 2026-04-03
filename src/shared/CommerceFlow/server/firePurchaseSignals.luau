return function(runtime, rewardedPlayer: Player, purchaseRecord)
    runtime.purchaseSignal:fire(rewardedPlayer, purchaseRecord)
end
