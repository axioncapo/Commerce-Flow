local purchaseRecordTypes = require(script.Parent.purchaseRecordTypes)

export type ProductInfo = {
    id: number,
    assetId: number?,
    name: string,
    description: string,
    priceInRobux: number?,
    iconImageAssetId: number?,
    isForSale: boolean,
    kind: purchaseRecordTypes.PurchaseType,
}

return nil
