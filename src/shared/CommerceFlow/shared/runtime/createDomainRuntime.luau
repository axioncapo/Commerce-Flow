local liveCache = require(script.Parent.Parent.liveCache)

return function(domainName: string)
    local domainRuntime = {
        runtimeId = liveCache.nextRuntimeId("domain"),
        domainName = domainName,
        items = {},
    }

    function domainRuntime:getName(): string
        return self.domainName
    end

    function domainRuntime:getRuntimeId(): string
        return self.runtimeId
    end

    function domainRuntime:getItem(productKey: string)
        return self.items[productKey]
    end

    function domainRuntime:getItems()
        return self.items
    end

    function domainRuntime:debugSummary(): string
        local parts = {}

        for productKey, runtime in self.items do
            table.insert(parts, `{productKey}<{runtime.kind}>`)
        end

        table.sort(parts)

        return `{self.domainName} [{table.concat(parts, ", ")}]`
    end

    return domainRuntime
end
