
-- Index all enchanted books from attached inventories and build the database

-- load utils relative to this script to avoid require path issues
local utils = dofile(fs.combine(fs.getDir(shell.getRunningProgram()), "../core/utils.lua"))

local inventories = utils.find_inventories()
if #inventories == 0 then
    print("No inventory peripherals found.")
    return
end

local function add_book(db, name, level, inv_name, slot, count)
    local key = name .. ":" .. tostring(level)
    local entry = db[key] or {count = 0, slots = {}}
    entry.count = entry.count + count
    table.insert(entry.slots, {inv = inv_name, slot = slot, count = count})
    db[key] = entry
end

local function scan_inventory(inv, name, db)
    local size = utils.get_inventory_size(inv)
    for slot = 1, size do
        local detail = inv.getItemDetail(slot)
        local enchantments = detail and detail.enchantments
        if enchantments then
            for _, ench in ipairs(enchantments) do
                add_book(db, ench.name, ench.level, name, slot, detail.count or 1)
            end
        end
    end
end

local db = {}
for _, entry in ipairs(inventories) do
    scan_inventory(entry[1], entry[2], db)
end

utils.save_db(db)
print("Indexing finished. Entries found: " .. tostring(utils.table_length(db)))
