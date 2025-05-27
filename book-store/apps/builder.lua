local utils = require("book-store.core.utils")
local db = utils.load_db()

if utils.table_length(db) == 0 then
    print("Keine Datenbank gefunden. Bitte index.lua ausf\195\188hren.")
    return
end

local input = utils.input_prompt("Gew\195\188nschte Enchants (z.B. unbreaking 3, mending 1):")
if not input or input == "" then return end

local requests = {}
for token in string.gmatch(input, "[^,]+") do
    local name, lvl = token:match("%s*(%S+)%s*(%d*)")
    lvl = tonumber(lvl) or 1
    if name then table.insert(requests, {name=name, level=lvl}) end
end

local slots = {}
for _, req in ipairs(requests) do
    local key = req.name .. ":" .. tostring(req.level)
    local entry = db[key]
    if entry and entry.count > 0 then
        utils.print_colored(req.name .. " " .. req.level .. " \226\156\150 Vorhanden", colors.green)
        table.insert(slots, entry.slots[1])
    else
        utils.print_colored(req.name .. " " .. req.level .. " \226\156\168 Fehlt", colors.red)
    end
end

if #slots > 0 then
    print("Empfohlene Slots:")
    for _, s in ipairs(slots) do
        print("  " .. s.inv .. " [" .. s.slot .. "]")
    end
end
