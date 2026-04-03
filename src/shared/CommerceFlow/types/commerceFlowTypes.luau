local domainTypes = require(script.Parent.domainTypes)
local gamepassTypes = require(script.Parent.gamepassTypes)
local productTypes = require(script.Parent.productTypes)
local purchaseRecordTypes = require(script.Parent.purchaseRecordTypes)

export type CommerceFlow = {
    createDomain: <TEntries>(domainName: string, entries: TEntries) -> domainTypes.DomainRuntime<TEntries>,
    createProduct: (schema: productTypes.ProductSchema) -> productTypes.ProductDefinition,
    createGamepass: (schema: gamepassTypes.GamepassSchema) -> gamepassTypes.GamepassDefinition,
    product: (self: any, schema: productTypes.ProductSchema) -> productTypes.ProductDefinition,
    gamepass: (self: any, schema: gamepassTypes.GamepassSchema) -> gamepassTypes.GamepassDefinition,
    purchaseSource: {
        receipt: purchaseRecordTypes.PurchaseSource,
        manual: purchaseRecordTypes.PurchaseSource,
        ownership: purchaseRecordTypes.PurchaseSource,
        giftProduct: purchaseRecordTypes.PurchaseSource,
    },
    purchaseType: {
        product: purchaseRecordTypes.PurchaseType,
        gamepass: purchaseRecordTypes.PurchaseType,
    },
}

return nil
