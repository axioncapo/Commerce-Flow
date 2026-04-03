local RunService = game:GetService("RunService")

local commerceFlowTypes = require(script.types.commerceFlowTypes)
local domainTypes = require(script.types.domainTypes)
local gamepassTypes = require(script.types.gamepassTypes)
local productTypes = require(script.types.productTypes)
local createDomain = require(script.shared.createDomain)
local createGamepass = require(script.shared.createGamepass)
local createProduct = require(script.shared.createProduct)
local purchaseSource = require(script.shared.constants.purchaseSource)
local purchaseType = require(script.shared.constants.purchaseType)

if RunService:IsServer() then
    require(script.server.init).initialize()
else
    require(script.client.init).initialize()
end

local commerceFlow: commerceFlowTypes.CommerceFlow = {} :: any

local function resolveSchema(selfOrSchema, maybeSchema)
    if maybeSchema ~= nil then
        return maybeSchema
    end

    return selfOrSchema
end

function commerceFlow.createDomain<TEntries>(domainName: string, entries: TEntries): domainTypes.DomainRuntime<TEntries>
    return createDomain(domainName, entries) :: any
end

function commerceFlow.createProduct(schema: productTypes.ProductSchema): productTypes.ProductDefinition
    return createProduct(schema)
end

function commerceFlow.createGamepass(schema: gamepassTypes.GamepassSchema): gamepassTypes.GamepassDefinition
    return createGamepass(schema)
end

function commerceFlow.product(selfOrSchema, maybeSchema): productTypes.ProductDefinition
    return createProduct(resolveSchema(selfOrSchema, maybeSchema))
end

function commerceFlow.gamepass(selfOrSchema, maybeSchema): gamepassTypes.GamepassDefinition
    return createGamepass(resolveSchema(selfOrSchema, maybeSchema))
end

commerceFlow.purchaseSource = purchaseSource
commerceFlow.purchaseType = purchaseType

return table.freeze(commerceFlow)
