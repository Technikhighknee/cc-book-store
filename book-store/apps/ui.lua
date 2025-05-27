-- Graphical interface for the Enchanted Book Store
-- Allows searching and building books with mouse support

local utils = dofile(fs.combine(fs.getDir(shell.getRunningProgram()), "../core/utils.lua"))
local db = utils.load_db()

local mon = peripheral.find("monitor")
if mon then
  term.redirect(mon)
  if mon.setTextScale then mon.setTextScale(0.5) end
end

local function withdraw_book(slot)
  local ok, err = utils.withdraw_book(slot)
  if ok then
    print("Moved to output chest")
  else
    print(err)
  end
  sleep(1)
end


local function display_table(rows, headers, line_map)
  term.clear()
  term.setCursorPos(1,1)
  if headers then
    print(string.format("%-16s %-5s %-6s %s", headers[1], headers[2], headers[3], headers[4]))
  end
  local y = 2
  for _, r in ipairs(rows) do
    local loc = r.loc or ""
    print(string.format("%-16s %-5s %-6s %s", r.name, r.level, r.extra, loc))
    if line_map and r.slot then line_map[y] = r.slot end
    y = y + 1
  end
  return y
end

local function wait_for_click(line_map)
  while true do
    local e, b, x, y = os.pullEvent()
    if e == "mouse_click" and line_map[y] then
      withdraw_book(line_map[y])
      break
    elseif e == "char" or e == "key" then
      break
    end
  end
end

local function search_ui()
  term.clear()
  term.setCursorPos(1,1)
  io.write("Enchantment name: ")
  local name = read()
  io.write("Level (optional): ")
  local lvls = read()
  local lvl = tonumber(lvls)

  local results = {}
  for key, data in pairs(db) do
    local eName, eLvl = key:match("([^:]+):(%d+)")
    if eName then
      local match = eName:lower():find(name:lower(), 1, true)
      local level_ok = (not lvl) or tonumber(eLvl) == lvl
      if match and level_ok then
        table.insert(results, {
          name = eName,
          level = eLvl,
          extra = data.count,
          loc = data.slots[1].inv .. "[" .. data.slots[1].slot .. "]",
          slot = data.slots[1]
        })
      end
    end
  end

  local map = {}
  display_table(results, {"Enchant", "Lvl", "Count", "Location"}, map)
  if #results > 0 then
    print() ; print("Click entry to withdraw or press any key to return")
    wait_for_click(map)
  else
    print() ; print("No matches. Press any key")
    os.pullEvent("key")
  end
end

local function build_ui()
  term.clear()
  term.setCursorPos(1,1)
  io.write("Desired enchants (e.g. unbreaking 3, mending 1): ")
  local input = read()
  if not input or input == "" then return end

  local requests = utils.parse_enchant_list(input)
  local rows = {}
  for _, req in ipairs(requests) do
    local key = req.name .. ":" .. tostring(req.level)
    local entry = db[key]
    if entry and entry.count > 0 then
      table.insert(rows, {
        name = req.name,
        level = req.level,
        extra = "ok",
        loc = entry.slots[1].inv .. "[" .. entry.slots[1].slot .. "]",
        slot = entry.slots[1]
      })
    else
      table.insert(rows, {name=req.name, level=req.level, extra="missing"})
    end
  end

  local map = {}
  display_table(rows, {"Enchant", "Lvl", "Status", "Location"}, map)
  print() ; print("Click available entry to withdraw or press any key to return")
  wait_for_click(map)
end

local function menu()
  while true do
    term.clear()
    term.setCursorPos(1,1)
    print("Enchanted Book Store")
    print("1) Search books")
    print("2) Build books")
    print("3) Exit")
  local line_choice = { [2] = search_ui, [3] = build_ui, [4] = true }
    local choice
    while not choice do
      local e, p1, x, y = os.pullEvent()
      if e == "char" then
        if p1 == "1" then choice = search_ui
        elseif p1 == "2" then choice = build_ui
        elseif p1 == "3" then return end
      elseif e == "mouse_click" and line_choice[y] then
        if line_choice[y] == true then
          return
        else
          choice = line_choice[y]
        end
      end
    end
    if choice then choice() end
  end
end

menu()
