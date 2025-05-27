# Enchanted Book Store

This system automates the handling of enchanted books with ComputerCraft.
It can index inventories, search for enchantments and move books to an output chest.

## Installation

1. Copy the `book-store` folder to your ComputerCraft computer.
2. Alternatively run `install.lua` (edit the repository URL first) to download all files.

Start the initial indexing with:
```lua
shell.run("book-store/apps/index.lua")
```

## Applications
- **index.lua**: scans all connected inventories and builds the database.
- **search.lua**: search the database for enchantments.
- **builder.lua**: check whether a list of enchantments is available.
- **store.lua**: move a book to an output chest.

The database is stored in `book-store/data/db.txt` and can be edited or deleted as needed.
