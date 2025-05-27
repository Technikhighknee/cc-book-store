# Enchanted Book Store

Dieses System erm\195\182glicht das automatische Indexieren und Ausgeben von verzauberten B\195\188chern in ComputerCraft.

## Installation

1. Kopiere den Ordner `book-store` auf deinen ComputerCraft-Computer.
2. Alternativ kann `install.lua` genutzt werden, um die Dateien per `wget` zu laden (URL in der Datei anpassen).

Start der Indexierung:
```
shell.run("book-store/apps/index.lua")
```

## Anwendungen
- **index.lua**: scannt alle angeschlossenen Inventare und baut die Datenbank auf.
- **search.lua**: Suche nach Enchantments in der Datenbank.
- **builder.lua**: Pr\195\188ft, ob eine Liste von Enchantments vorhanden ist.
- **store.lua**: Gibt ein Buch in eine Ausgabekiste aus.

Die Datenbank befindet sich in `book-store/data/db.txt` und kann manuell bearbeitet oder gel\195\182scht werden.
