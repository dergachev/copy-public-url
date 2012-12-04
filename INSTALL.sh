#!/bin/bash

# INSTALL.sh: a sample shell script to demonstrate the concept of Bash shell functions

# define usage function
usage(){
	echo "Usage: $0 <YOUR_DROPBOX_ID>"
	echo "  Alternatively, edit INSTALL-CONFIG.sh to provide default arguments"
	exit 1
}

FOLDER_ACTIONS_PATH="$HOME/Library/Scripts/Folder Action Scripts/"

# see http://stackoverflow.com/a/246128, /dev/null since my "CD" is verbose
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null ;  pwd )"
SOURCE_SCRIPT="$SCRIPT_PATH/copy-public-url.applescript"

# Parse command-line args, defaulting to missing values in INSTALL-CONFIG.sh
source "$SCRIPT_PATH"/INSTALL-CONFIG.sh
DROPBOX_ID=${1:-$DEFAULT_DROPBOX_ID}
 
# call usage() function if filename not supplied
# [[ $# -eq 0 ]] && usage
[[ -z $DROPBOX_ID ]] && usage


echo "Ensuring $FOLDER_ACTIONS_PATH exists"
[ -d "$FOLDER_ACTIONS_PATH" ] || mkdir -p "$FOLDER_ACTIONS_PATH"

echo "Performing find-and-replace; setting property YOUR_DROPBOX_ID to '$DROPBOX_ID'"
sed -E "/^property.*dropboxId/ s/YOUR_DROPBOX_ID/$DROPBOX_ID/" $SOURCE_SCRIPT > "$SOURCE_SCRIPT.modified"

echo "compiling copy-public-url.scpt"
osacompile -o "$SCRIPT_PATH/copy-public-url.scpt" "$SOURCE_SCRIPT.modified"

echo "dropbox-copy-public-url.scpt installed to $FOLDER_ACTIONS_PATH"
ln -f -s "$SCRIPT_PATH/copy-public-url.scpt" "$FOLDER_ACTIONS_PATH/copy-public-url.scpt" 

echo "cleaning up: removing temporary files"
rm "$SOURCE_SCRIPT.modified"
