copy-public-url
===============

A Folder Action Script that copies to clipboard the public URL of any newly
created file inside of a public folder in Dropbox or Google Drive

## Overview

This gist includes a custom Folder Action Script
(`copy-public-url.applescript`) that copies to clipboard the public URL
of any newly created file inside of `~/Dropbox/Public`, and emit a Growl
notification.

Afterwards, you can configure OS X to store screenshots in
`~/Dropbox/Public/screenshots` (instead of `~/Desktop`), and associate
"copy-public-url.scpt" as a Folder Action to run on all files created in that folder.

Although the script was written with sharing screenshots in mind, it can be associated 
with any folder under `~/Dropbox/Public`.

The script was adapted from http://forums.dropbox.com/topic.php?id=4659

## Installation

Download `dropbox-copy-public-url.applescript` by running the following terminal commands:

Checkout this repo to any directory (perhaps ~/code):

```bash
git clone https://github.com/dergachev/copy-public-url.git
cd copy-public-url
``` 

Before starting, be sure to find your Dropbox user ID (the 12345678 in https://dl.dropbox.com/u/1234567/file.txt); See [Finding your Dropbox ID](#Finding your Dropbox ID)

Now run INSTALL.sh, passing your Dropbox user ID as the first argument. It
compiles copy-public-url.applescript into copy-public-url.scpt, and installs it
to `~/Library/Scripts/Folder\ Action\ Scripts`

```bash
bash INSTALL.sh 123456 # replace 123456 with YOUR_DROPBOX_ID
```

Keep in mind that you can also specify your Dropbox ID by editing INSTALL-CONFIG.sh.

> **Non-terminal option**: Note, if you'd rather do as little command-line as possible, you can achieve the same thing by manually creating `/Users/USERNAME/Library/Scripts/Folder Actions Scripts`, opening up "AppleScript Editor", pasting the contents of `copy-public-url.applescript` into a new script, and saving it as `copy-public-url.scpt` in the newly created folder. See http://apple.stackexchange.com/a/58146. Don't forget to find-and-replace `YOUR_DROPBOX_ID` with your actual Dropbox user ID, eg 12345678. 

Now associate copy-public-url.scpt as a Folder Action to `~/Dropbox/Public/screenshots`. For more info, see [Associating a folder action](#Associating a folder action)

## OS X Screenshots

Optionall, consider running the following terminal commands to tell OS X to
store newly-created screenshots in `~/Dropbox/Public/screenshots`:

```bash
mkdir ~/Dropbox/Public/screenshots
defaults write com.apple.screencapture location ~/Dropbox/Public/screenshots
killall SystemUIServer # restarts SystemUIServer to see change
```

That's it. Now type CMD-SHIFT-4 and take a screenshot, and the dropbox URL should be in your clipboard.
If you have Growl installed, the script will trigger a Growl notification. 

> See http://guides.macrumors.com/Taking_Screenshots_in_Mac_OS_X#Shortcuts for more shortcuts

### Finding your Dropbox ID

To find your Dropbox user ID, do the following: 
* In Finder, right-click on any file under `~/Dropbox/Public`
* choose "Dropbox > Copy Public Link". 
* You'll have a link in your clipboard like http://dl.dropbox.com/u/12345678/mycoolpic.jpg
* 12345678 is the user ID. 

<img src="https://dl.dropbox.com/u/29440342/screenshots/YCOJCG-Screen_Shot_2012.12.8-12.40.53.png" width="50%">

### Assigning a folder action

Now associate copy-public-url.scpt as a Folder Action to ~/Dropbox/Public/screenshots 
(or any other subfolder of ~/Dropbox/Public). See [Associating a folder action](#Associating a folder action)

* In Finder, find and right-click on the Right click on the `~/Dropbox/Public/screenshots` folder 
* Select `copy-public-url.scpt` to have it act on all files added to the `screenshots` folder.

<img src="http://dl-web.dropbox.com/u/29440342/screenshots/UGRLZJ-Screen_Shot_2012.12.6-13.36.30.png" width="50%">



## Contributing Back using DECOMPILE.sh

If you ever want to edit copy-public-url.scpt directly in the AppleScript
Editor, and then push your changes back to copy-public-url.applescript, I've
provided a script called DECOMPILE.sh. Running it will overriding the contents
of copy-public-url.applescript (so be careful!), and remove your Dropbox ID
hardcoded by INSTALL.sh.

## Security concern

By sharing a link to one of your screenshots (eg
`http://dl-web.dropbox.com/u/12345678/screenshots/Screen%20Shot%202012-11-28%20at%206.38.04%20PM.png`)
you are advertising your Dropbox user ID. Based on this, an attacker can easily
guess other URLs for your screenshots, and try them until one works. Keep this
in mind when using Dropbox's Public folder.

## TODO

* Fix security problem, either by leveraging a dropbox feature, or by randomizing file names in the script. [#4](https://github.com/dergachev/copy-public-url/issues/4)
* It would be nice if clicking on the Growl notification showed the file in Finder, or maybe open it in Preview.app for annotations.[#5](https://github.com/dergachev/copy-public-url/issues/5)
* Consider supporting Google Drive or Box[#1](https://github.com/dergachev/copy-public-url/issues/1)
* Is there a dropbox API to do this better than hardcoding the URL syntax?[#6](https://github.com/dergachev/copy-public-url/issues/6)

## Learn more

* http://www.macresearch.org/tutorial_applescript_for_scientists_part_i
* http://www.macresearch.org/tutorial_applescript_for_scientists_part_ii
* http://growl.info/documentation/applescript-support.php
* http://forums.dropbox.com/topic.php?id=4659
* http://collindonnell.com/2012/04/01/share-with-dropbox-applescript/
* http://code.google.com/p/bloodrop/
* https://gist.github.com/3426280 
* http://news.ycombinator.com/item?id=4841234
* http://apple.stackexchange.com/questions/53422/save-screenshot-with-my-own-name?rq=1
