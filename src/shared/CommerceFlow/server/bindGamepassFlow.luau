local Players = game:GetService("Players")

local hasGamepassOwnership = require(script.Parent.Parent.shared.storage.hasGamepassOwnership)
local liveCache = require(script.Parent.Parent.shared.liveCache)
local normalizePromptSchema = require(script.Parent.Parent.shared.normalizePromptSchema)
local purchaseSource = require(script.Parent.Parent.shared.constants.purchaseSource)
local purchaseType = require(script.Parent.Parent.shared.constants.purchaseType)
local rewardPurchase = require(script.Parent.rewardPurchase)

local function getRuntimeFromPayload(payload)
    assert(type(payload) == "table", `Prompt payload expected as table`)
    assert(type(payload.domainName) == "string", `Prompt payload.domainName expected as string`)
    assert(type(payload.productKey) == "string", `Prompt payload.productKey expected as string`)

    local runtime = liveCache.getRuntime(payload.domainName, payload.productKey)
    assert(runtime ~= nil, `Runtime "{payload.domainName}.{payload.productKey}" is not registered`)

    return runtime
end

return function(remoteFolder)
    local preparePrompt = remoteFolder:WaitForChild("preparePrompt")
    local completeGamepassPrompt = remoteFolder:WaitForChild("completeGamepassPrompt")

    preparePrompt.OnServerInvoke = function(player, payload)
        local success, response = pcall(function()
            local runtime = getRuntimeFromPayload(payload)
            local promptOptions = normalizePromptSchema(runtime, {
                gift = payload.gift,
                giftTarget = payload.giftTarget,
            })

            if promptOptions.gift and Players:GetPlayerByUserId(promptOptions.giftTarget) == nil then
                return {
                    ok = false,
                    message = "Gift target must be in the server",
                }
            end

            if runtime.kind == purchaseType.gamepass and not promptOptions.gift then
                if hasGamepassOwnership(player.UserId, runtime) then
                    return {
                        ok = false,
                        message = "Player already owns this gamepass",
                    }
                end

                return {
                    ok = true,
                    promptProductId = runtime.gamepassId,
                    usesDeveloperProduct = false,
                }
            end

            local promptProductId = if runtime.kind == purchaseType.product then runtime.productId else runtime.giftProductId

            liveCache.registerPendingPrompt(player.UserId, promptProductId, {
                runtimeToken = runtime.runtimeToken,
                promptOptions = promptOptions,
            })

            return {
                ok = true,
                promptProductId = promptProductId,
                usesDeveloperProduct = true,
            }
        end)

        if success then
            return response
        end

        return {
            ok = false,
            message = response,
        }
    end

    completeGamepassPrompt.OnServerEvent:Connect(function(player, payload)
        local success, result = pcall(function()
            local runtime = getRuntimeFromPayload(payload)

            assert(runtime.kind == purchaseType.gamepass, `completeGamepassPrompt expected a gamepass runtime`)

            if not hasGamepassOwnership(player.UserId, runtime) then
                return {
                    handled = true,
                    confirmed = false,
                    purchaseRecord = nil,
                }
            end

            return rewardPurchase({
                runtime = runtime,
                buyerPlayer = player,
                buyerUserId = player.UserId,
                source = purchaseSource.ownership,
                promptOptions = {
                    gift = false,
                    giftTarget = nil,
                },
                purchaseId = `ownership:{runtime.gamepassId}:{player.UserId}`,
                receiptToken = `ownership:{runtime.gamepassId}:{player.UserId}`,
            })
        end)

        if not success then
            warn(`[CommerceFlow] completeGamepassPrompt failed: {result}`)
            return
        end

        if not result.handled then
            warn(`[CommerceFlow] completeGamepassPrompt retry skipped: {result.message}`)
        end
    end)
end
