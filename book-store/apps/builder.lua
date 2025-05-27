-- load utils relative to this script to avoid require path issues
local utils = dofile(fs.combine(fs.getDir(shell.getRunningProgram()), "../core/utils.lua"))
local db = utils.load_db()

if utils.table_length(db) == 0 then
    print("No database found. Run index.lua first.")
    return
end

local input = utils.input_prompt("Desired enchants (e.g. unbreaking 3, mending 1):")
if not input or input == "" then return end

local requests = utils.parse_enchant_list(input)

local slots = {}
for _, req in ipairs(requests) do
    local key = req.name .. ":" .. tostring(req.level)
    local entry = db[key]
    if entry and entry.count > 0 then
        utils.print_colored(req.name .. " " .. req.level .. " Available", colors.green)
        table.insert(slots, {slot = entry.slots[1], key = key})
    else
        utils.print_colored(req.name .. " " .. req.level .. " Missing", colors.red)
    end
end

if #slots > 0 then
    print("Recommended slots:")
    for _, s in ipairs(slots) do
        print("  " .. s.slot.inv .. " [" .. s.slot.slot .. "]")
    end

    local confirm = utils.input_prompt("Withdraw available books? [y/N]")
    if confirm:lower():find("y") then
        for _, s in ipairs(slots) do
            local ok, err = utils.withdraw_book(s.slot)
            if ok then
                utils.remove_slot_from_db(db, s.key, s.slot)
            else
                print(err)
            end
        end
        utils.save_db(db)
    end
end
