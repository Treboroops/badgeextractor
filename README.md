# badgeextractor
Small program to extract badge data from City of Heroes game chat log files. Includes SQL database of badges.

How to use.
If the sqlite database is not in the package a new one will need to be made using the SQL file included. Use the database filename 'default.sqlite' and put in the same directory as the executable.

Open City of Heroes and in the options for each character you want to track badges for set Log Chat to Enabled in Menu->Options->Windows->Chat.
Now any badge gained and and badge title selected will be in the log file and can be read by badgeextractor.

Open badgeextractor. Use the options window to select the location of logfiles produced by CoH and the output directory to the location you want the program to export lists of badges for characters.
By default these are both set to the location the application is in.
Press 'Parse Chat' and select a log file to be read.
Any badges gained or errors found will be written to the main text window.
The program will export a text file for each character that contains entries in the chat logs and export a list of badges gained to it.
The Report button can be used to read in a list of badges and list any badges still needed. Use the drop down list to show badges needed for specific types.