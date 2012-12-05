(*
A Folder Action Script that copies to clipboard the public URL of any newly created file inside of a public folder in Dropbox or Google Drive
*)

-- replace <YOUR_DROPBOX_ID> with your actual Dropbox ID (eg 12345678)
property dropboxId : "YOUR_DROPBOX_ID"

on adding folder items to this_folder after receiving added_items
	try
		-- almost entirely taken from http://forums.dropbox.com/topic.php?id=4659
		set the item_count to the number of items in the added_items
		if the item_count is equal to 1 then
			set theFile to item 1 of added_items
			-- http://dl-web.dropbox.com/u/123/screenshots/WZUNDS-Screen%20Shot%202012.12.5-16.23.39.png
			tell application "Finder"
				set theNewFileName to the name of theFile
				set theNewFileName to (reformatTimestamp(theNewFileName) of me)
				set theNewFileName to (makeHardToGuess(theNewFileName) of me)
				set theNewFileName to (spacesToUnderscores(theNewFileName) of me)
				set the name of theFile to theNewFileName as string
			end tell
			
			set theRawFilename to ("" & theFile)
			
			-- theRawFilename == "Macintosh HD:Users:USERNAME:Dropbox:Public:screenshots:FILENAME.ext"
			
			set posixRawFilename to POSIX path of theRawFilename
			
			set pathInsidePublic to (do shell script "echo '" & posixRawFilename & "' | sed 's#^.*Dropbox/Public/##'")
			if the pathInsidePublic is not equal to posixRawFilename then
				set theWebSafeFileName to (escapeForURL(pathInsidePublic))
				set theURL to "http://dl-web.dropbox.com/u/" & dropboxId & "/" & theWebSafeFileName
			else
				set theURL to posixRawFilename
			end if
			set the clipboard to theURL as text
			
			-- see http://growl.info/documentation/applescript-support.php
			tell application "System Events"
				set isGrowlRunning to (count of (every process whose bundle identifier is "com.Growl.GrowlHelperApp")) > 0
			end tell
			if isGrowlRunning then
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
		end if
	end try
end adding folder items to

on escapeForURL(theURL)
	return sedShellCommand("-E", "s# #%20#g", theURL)
end escapeForURL

on makeHardToGuess(theFileName)
	return getRandomString() & "-" & theFileName
end makeHardToGuess

on spacesToUnderscores(theFileName)
	return sedShellCommand("-E", "s# #_#g", theFileName)
end spacesToUnderscores


-- from http://face.centosprime.com/macosxw/random-in-applescript/
on getRandomString()
	local output, length, alphabet
	set {alphabet, length} to {"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 6}
	-- set alphabet to "abcdefghijklmnopqrstuvwxyz"
	set output to {}
	
	repeat length times
		set end of output to some item of alphabet
	end repeat
	return output as text --> "JUEQPJBH", "LFOBPXHJI", "TQRVYJPHFA"
end getRandomString

on reformatTimestamp(theFileName)
	local osxScreenshotDateFormat, theDate, reformattedDate
	set osxScreenshotDateFormat to "^(.*)([0-9-]{10}) at ([0-9.]+ [AP]M)(.*)$"
	set theDate to sedShellCommand("-n -E", "s#" & osxScreenshotDateFormat & "#\\2 \\3#p", theFileName)
	
	if theDate is not equal to "" then
		set reformattedDate to formatTimestamp(theDate)
		set theFileName to sedShellCommand("-E", "s#" & osxScreenshotDateFormat & "#\\1" & reformattedDate & "\\4#", theFileName)
	end if
	return theFileName
end reformatTimestamp

-- see http://www.j-schell.de/node/58
on formatTimestamp(x)
	set x to date (x)
	set {m, d, y, t, h, mi, s} to {x's month as integer, x's day, x's year, x's time string, x's hours, x's minutes, x's seconds}
	return (y & "." & m & "." & d & "-" & h & "." & mi & "." & s) as string
end formatTimestamp


-- see http://stackoverflow.com/a/12292190
on sedShellCommand(sedFlags, sedExpression, str)
	set shellCmd to "echo " & quoted form of str & " | sed " & sedFlags & " " & quoted form of sedExpression
	return (do shell script shellCmd)
end sedShellCommand
