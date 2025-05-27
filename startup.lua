-- Start the Enchanted Book Store UI on boot
local utils = dofile("book-store/core/utils.lua")
local db = utils.load_db()
if utils.table_length(db) == 0 then
  shell.run("book-store/apps/index.lua")
end
shell.run("book-store/apps/ui.lua")
