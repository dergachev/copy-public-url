copy-public-url
===============

Note: as of Oct 1, 2013, the Dropbox application comes with [screenshot uploads](https://www.dropbox.com/help/1964/en) built in.
The workflow is identical, except that their copied URL links to an HTML page displaying the image,
instead of the file directly, which is arguably a lot more useful.

## Description

A Folder Action Script that copies to clipboard the public URL of any newly
created file inside of a specified subdirectory of Dropbox/Public, and emits a
Growl notification.

The included install-copy-public-url.app configures OS X to store screenshots under 
Dropbox/Public/screenshots, and installs copy-public-url.scpt to automatically run
on file added to that folder. 

## Installation via installer

Before starting, be sure to find your Dropbox user ID, as per [Finding your
Dropbox ID](#finding-your-dropbox-id)

First download (or git clone) this repository somewhere in your home directory.
Then double-click on install-copy-public-url.app, and you're good to go.

Now type CMD-SHIFT-4 to take a screenshot, and you should see the following:

![Screenshot](http://dl-web.dropbox.com/u/29440342/screenshots/CKVTLL-2012.12.10-19.11.png)


## Installation via terminal

For the do-it-yourself types who don't trust installers, the following terminal
commands will also work:

```bash
# Checkout this repo to any directory (perhaps ~/code):
git clone https://github.com/dergachev/copy-public-url.git
cd copy-public-url

# INSTALL.sh compiles copy-public-url.applescript into copy-public-url.scpt, 
# and installs it to `~/Library/Scripts/Folder\ Action\ Scripts` via symlink.
# The first argument is your Dropbox user ID; can also be specified in INSTALL-CONFIG.sh
bash INSTALL.sh 123456 # replace 123456 with YOUR_DROPBOX_ID
``` 

Now associate copy-public-url.scpt as a Folder Action to
`/Users/USERNAME/Dropbox/Public/screenshots`, as per [Installing Folder
Actions](#installing-folder-actions)

## Tips

### Configuring OSX Screenshot Location

The following code will tell OS X to save screeshots to
/Users/USERNAME/Dropbox/Public/screenshots, instead of the default
/Users/USERNAME/Desktop:

```bash
defaults write com.apple.screencapture location ~/Dropbox/Public/screenshots
killall SystemUIServer # restarts SystemUIServer to see change
```

For more info, see http://osxdaily.com/2011/01/26/change-the-screenshot-save-file-location-in-mac-os-x/

### Finding your Dropbox ID

To find your Dropbox user ID, do the following: 
* In Finder, right-click on any file under `~/Dropbox/Public`
* choose "Dropbox > Copy Public Link". 
* You'll have a link in your clipboard like http://dl.dropbox.com/u/12345678/mycoolpic.jpg
* 12345678 is the user ID. 

<img src="https://dl.dropbox.com/u/29440342/screenshots/YCOJCG-Screen_Shot_2012.12.8-12.40.53.png" width="50%">

### Installing Folder Actions

Folder Actions are a mechanism to have OS X automatically run a compiled
applescript (eg copy-public-url.scpt) whenever files are added to a given
folder (perhaps /Users/USERNAME/Dropbox/Public/screenshots).  To install
copy-public-url.scpt as a Folder Action on Dropbox/Public/screenshots:

* In Finder, open Dropbox/Public
* Right click on "screenshots" (or any other folder you'd like)
* Select "Folder Actions Setup"
* Select `copy-public-url.scpt`, and click "Attach"

<img src="http://dl-web.dropbox.com/u/29440342/screenshots/UGRLZJ-Screen_Shot_2012.12.6-13.36.30.png" width="70%">

### Contributing Back via DECOMPILE.sh

If you ever want to make modifications to copy-public-url.applescript, it's
recommended that you make the changes directly to copy-public-url.scpt (via the
AppleScript Editor app), test them, and and then run DECOMPILE.sh to push them
back to copy-public-url.applescript source file.  The Dropbox ID hardcoded into
copy-public-url.scpt will be automatically removed.

### Learn more

Dropbox / screenshots

* http://forums.dropbox.com/topic.php?id=4659
* http://collindonnell.com/2012/04/01/share-with-dropbox-applescript/
* http://code.google.com/p/bloodrop/
* https://gist.github.com/3426280 
* http://news.ycombinator.com/item?id=4841234
* http://apple.stackexchange.com/questions/53422/save-screenshot-with-my-own-name?rq=1

Applescript:

* http://apple.stackexchange.com/a/58146
* http://growl.info/documentation/applescript-support.php
* http://www.macresearch.org/tutorial_applescript_for_scientists_part_i
* http://www.macresearch.org/tutorial_applescript_for_scientists_part_ii
* http://developer.apple.com/library/mac/#documentation/AppleScript/Conceptual/AppleScriptLangGuide/

OS X Screenshots:

* http://guides.macrumors.com/Taking_Screenshots_in_Mac_OS_X#Shortcuts 
* http://git.io/e5HrNQ
