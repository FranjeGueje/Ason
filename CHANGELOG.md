## Beta 2.0.0b3
New features:
- Uninstalling: changes on uninstalling engine. Now Ason uninstall the game, delete the game's folder and manifest file.
- Big changes on library and engine: generating cache, jq queries, ... Major changes under the hood.

Fixes, minor changes:
- Fixes on some image sizes: some logos are not standard. Now Ason, resize the images.
- Fix a loop on login function: Set maximum login attempts to 1.
- More stability improvements.

## Beta 2.0.0b2
New features:
- Screenshots window on detail window: new button and window for visualize the screenshots of a game.
- Initially check if the required components are found. 
- Mode Debug. You have to run it like "DEBUG=Y ./Ason.sh". It will created a file named debug.log.

Fixes, minor changes:
- Changes on format of date: from 2020-01-01T00:00:00 to 2020-01-01
- Cuts on somes descriptions: Now all descriptions are complete.
- Check if the target directory exist.

# Version 2.0
New features:
- Change of engine from dialog to yad.
- Images and details of games.
- Nile in binary file.
- Download manager. Support several downloads.

Fixes:
- Stability improvements.


# Version 1.1
New features:
- Option to change game installation location.
- Extend Readme and doc.


# Version 1.0
New features:
- Download/install games from Amazon Games with the prime account.
- Uninstall already installed games.
- Update installed games.
- Synchronize Amazon Games user library.

Fixes:
- Stability improvements.
- Performance improvements.
