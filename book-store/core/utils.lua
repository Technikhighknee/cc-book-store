-- Utility functions for the Enchanted Book Store system
-- Provides helpers for database handling and peripheral discovery

local utils = {}

-- base path for all data files
local BASE_PATH = settings.get("book_store.basePath") or "book-store"
local DB_FILE = fs.combine(BASE_PATH, "data/db.txt")

--- Load the enchantment database from disk
-- @return table database table or empty table
function utils.load_db()
    if not fs.exists(DB_FILE) then return {} end
    local h = fs.open(DB_FILE, "r")
    local contents = h.readAll()
    h.close()
    local t = textutils.unserialize(contents)
    if type(t) ~= "table" then return {} end
    return t
end

--- Save the enchantment database to disk
-- @param db table database table
function utils.save_db(db)
    fs.makeDir(fs.getDir(DB_FILE))
    local h = fs.open(DB_FILE, "w")
    h.write(textutils.serialize(db))
    h.close()
end

--- Determine the number of slots an inventory has
-- @param inv peripheral
-- @return number size or 0
function utils.get_inventory_size(inv)
    if inv.size then return inv.size() end
    if inv.getInventorySize then return inv.getInventorySize() end
    return 0
end

--- Locate all peripherals that behave like inventories
-- @return table list of {wrapped, name}
function utils.find_inventories()
    local found = {}
    for _, name in ipairs(peripheral.getNames()) do
        if pcall(peripheral.call, name, "list") then
            table.insert(found, {peripheral.wrap(name), name})
        else
            local typ = peripheral.getType(name) or ""
            if typ:find("inventory") then
                table.insert(found, {peripheral.wrap(name), name})
            end
        end
    end
    return found
end

--- Find the first peripheral with a name or type matching a pattern
-- @param pattern string pattern to search
-- @return peripheral?, string? wrapped peripheral and its name
function utils.find_peripheral(pattern)
    for _, name in ipairs(peripheral.getNames()) do
        local typ = peripheral.getType(name) or ""
        if typ:find(pattern) or name:find(pattern) then
            return peripheral.wrap(name), name
        end
    end
    return nil, nil
end

--- Print colored text on screen
-- @param text string message
-- @param color number term color code
function utils.print_colored(text, color)
    local old = term.getTextColor()
    term.setTextColor(color)
    print(text)
    term.setTextColor(old)
end

--- Count the entries of a table
function utils.table_length(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

--- Parse a comma separated list of enchantments
-- @param input string list like "unbreaking 3, mending 1"
-- @return table list of {name=string, level=number}
function utils.parse_enchant_list(input)
    local reqs = {}
    if not input then return reqs end
    for token in string.gmatch(input, "[^,]+") do
        local name, lvl = token:match("%s*(%S+)%s*(%d*)")
        lvl = tonumber(lvl) or 1
        if name then table.insert(reqs, {name = name, level = lvl}) end
    end
    return reqs
end

--- Move a book from a given slot to the first matching chest
-- @param slot table {inv=string, slot=number}
-- @param pattern string? peripheral search pattern (default "chest")
-- @return boolean, string? success flag and error message
function utils.withdraw_book(slot, pattern)
    local out, outName = utils.find_peripheral(pattern or "chest")
    if not out then return false, "Output chest not found" end
    local inv = peripheral.wrap(slot.inv)
    if inv and inv.pushItems then
        inv.pushItems(outName, slot.slot, 1)
        return true
    end
    return false, "Unable to move item"
end

--- Prompt the user and return the entered string
-- @param msg string prompt message
-- @return string user input
function utils.input_prompt(msg)
    io.write(msg .. " ")
    return read()
end

--- Remove a withdrawn book slot from the database
-- @param db table database table
-- @param key string enchantment key name:level
-- @param slot table slot information {inv=string, slot=number}
function utils.remove_slot_from_db(db, key, slot)
    local entry = db[key]
    if not entry then return end
    for i, s in ipairs(entry.slots) do
        if s.inv == slot.inv and s.slot == slot.slot then
            entry.count = entry.count - 1
            table.remove(entry.slots, i)
            if entry.count <= 0 or #entry.slots == 0 then
                db[key] = nil
            end
            break
        end
    end
end

return utils
