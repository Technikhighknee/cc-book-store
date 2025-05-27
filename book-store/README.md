# Enchanted Book Store

This system automates the handling of enchanted books with ComputerCraft.
It can index inventories, search for enchantments and move books to an output chest.

## Installation

1. Copy the `book-store` folder to your ComputerCraft computer.
2. Alternatively run `install.lua` to download all files. The installer checks
   for updates each time it runs and will automatically refresh itself if a new
   version is available.

Start the initial indexing with:
```lua
shell.run("book-store/apps/index.lua")
```
You can re-run the indexer later from within the UI.

## Applications
- **index.lua**: scans all connected inventories and builds the database.
- **search.lua**: search the database for enchantments.
- **builder.lua**: check whether a list of enchantments is available and optionally withdraw them.
- **store.lua**: move a book to an output chest and update the database.

The database is stored in `book-store/data/db.txt` and can be edited or deleted as needed.

## Graphical Interface

A unified UI is available in `apps/ui.lua`. Place `startup.lua` in the computer's root to automatically launch the interface on boot. If a monitor is connected the interface will use it for output. The UI allows searching the database and requesting books with mouse clicks as well as checking availability for building enchanted books.
