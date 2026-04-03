local Players = game:GetService("Players")

return function(buyerPlayer: Player?, promptOptions)
    if promptOptions.gift ~= true then
        assert(buyerPlayer ~= nil, `buyerPlayer expected for non-gift purchase flow`)
        return buyerPlayer, buyerPlayer.UserId
    end

    local giftTargetUserId = promptOptions.giftTarget

    assert(type(giftTargetUserId) == "number", `giftTarget expected as number for gift purchase flow`)

    local rewardedPlayer = Players:GetPlayerByUserId(giftTargetUserId)
    assert(rewardedPlayer ~= nil, `Gift target {giftTargetUserId} is not currently in the server`)

    return rewardedPlayer, giftTargetUserId
end
