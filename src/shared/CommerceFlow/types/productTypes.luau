local callbackTypes = require(script.Parent.callbackTypes)
local productInfoTypes = require(script.Parent.productInfoTypes)
local promptTypes = require(script.Parent.promptTypes)
local purchaseRecordTypes = require(script.Parent.purchaseRecordTypes)

export type ProductSchema = {
    productId: number,
    canGift: boolean?,
    purchaseOnceTime: boolean?,
    confirmationHook: callbackTypes.ConfirmationHook?,
    reward: callbackTypes.RewardCallback,
}

export type NormalizedProductSchema = {
    productId: number,
    canGift: boolean,
    purchaseOnceTime: boolean,
    confirmationHook: callbackTypes.ConfirmationHook?,
    reward: callbackTypes.RewardCallback,
}

export type ProductRuntime = {
    kind: "product",
    runtimeId: string,
    runtimeToken: string,
    domainName: string,
    productKey: string,
    productId: number,
    canGift: boolean,
    purchaseOnceTime: boolean,
    confirmationHook: callbackTypes.ConfirmationHook?,
    reward: callbackTypes.RewardCallback,
    getProductInfo: (self: ProductRuntime) -> productInfoTypes.ProductInfo,
    prompt: (self: ProductRuntime, options: promptTypes.PromptOptions?) -> (),
    OnPurchase: (self: ProductRuntime, callback: callbackTypes.PurchaseListener) -> callbackTypes.DisconnectHandle,
    rewardUser: (self: ProductRuntime, rewardedPlayer: Player, options: promptTypes.ManualRewardOptions?) -> purchaseRecordTypes.PurchaseRecord,
}

export type ProductDefinition = ProductRuntime & {
    __definitionType: "product",
    kind: "product",
    schema: NormalizedProductSchema,
}

return nil
