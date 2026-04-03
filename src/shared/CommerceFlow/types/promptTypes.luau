local purchaseRecordTypes = require(script.Parent.purchaseRecordTypes)

export type PromptOptions = {
    gift: boolean?,
    giftTarget: (number | Player)?,
}

export type NormalizedPromptOptions = {
    gift: boolean,
    giftTarget: number?,
}

export type ManualRewardOptions = {
    source: purchaseRecordTypes.PurchaseSource?,
    buyerPlayer: Player?,
    buyerUserId: number?,
    gift: boolean?,
    giftTarget: number?,
    receiptToken: string?,
}

return nil
