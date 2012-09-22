# EyeTV-AppleScripts - Overview
EyeTV trigger scripts allow an applescript to be run automatically when a specific event occurs within the EyeTV application.  EyeTV supports multiple trigger scripts listed below.

1. ScheduleCreated
2. RecordingStarted
3. RecordingDone
4. ExportDone
5. RecordingDone
6. CompactingDone

For more information please visit [EyeTV's website](http://support.elgato.com/index.php?_m=knowledgebase&_a=viewarticle&kbarticleid=2727 "EyeTV's website").


## Triggerscripts
RecordingDone
: The RecordingDone trigger script will be executed once a recording has finished.  Once started the script will sleep for 1 minute.  This helps ensure EyeTV has enough time to start exporting.  The script will then check if a recording will begin within the next 5 minutes, if it finds a scheduled recording the script exits without taking action.  The script will of course start all over again upon the completion of the next recording.  However, if nothing is scheduled the script then checks if EyeTV is currently exporting.  If it is, the script will sleep until exporting is complete.  Once done the script will prompt to either abort shutdown or shutdown immediately.  The prompt is given 3 minutes and if no action is taken the script will execute a shutdown command.


## Install - Compiled Scripts
1. Open Terminal.
2. cd ~/Documents
3. git clone https://github.com/sykte/EyeTV-AppleScripts.git && cd EyeTV-AppleScripts
4. mdkir /HD/Library/Application Support/EyeTV/Scripts/TriggeredScripts 
5. cp RecordingDone/compiled/RecordingDone.scpt /HD/Library/Application Support/EyeTV/Scripts/TriggeredScripts

*Notes*: Step 4 can be skipped if the directory has already been created.  You should substitute the script directory & scriptname.scpt in step 5 if other scripts are desired.




## EyeTV Library Scripts #
EyeTV library coming soon!