-- Query the database for enchantments and show their locations

-- load utils relative to this script to avoid require path issues
local utils = dofile(fs.combine(fs.getDir(shell.getRunningProgram()), "../core/utils.lua"))
local db = utils.load_db()

if utils.table_length(db) == 0 then
    print("Database is empty. Run index.lua first.")
    return
end

local query = utils.input_prompt("Search enchantment:")
if not query or query == "" then return end
query = query:lower()

for key, data in pairs(db) do
    if key:lower():find(query, 1, true) then
        print(key .. " - " .. data.count .. " books")
        for _, slot in ipairs(data.slots) do
            print("  " .. slot.inv .. " [" .. slot.slot .. "] x" .. slot.count)
        end
    end
end
