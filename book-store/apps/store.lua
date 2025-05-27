-- Withdraw a specific enchanted book from the system

-- load utils relative to this script to avoid require path issues
local utils = dofile(fs.combine(fs.getDir(shell.getRunningProgram()), "../core/utils.lua"))
local db = utils.load_db()

if utils.table_length(db) == 0 then
    print("No database found. Run index.lua first.")
    return
end

local request = utils.input_prompt("Which enchantment to retrieve (e.g. unbreaking 3):")
if not request or request == "" then return end

local name, lvl = request:match("%s*(%S+)%s*(%d*)")
lvl = tonumber(lvl) or 1
local key = name .. ":" .. tostring(lvl)
local entry = db[key]
if not entry or #entry.slots == 0 then
    print("Not available")
    return
end

local out, outName = utils.find_peripheral("chest")
if not out then
    print("Output chest not found")
    return
end

local slot = entry.slots[1]
local inv = peripheral.wrap(slot.inv)
if inv and inv.pushItems then
    inv.pushItems(outName, slot.slot, 1)
    print("Book moved. Please update the database")
else
    print("Could not move the book")
end
