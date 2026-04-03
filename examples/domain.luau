local commerceFlow = require("path.to.commerceFlow")

--//só produtos nesse domain
local products = commerceFlow.createDomain{
    largePack = commerceFlow:product{
        productId = 1;
        canGift = true; -- default for products = true
        purchaseOnceTime = false; -- default false
        
        confirmationHook = function(data)
            
        end; -- quando passar pelo process receipt ele tem que chamar o confirmation hook, a data contem o player dono da chamada + os dados do produto
    
        reward = function(player: Player, ...) --// o usuario será recompensado
            
        end
    };
} 
--// supondo que isso seria um codigo onde guarda produtos de venda de packs de dinheiro
--// caso quem acesse o largePack for o client, ele consegue acessar assim:

--//client
local cashProducts = require("path")

local productInfo = cashProducts.largePack:getProductInfo() --//retorna um product info como se tivesse sido pego pelo "GetProductInfoAsync" porém tipado

cashProducts.largePack:prompt({
    gift = true,
    giftTarget = 0 -- userId do player que irá receber o presente
})

--//server
local cashProducts = require("path")
--//server tambem consegue puxar o info
local productInfo = cashProducts.largePack:getProductInfo() --//retorna um product info como se tivesse sido pego pelo "GetProductInfoAsync" porém tipado

--//server tem acesso ao OnPurchase
cashProducts.largePack:OnPurchase(function(purchasedUser: Player, schema: {
    gifting: boolean,
    giftTarget: number,
})

end)

--// server tambem pode usar o
cashProducts.largePack:rewardUser() -- força o reward de algo para um usuario