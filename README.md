copy-public-url
===============

A Folder Action Script that copies to clipboard the public URL of any newly created file inside of a public folder in 
Dropbox or Google Drive

## Overview

This gist includes a custom Folder Action Script (`dropbox-copy-public-url.applescript`) that copies to clipboard the public URL of any newly created file inside of `~/Dropbox/Public`, and emit a Growl notification.

The installation instructions below install the script into `~/Library/Scripts/Folder\ Action\ Scripts`, configure OS X to store screenshots in `~/Dropbox/Public/screenshots` (instead of `~/Desktop`), and configure OS X to run the script on any newly created file in that folder. 

Although the script was written with sharing screenshots in mind, it can be associated 
with any folder under `~/Dropbox/Public`.

The script was adapted from http://forums.dropbox.com/topic.php?id=4659

## Installation

Download `dropbox-copy-public-url.applescript` by running the following terminal commands:

```bash
# custom Folder Action Scripts go here
mkdir ~/Library/Scripts/Folder\ Action\ Scripts
cd ~/Library/Scripts/Folder\ Action\ Scripts

# downloads the script
wget https://raw.github.com/gist/4165548/dropbox-copy-public-url.applescript
```

Now, find your Dropbox user ID, as follows: In Finder, right-click on any file under `~/Dropbox/Public`, choose "Dropbox > Copy Public Link". You'll have a link in your clipboard like http://dl.dropbox.com/u/12345678/mycoolpic.jpg, and 12345678 is the user ID. 

The following sed command automatically finds and replaces "<YOUR_DROPBOX_ID>" with "12345678" in `dropbox-copy-public-url.applescript`. Modify it with your actual Dropbox ID and run it as follows:

```bash
sed -i.bak 's/"<YOUR_DROPBOX_ID>"/"12345678"/' dropbox-copy-public-url.applescript
```

Folder Action Scripts don't seem to work unless they're converted into Apple's binary `scpt` format, which is editable via the "AppScript Editor" app. The following converts `dropbox-copy-public-url.applescript` into `dropbox-copy-public-url.scpt` and removes the original file:

```bash
osacompile -o ~/Library/Scripts/Folder\ Action\ Scripts/dropbox-copy-public-url.scpt dropbox-copy-public-url.applescript
# clean up: remove the original .applescript source files
rm dropbox-copy-public-url.applescript dropbox-copy-public-url.applescript.bak
```

> **Non-terminal option**: Note, if you'd rather do as little command-line as possible, you can achieve the same thing by manually creating `/Users/USERNAME/Library/Scripts/Folder Actions Scripts`, opening up "AppleScript Editor", pasting the contents of `dropbox-copy-public-url.applescript` into a new script, and saving it as `dropbox-copy-public-url.scpt` in the newly created folder. See http://apple.stackexchange.com/a/58146. Don't forget to find-and-replace `<YOUR_DROPBOX_ID>` with your actual Dropbox user ID, eg 12345678. 

The following terminal commands will tell OS X to store screenshots to `~/Dropbox/Public/screenshots`:

```bash
mkdir ~/Dropbox/Public/screenshots
defaults write com.apple.screencapture location ~/Dropbox/Public/screenshots
killall SystemUIServer # restarts SystemUIServer to see change
```

Finally, the following will associate dropbox-copy-public-url.scpt as a Folder Action on `~/Dropbox/Public/screenshots`:

* Locate `~/Dropbox/Public/screenshots` in Finder
* Right click on the `screenshots` folder, select "Folder Actions Setup..."
* Select `dropbox-copy-public-url.scpt` to have it act on all files added to the `screenshots` folder.

That's it. Now type CMD-SHIFT-4 and take a screenshot, and the dropbox URL should be in your clipboard.
If you have Growl installed, the script will trigger a Growl notification. 

> See http://guides.macrumors.com/Taking_Screenshots_in_Mac_OS_X#Shortcuts for more shortcuts

## Security concern

By sharing a link to one of your screenshots (eg `http://dl-web.dropbox.com/u/12345678/screenshots/Screen%20Shot%202012-11-28%20at%206.38.04%20PM.png`) you are advertising your Dropbox user ID. Based on this, an attacker can easily guess other URLs for your screenshots, and try them until one works. Keep this in mind when using Dropbox's Public folder.

## TODO

* Fix security problem, either by leveraging a dropbox feature, or by randomizing file names in the script.
* It would be nice if clicking on the Growl notification showed the file in Finder, or maybe open it in Preview.app for annotations.
* Consider supporting Google Drive or Box
* Is there a dropbox API to do this better than hardcoding the URL syntax?

## Learn more

* http://www.macresearch.org/tutorial_applescript_for_scientists_part_i
* http://www.macresearch.org/tutorial_applescript_for_scientists_part_ii
* http://growl.info/documentation/applescript-support.php
* http://forums.dropbox.com/topic.php?id=4659
* http://collindonnell.com/2012/04/01/share-with-dropbox-applescript/
* http://code.google.com/p/bloodrop/
* https://gist.github.com/3426280 
* http://ihackernews.com/comments/4841234
* http://apple.stackexchange.com/questions/53422/save-screenshot-with-my-own-name?rq=1