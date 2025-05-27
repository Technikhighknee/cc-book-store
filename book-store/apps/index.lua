
-- Index all enchanted books from attached inventories and build the database

-- load utils relative to this script to avoid require path issues
local utils = dofile(fs.combine(fs.getDir(shell.getRunningProgram()), "../core/utils.lua"))

local inventories = utils.find_inventories()
if #inventories == 0 then
    print("No inventory peripherals found.")
    return
end

local db = {}

for _, entry in ipairs(inventories) do
    local inv, name = entry[1], entry[2]
    local size = utils.get_inventory_size(inv)
    for slot = 1, size do
        local detail = inv.getItemDetail(slot)
        local enchantments = detail and detail.enchantments
        if enchantments then
            for _, ench in ipairs(enchantments) do
                local key = ench.name .. ":" .. tostring(ench.level)
                db[key] = db[key] or {count = 0, slots = {}}
                db[key].count = db[key].count + (detail.count or 1)
                table.insert(db[key].slots, {inv = name, slot = slot, count = detail.count})
            end
        end
    end
end

utils.save_db(db)
print("Indexing finished. Entries found: " .. tostring(utils.table_length(db)))
