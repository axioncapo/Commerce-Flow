local gamepassTypes = require(script.Parent.gamepassTypes)
local productTypes = require(script.Parent.productTypes)

export type DomainItem = productTypes.ProductRuntime | gamepassTypes.GamepassRuntime
export type DomainEntry = productTypes.ProductDefinition | gamepassTypes.GamepassDefinition

export type DomainEntries = {
    [string]: DomainEntry,
}

export type DomainItems = {
    [string]: productTypes.ProductRuntime | gamepassTypes.GamepassRuntime,
}

export type DomainRuntimeBase<TItems> = {
    runtimeId: string,
    domainName: string,
    items: TItems,
    getName: (self: any) -> string,
    getRuntimeId: (self: any) -> string,
    getItem: (self: any, productKey: string) -> DomainItem?,
    getItems: (self: any) -> TItems,
    debugSummary: (self: any) -> string,
}

export type DomainRuntime<TItems> = DomainRuntimeBase<TItems> & TItems

return nil
