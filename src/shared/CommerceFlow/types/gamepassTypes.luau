local callbackTypes = require(script.Parent.callbackTypes)
local productInfoTypes = require(script.Parent.productInfoTypes)
local promptTypes = require(script.Parent.promptTypes)
local purchaseRecordTypes = require(script.Parent.purchaseRecordTypes)

export type GamepassSchema = {
    gamepassId: number,
    giftProduct: number?,
    canGift: boolean?,
    purchaseOnceTime: boolean?,
    confirmationHook: callbackTypes.ConfirmationHook?,
    reward: callbackTypes.RewardCallback,
}

export type NormalizedGamepassSchema = {
    gamepassId: number,
    giftProduct: number?,
    canGift: boolean,
    purchaseOnceTime: boolean,
    confirmationHook: callbackTypes.ConfirmationHook?,
    reward: callbackTypes.RewardCallback,
}

export type GamepassRuntime = {
    kind: "gamepass",
    runtimeId: string,
    runtimeToken: string,
    domainName: string,
    productKey: string,
    gamepassId: number,
    giftProductId: number?,
    canGift: boolean,
    purchaseOnceTime: boolean,
    confirmationHook: callbackTypes.ConfirmationHook?,
    reward: callbackTypes.RewardCallback,
    getProductInfo: (self: GamepassRuntime) -> productInfoTypes.ProductInfo,
    prompt: (self: GamepassRuntime, options: promptTypes.PromptOptions?) -> (),
    OnPurchase: (self: GamepassRuntime, callback: callbackTypes.PurchaseListener) -> callbackTypes.DisconnectHandle,
    rewardUser: (self: GamepassRuntime, rewardedPlayer: Player, options: promptTypes.ManualRewardOptions?) -> purchaseRecordTypes.PurchaseRecord,
}

export type GamepassDefinition = GamepassRuntime & {
    __definitionType: "gamepass",
    kind: "gamepass",
    schema: NormalizedGamepassSchema,
}

return nil
