#!/bin/bash

# INSTALL.sh: compiles copy-public-url.applescript into copy-public-url.scpt, 
# then installs it to users "Folder Action Scripts" directory.

# define usage function
usage(){
	echo "Usage: $0 <YOUR_DROPBOX_ID>"
	echo "  Alternatively, edit INSTALL-CONFIG.sh to provide default arguments" 2>&1
	exit 1
}

FOLDER_ACTIONS_PATH="$HOME/Library/Scripts/Folder Action Scripts/"

# Define absolute path to the folder containing INSTALL.sh; see http://stackoverflow.com/a/246128
#  /dev/null since my "cd" command is surprisingly verbose
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null ;  pwd )"

# Absolute path to plain-text .applescript file
SOURCE_SCRIPT="$SCRIPT_PATH/copy-public-url.applescript"

# Parse command-line args, defaulting to missing values in INSTALL-CONFIG.sh
source "$SCRIPT_PATH"/INSTALL-CONFIG.sh
DROPBOX_ID=${1:-$DEFAULT_DROPBOX_ID}
 
# call usage() function if $DROPBOX_ID is blank
[[ -z $DROPBOX_ID ]] && usage

echo "Ensuring '$FOLDER_ACTIONS_PATH' exists"
[ -d "$FOLDER_ACTIONS_PATH" ] || mkdir -p "$FOLDER_ACTIONS_PATH"

echo "Performing find-and-replace; setting property YOUR_DROPBOX_ID to '$DROPBOX_ID'"
sed -E "/^property.*dropboxId/ s/YOUR_DROPBOX_ID/$DROPBOX_ID/" $SOURCE_SCRIPT > "$SOURCE_SCRIPT.modified"

# Folder Action Scripts don't seem to work unless they're converted into
# Apple's binary `scpt` format, which is editable via the "AppScript Editor"
# app. The following converts `copy-public-url.applescript` into
# `copy-public-url.scpt`.
echo "compiling copy-public-url.scpt"
osacompile -o "$SCRIPT_PATH/copy-public-url.scpt" "$SOURCE_SCRIPT.modified"

echo "Creating symlink to dropbox-copy-public-url.scpt inside '$FOLDER_ACTIONS_PATH'"
ln -f -s "$SCRIPT_PATH/copy-public-url.scpt" "$FOLDER_ACTIONS_PATH/copy-public-url.scpt" 

echo "cleaning up: removing temporary files"
rm "$SOURCE_SCRIPT.modified"

echo "Don't forget to associate copy-public-url.scpt as Folder Action for the desired folder."
