return function(result)
    if result == nil then
        return {
            approved = true,
            reason = nil,
        }
    end

    if type(result) == "boolean" then
        return {
            approved = result,
            reason = if result then nil else "confirmationHook returned false",
        }
    end

    assert(type(result) == "table", `confirmationHook expected to return boolean, table or nil`)
    assert(type(result.approved) == "boolean", `confirmationHook result.approved expected as boolean`)

    if result.reason ~= nil then
        assert(type(result.reason) == "string", `confirmationHook result.reason expected as string`)
    end

    return {
        approved = result.approved,
        reason = result.reason,
    }
end
