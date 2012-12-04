SCRIPT_PATH=`dirname $0`

echo "decompiling copy-public-url.scpt into copy-public-url.applescript"
osadecompile "$SCRIPT_PATH/copy-public-url.scpt" > "$SCRIPT_PATH/copy-public-url.applescript"

echo "Performing find-and-replace; resetting setting property YOUR_DROPBOX_ID"
sed -i.bak -E '/^property.*dropboxId/ s/"[0-9]+"/"YOUR_DROPBOX_ID"/' "$SCRIPT_PATH/copy-public-url.applescript"

echo "Removing spurrious blank lines from end of file introduced in osacompile"
perl -i -pe "chomp if eof" "$SCRIPT_PATH/copy-public-url.applescript" 

echo "cleaning up: removing temporary files"
rm "$SCRIPT_PATH/copy-public-url.applescript.bak" 
