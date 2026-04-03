export type PurchaseSource = "receipt" | "manual" | "ownership" | "giftProduct"
export type PurchaseType = "product" | "gamepass"

export type PurchaseActor = {
    userId: number,
    name: string?,
}

export type PurchaseRecord = {
    purchaseId: string,
    purchaseType: PurchaseType,
    productKey: string,
    productId: number?,
    gamepassId: number?,
    buyerUserId: number,
    rewardedUserId: number,
    gifting: boolean,
    giftTarget: number?,
    source: PurchaseSource,
    purchasedAt: number,
    confirmed: boolean,
    domainName: string,
    receiptToken: string,
    confirmationReason: string?,
    buyer: PurchaseActor,
    rewarded: PurchaseActor,
}

return nil
