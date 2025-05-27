local utils = require("book-store.core.utils")
local db = utils.load_db()

if utils.table_length(db) == 0 then
    print("Keine Datenbank gefunden. Bitte index.lua ausf\195\188hren.")
    return
end

local request = utils.input_prompt("Welches Enchantment ausgeben (z.B. unbreaking 3):")
if not request or request == "" then return end

local name, lvl = request:match("%s*(%S+)%s*(%d*)")
lvl = tonumber(lvl) or 1
local key = name .. ":" .. tostring(lvl)
local entry = db[key]
if not entry or #entry.slots == 0 then
    print("Nicht verf\195\188gbar")
    return
end

local out, outName = utils.find_peripheral("chest")
if not out then
    print("Ausgabe-Kiste nicht gefunden")
    return
end

local slot = entry.slots[1]
local inv = peripheral.wrap(slot.inv)
if inv and inv.pushItems then
    inv.pushItems(outName, slot.slot, 1)
    print("Buch verschoben. Bitte Datenbank aktualisieren")
else
    print("Konnte Buch nicht bewegen")
end
