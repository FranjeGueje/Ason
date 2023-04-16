# Asón ([A]mazon on [S]teamOS [O]ver [N]ile)
_**A GUI for an unofficial Amanzon Games Launcher (nile)**_

This application **is** a frontend, GUI o wizzard for Amazon Games Launcher on Linux. For this purpose, Asón relies use nile https://github.com/imLinguin/nile All the applause for this utility! _**nile**_ is a tool written in Python that serves as an Amazon Games client on Linux, all through simple commands.

Currently, Ason is a utility that downloads and creates an easily accessible portable environment. It's perfect for **SteamOS** which is the environment in which this tool is intended to be focused.

It is fully functional through a series of windows displayed through _**yad**_, which makes it a pleasant and easy to use user experience.


## Why the name Asón (if the author is from Murcia)?
Amazon Games has the name of a river.
Nile has the name of a river.
I wanted to do my bit, but it's impossible to compare with the two previous ones, they are huge! So I've been looking for something nice and small in Spain:

Asón is the shortest river in Spain. It has a total length of 39 kilometers and runs along the Cantabrian coast. Despite its short length, its route is highly recommended as a nature walk because it is in a landscape of great beauty. I have not visited it yet!


## Features
- Download/install games from Amazon Games with the prime account.
- Uninstall already installed games.
- Update installed games.
- Synchronize Amazon Games user library.
- All this through friendly dialogues with images and details of games.
- Download manager. Support several downloads.
- Many more...


## Execution
For the execution of Ason, run directly `Ason.sh` (remember to make it executable) and you should see the wizard menu through the *yad* utility (included in portable form in this tool):
![Main Window](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/MainW.png)
![Library Window](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/LibraryW.png)
![Detail Window](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/DetailW.png)
![Installed Window](https://raw.githubusercontent.com/FranjeGueje/Ason/master/doc/InstalledW.png)

_**FILES**_: Ason has their configuration in ~/.config/nile/ and ~/.cache/ason/ for the cache files.

# Dependencies
This applition is released with all executables, but you can replaced it (if you want).
Ason uses:
* NILE to manage Amazon Games
* YAD to show the dialogs and images.
* JQ to manage json files.
* GNU Util to other functions.

# FAQ
## How do I install it?
* Easy: download the latest release version and unzip it wherever you want. It is portable. After that, make sure that the file "Ason.sh" is executable.

## How is it executed?
* Easy: ejecuta `Ason.sh`

## Can I run games from the Ason itself?
No, Ason does not run games. It downloads them and can add them to Steam, but does not run them. **IMPORTANT**, once the game is added to Steam, make sure to configure "proton compatibility" in Steam.

## Why?
Sorry, I'm not a fan of modifying Steam shortcuts.vdf files to add games. Although I can recommend several tools that could complement this work.

## Is it possible to change the installation location of video games?
Yes, from the options menu.

## How do I uninstall it? I don't want any residue.
Simple. To uninstall Ansó just delete the folders with their subfolders and files:
* The Ason directory
* $HOME/.config/nile
* $HOME/.cache/ason

## Run on Gamemode on Steam?
Yes... You can add to Steam Ason.sh and remember, you must not select any proton compatibility. There are some limitations in Gamemode, such as not being able to search correctly or not being able to see some dialogues because they contain some strange characters for Steam.
