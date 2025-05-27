-- Installer for the Enchanted Book Store system
local repo = "https://raw.githubusercontent.com/Technikhighknee/cc-book-store/refs/heads/main/book-store/" -- adjust to your repository URL

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
    print("Downloading " .. url .. " -> " .. path)
    local ok = shell.run("wget", url, path)
    if not ok then
        print("Failed to download " .. url)
    end
end

print("Book Store installed. Start with: shell.run('book-store/apps/index.lua')")