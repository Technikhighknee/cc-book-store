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

local parsed = utils.parse_enchant_list(request)[1]
if not parsed then return end
local key = parsed.name .. ":" .. tostring(parsed.level)
local entry = db[key]
if not entry or #entry.slots == 0 then
    print("Not available")
    return
end

local slot = entry.slots[1]
local ok, err = utils.withdraw_book(slot)
if ok then
    utils.remove_slot_from_db(db, key, slot)
    utils.save_db(db)
    print("Book moved")
else
    print(err)
end
