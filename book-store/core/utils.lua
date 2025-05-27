local utils = {}

-- base path for data and apps
local BASE_PATH = settings.get("book_store.basePath") or "book-store"
local DB_FILE = fs.combine(BASE_PATH, "data/db.txt")

-- Load database from file
function utils.load_db()
    if not fs.exists(DB_FILE) then
        return {}
    end
    local h = fs.open(DB_FILE, "r")
    local contents = h.readAll()
    h.close()
    local t = textutils.unserialize(contents)
    if type(t) ~= "table" then
        return {}
    end
    return t
end

-- Save database to file
function utils.save_db(db)
    fs.makeDir(fs.getDir(DB_FILE))
    local h = fs.open(DB_FILE, "w")
    h.write(textutils.serialize(db))
    h.close()
end

-- return list of inventories (wrapped peripheral and name)
function utils.find_inventories()
    local invs = {}
    for _, name in ipairs(peripheral.getNames()) do
        if pcall(peripheral.call, name, "list") then
            table.insert(invs, {peripheral.wrap(name), name})
        else
            local typ = peripheral.getType(name) or ""
            if typ:find("inventory") then
                table.insert(invs, {peripheral.wrap(name), name})
            end
        end
    end
    return invs
end

-- find a single peripheral matching pattern in name or type
function utils.find_peripheral(pattern)
    for _, name in ipairs(peripheral.getNames()) do
        local typ = peripheral.getType(name) or ""
        if typ:find(pattern) or name:find(pattern) then
            return peripheral.wrap(name), name
        end
    end
    return nil, nil
end

-- helper: colored printing
function utils.print_colored(text, color)
    local old = term.getTextColor()
    term.setTextColor(color)
    print(text)
    term.setTextColor(old)
end

-- count table entries
function utils.table_length(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

-- helper: prompt user for input
function utils.input_prompt(msg)
    io.write(msg .. " ")
    return read()
end

return utils
