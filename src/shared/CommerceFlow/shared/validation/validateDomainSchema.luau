return function(domainName: string, entries)
    assert(type(domainName) == "string" and domainName ~= "", `domainName expected as non-empty string`)
    assert(type(entries) == "table", `Domain "{domainName}" entries expected as table`)

    for productKey, definition in entries do
        assert(type(productKey) == "string" and productKey ~= "", `Domain "{domainName}" contains an invalid product key`)
        assert(type(definition) == "table", `Domain "{domainName}.{productKey}" expected as table definition`)
        assert(
            definition.__definitionType == "product" or definition.__definitionType == "gamepass",
            `Domain "{domainName}.{productKey}" expected a product or gamepass definition`
        )
    end

    return entries
end
