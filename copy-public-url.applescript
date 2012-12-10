(*
A Folder Action Script that copies to clipboard the public URL of any newly 
created file inside of a public folder in Dropbox

Let's say you have a file at this path:
  /Users/dergachev/Dropbox/Public/screenshots/XMLLHA-Screen_Shot_2012.12.10-16.23.53.png
Then it will growl and copy the following URL: 
  http://dl-web.dropbox.com/u/12345678/screenshots/IYLPOO-Screen_Shot_2012.12.10-16.32.48.png
If the property "renameFiles" is set, then it will also rename the new files as follows:
 "Screen Shot 2012-12-10 at 4.23.53 PM.png" becomes "XMLLHA-Screen_Shot_2012.12.10-16.23.53.png"

*)

-- replace <YOUR_DROPBOX_ID> with your actual Dropbox ID (eg 12345678)
property dropboxId : "YOUR_DROPBOX_ID"
property renameFiles : true -- whether to rename newly created files

on adding folder items to this_folder after receiving added_items
	try
		set the item_count to the number of items in the added_items
		if the item_count is equal to 1 then
			set theFile to item 1 of added_items
			
			if renameFiles then
				renameFile(theFile)
			end if
			
			-- /Users/dergachev/Dropbox/Public/screenshots/XMLLHA-Screen_Shot_2012.12.10-16.23.53.png
			-- http://dl-web.dropbox.com/u/12345678/screenshots/IYLPOO-Screen_Shot_2012.12.10-16.32.48.png
			set filePath to POSIX path of (theFile)
			if isFileInsideDropboxPublic(filePath) then
				set theURL to "http://dl-web.dropbox.com/u/" & dropboxId & "/" & pathInsideDropboxPublic(filePath)
			else
				set theURL to theRawFilename
			end if
			
			set the clipboard to theURL as text
			sendGrowlNotification(theURL)
			
			(*
			-- reveal newly added files in Finder
			tell application "Finder"
				activate
				reveal the added_items
			end tell
			*)
			
		end if
	on error errMsg
		display alert "AppleScript Error: " & errMsg
	end try
end adding folder items to

-- "Screen Shot 2012-12-10 at 4.23.53 PM.png" becomes "XMLLHA-Screen_Shot_2012.12.10-16.23.53.png"
on renameFile(theFile)
	tell application "Finder"
		set theNewFileName to the name of theFile
		-- reformatTimestamp must come before other transformations
		set theNewFileName to (reformatTimestamp(theNewFileName) of me)
		set theNewFileName to (makeHardToGuess(theNewFileName) of me)
		set theNewFileName to (spacesToUnderscores(theNewFileName) of me)
		set the name of theFile to theNewFileName as string
	end tell
end renameFile

on makeHardToGuess(theFileName)
	return getRandomString() & "-" & theFileName
end makeHardToGuess

on spacesToUnderscores(theFileName)
	return sedShellCommand("-E", "s# #_#g", theFileName)
end spacesToUnderscores

on pathInsideDropboxPublic(theFileName)
	return sedShellCommand("-E", "s#^.*/Dropbox/Public/##g", theFileName)
end pathInsideDropboxPublic

on isFileInsideDropboxPublic(theFileName)
	-- see http://developer.apple.com/library/mac/#technotes/tn2065/_index.html
	try
		do shell script ("echo " & (quoted form of theFileName) & " | grep 'Dropbox/Public'")
		return true
	on error errMsg
		return false
	end try
end isFileInsideDropboxPublic

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

on sendGrowlNotification(message)
	--display alert ("Message: " & |message|)
	
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
				"Copy Public URL" description ¬
				(message) application name "CopyDropboxURL"
		end tell
		-- icon of file (path to me)
		--	icon of application "Dropbox"
		
	end if
end sendGrowlNotification

-- debugging code, triggered by the "Run" button in AppleScript Editor
on run
	-- sendGrowlNotification("Growl message")
	-- isFileInsideDropboxPublic("/Users/dergachev/Dropbox/Publik/screenshots/XMLLHA-Screen_Shot_2012.12.10-16.23.53.png")
end run
