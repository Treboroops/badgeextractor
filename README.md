# badgeextractor
A small program to extract badge data from City of Heroes game chat log files. Includes SQL database of badges.

How to use.
-----------

In City of Heroes enable chat logging.
Menu->Options->Windows->Chat.
Now any badge gained and and badge title selected will be in the log file and can be read by badgeextractor.
This can be set as the default and badgeextractor will create a list for all characters.

Open badgeextractor.

Use the options window to select the location of logfiles produced by CoH and the output directory where you want the output files from the program to be placed.
By default these are both set to the location the application is in.

Press 'Parse Chat' and select a log file to be read.
Any badges gained or errors found will be written to the main text window.
The program will automatically export a text file for every character that contains entries in the chat logs and export a list of badges gained to it.

Then the Report button can be used to read in a list of badges and list any badges still needed. Use the drop down list to show badges needed for specific types.

Possible Issues.
----------------

If you start logging for a character after that character has logged into the game it will look as though any badges gained belonged to the previous character.
To correct this after enabling logging immediately log out then back in again.
Ideally make the default to enable chatlogs for all characters.

If the sqlite database is not in the package a new one will need to be made using the SQL file included. Use the database filename 'default.sqlite' and put in the same directory as the executable.