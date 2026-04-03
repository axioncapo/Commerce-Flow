local signal = {}

function signal.new()
    local listeners = {}
    local purchaseSignal = {}

    function purchaseSignal:connect(callback)
        assert(type(callback) == "function", `Purchase listener expected as function`)

        local listener = {
            callback = callback,
            connected = true,
        }

        table.insert(listeners, listener)

        local connection = {}

        function connection:disconnect()
            if not listener.connected then
                return
            end

            listener.connected = false

            for index, entry in listeners do
                if entry == listener then
                    table.remove(listeners, index)
                    break
                end
            end
        end

        return connection
    end

    function purchaseSignal:fire(...)
        local snapshot = table.clone(listeners)

        for _, listener in snapshot do
            if listener.connected then
                listener.callback(...)
            end
        end
    end

    function purchaseSignal:destroy()
        table.clear(listeners)
    end

    return purchaseSignal
end

return signal
