-- Installer for the Enchanted Book Store system
local repo = "https://raw.githubusercontent.com/Technikhighknee/cc-book-store/refs/heads/main/book-store/" -- adjust to your repository URL

-- Check if this installer is up to date. If not, fetch the latest version and
-- restart itself. This avoids manual updates when improvements are pushed to
-- the repository.
local function self_update()
    local url = repo .. "install.lua"
    local tmp = ".installer_tmp.lua"
    if fs.exists(tmp) then fs.delete(tmp) end

    print("Checking for installer updates...")
    local ok = shell.run("wget", url, tmp)
    if not ok or not fs.exists(tmp) then
        print("Could not download latest installer")
        return false
    end

    local h = fs.open(tmp, "r")
    local remote = h.readAll()
    h.close()
    h = fs.open(shell.getRunningProgram(), "r")
    local local_data = h.readAll()
    h.close()

    if remote ~= local_data then
        print("Updating installer to latest version...")
        fs.delete(shell.getRunningProgram())
        fs.move(tmp, shell.getRunningProgram())
        print("Restarting installer...")
        shell.run(shell.getRunningProgram())
        return true
    end

    fs.delete(tmp)
    return false
end

if self_update() then return end

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