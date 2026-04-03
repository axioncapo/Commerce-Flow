local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local bindGamepassFlow = require(script.Parent.bindGamepassFlow)
local bindProcessReceipt = require(script.Parent.bindProcessReceipt)
local liveCache = require(script.Parent.Parent.shared.liveCache)

local server = {}
local runtimeFolderName = "CommerceFlowRuntime"

local function ensureRemote(remoteFolder, className: string, remoteName: string)
    local remote = remoteFolder:FindFirstChild(remoteName)

    if remote ~= nil then
        return remote
    end

    remote = Instance.new(className)
    remote.Name = remoteName
    remote.Parent = remoteFolder

    return remote
end

function server.getRuntimeFolder()
    local sharedFolder = ReplicatedStorage:WaitForChild("Shared")
    local runtimeFolder = sharedFolder:FindFirstChild(runtimeFolderName)

    if runtimeFolder == nil then
        runtimeFolder = Instance.new("Folder")
        runtimeFolder.Name = runtimeFolderName
        runtimeFolder.Parent = sharedFolder
    end

    ensureRemote(runtimeFolder, "RemoteFunction", "preparePrompt")
    ensureRemote(runtimeFolder, "RemoteEvent", "completeGamepassPrompt")

    return runtimeFolder
end

function server.initialize()
    if not liveCache.markServerInitialized() then
        return server.getRuntimeFolder()
    end

    local runtimeFolder = server.getRuntimeFolder()

    bindGamepassFlow(runtimeFolder)
    bindProcessReceipt()

    Players.PlayerRemoving:Connect(function(player)
        liveCache.clearPendingPrompts(player.UserId)
    end)

    return runtimeFolder
end

return server
