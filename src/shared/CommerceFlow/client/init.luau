local ReplicatedStorage = game:GetService("ReplicatedStorage")

local liveCache = require(script.Parent.Parent.shared.liveCache)

local client = {}
local runtimeFolderName = "CommerceFlowRuntime"
local remoteCache = nil

function client.initialize()
    liveCache.markClientInitialized()
end

function client.getRuntimeFolder()
    if remoteCache ~= nil and remoteCache.Parent ~= nil then
        return remoteCache
    end

    local sharedFolder = ReplicatedStorage:WaitForChild("Shared")
    remoteCache = sharedFolder:WaitForChild(runtimeFolderName)

    return remoteCache
end

function client.getRemotes()
    local runtimeFolder = client.getRuntimeFolder()

    return {
        preparePrompt = runtimeFolder:WaitForChild("preparePrompt"),
        completeGamepassPrompt = runtimeFolder:WaitForChild("completeGamepassPrompt"),
    }
end

return client
