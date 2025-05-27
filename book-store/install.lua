-- Installationsskript f\195\188r das Book-Store System
local repo = "https://example.com/book-store/" -- URL zum Repository

local files = {
    "core/utils.lua",
    "apps/index.lua",
    "apps/search.lua",
    "apps/builder.lua",
    "apps/store.lua",
}

for _, file in ipairs(files) do
    local url = repo .. file
    local path = fs.combine("book-store", file)
    fs.makeDir(fs.getDir(path))
    if fs.exists(path) then fs.delete(path) end
    print("Lade " .. url .. " -> " .. path)
    local ok = shell.run("wget", url, path)
    if not ok then
        print("Fehler beim Laden von " .. url)
    end
end

print("Book Store installiert. Starte mit: shell.run('book-store/apps/index.lua')")
