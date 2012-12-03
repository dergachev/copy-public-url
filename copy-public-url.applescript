on adding folder items to this_folder after receiving added_items
	try
		-- almost entirely taken from http://forums.dropbox.com/topic.php?id=4659
		set the item_count to the number of items in the added_items
		if the item_count is equal to 1 then
			set theFile to item 1 of added_items
			set theRawFilename to ("" & theFile)
			
			-- theRawFilename == "Macintosh HD:Users:USERNAME:Dropbox:Public:screenshots:FILENAME.ext"
			
			set posixRawFilename to POSIX path of theRawFilename
			
			set pathInsidePublic to (do shell script "echo '" & posixRawFilename & "' | sed 's#^.*Dropbox/Public/##'")
			if the pathInsidePublic is not equal to posixRawFilename then
				set theWebSafeFileName to switchText from pathInsidePublic to "%20" instead of " "
				-- replace <YOUR_DROPBOX_ID> with your actual Dropbox ID (eg 12345678)
				set dropboxId to "<YOUR_DROPBOX_ID>"
				set theURL to "http://dl-web.dropbox.com/u/" & dropboxId & "/" & theWebSafeFileName
			else
				set theURL to posixRawFilename
			end if
			set the clipboard to theURL as text
			
			-- see http://growl.info/documentation/applescript-support.php
			tell application "GrowlHelperApp"
				
				-- Make a list of all the notification types
				-- that this script will ever send:
				set the allNotificationsList to ¬
					{"Public URL"}
				
				set the enabledNotificationsList to allNotificationsList
				
				-- Register our script with growl.
				-- You can optionally (as here) set a default icon
				-- for this script's notifications.
				register as application ¬
					"CopyDropboxURL" all notifications allNotificationsList ¬
					default notifications enabledNotificationsList ¬
					icon of application "Dropbox"
				
				notify with name ¬
					"Public URL" title ¬
					"Dropbox Public Folder Updated" description ¬
					(theURL & " copied to clipboard.") application name "CopyDropboxURL"
				
			end tell
		end if
	end try
end adding folder items to

to switchText from t to r instead of s
	set d to text item delimiters
	set text item delimiters to s
	set t to t's text items
	set text item delimiters to r
	tell t to set t to item 1 & ({""} & rest)
	set text item delimiters to d
	t
end switchText