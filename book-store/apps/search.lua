local utils = require("book-store.core.utils")
local db = utils.load_db()

if utils.table_length(db) == 0 then
    print("Datenbank leer. Bitte index.lua ausf\195\188hren.")
    return
end

local term = require and term or _G.term
local input = utils.input_prompt("Suche nach Enchantment:")
if not input or input == "" then return end

input = input:lower()
for key, data in pairs(db) do
    if key:lower():find(input, 1, true) then
        print(key .. " - " .. data.count .. " B\195\188cher")
        for _, slot in ipairs(data.slots) do
            print("  " .. slot.inv .. " [" .. slot.slot .. "] x" .. slot.count)
        end
    end
end
