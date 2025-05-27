local utils = require("book-store.core.utils")

local inventories = utils.find_inventories()
if #inventories == 0 then
    print("Keine Inventar-Peripherien gefunden.")
    return
end

local db = {}

for _, entry in ipairs(inventories) do
    local inv, name = entry[1], entry[2]
    local size = 0
    if inv.size then
        size = inv.size()
    elseif inv.getInventorySize then
        size = inv.getInventorySize()
    end
    for slot=1, size do
        local detail = inv.getItemDetail(slot)
        if detail and detail.enchantments then
            for _, ench in ipairs(detail.enchantments) do
                local key = ench.name .. ":" .. tostring(ench.level)
                if not db[key] then
                    db[key] = {count = 0, slots = {}}
                end
                db[key].count = db[key].count + (detail.count or 1)
                table.insert(db[key].slots, {inv = name, slot = slot, count = detail.count})
            end
        end
    end
end

utils.save_db(db)
print("Indexierung abgeschlossen. Gefundene Eintr\195\164ge: " .. tostring(utils.table_length and utils.table_length(db) or #db))
