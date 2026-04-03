local purchaseRecordTypes = require(script.Parent.purchaseRecordTypes)

export type ConfirmationHookResult = boolean | {
    approved: boolean,
    reason: string?,
}

export type RewardCallback = (rewardedPlayer: Player, purchaseRecord: purchaseRecordTypes.PurchaseRecord) -> ()
export type ConfirmationHook = (purchaseRecord: purchaseRecordTypes.PurchaseRecord) -> ConfirmationHookResult?
export type PurchaseListener = (rewardedPlayer: Player, purchaseRecord: purchaseRecordTypes.PurchaseRecord) -> ()

export type DisconnectHandle = {
    disconnect: (self: DisconnectHandle) -> (),
}

return nil
