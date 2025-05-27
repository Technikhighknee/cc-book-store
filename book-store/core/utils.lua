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

--- Prompt the user and return the entered string
-- @param msg string prompt message
-- @return string user input
function utils.input_prompt(msg)
    io.write(msg .. " ")
    return read()
end

return utils
