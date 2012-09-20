-- RecordingDone.scpt
-- This script shuts down your mac after EyeTV completes a recording.
-- The script will check if EyeTV is currently recording or if it will begin recording within a given time.
## Author: Dustin Schwartz ##
## Creation Date: 09/07/2011 ##
## Last Updated Date: 09/07/2011 ##
## The Script should be added to the \Library\Application Support\Eye TV\Scripts\TriggeredScripts ##


--RecordingDone(RecordingID)
#This will be automatically called when a recording is finished.
#The script will ask EyeTV if it will start a recording within 5 minutes, if a recording is expected the shutdown\sleep action will be ignored
#The script will also wait until exporting has completed before prompting to shutdown
on RecordingDone(RecordingID)
	--lets wait 60seconds, this helps ensure nothing will start recording or exporting
	delay 60
	
	--if Eyetv is currently Recording do nothing, 
	--otherwise check if eyetv will begin recording
	if eyeTV_Is_CurrentlyRecording() is false then
		
		if eyeTV_Will_BeginRecording(5) is false then
			
			--waitUntil_EyeTV_HasCompletedExporting will delay the script until exporting is complete.
			--if EyeTV is not exporting the function will return immediately
			waitUntil_EyeTV_HasCompletedExporting()
			
			--display shutdown message
			--if abort button is not pressed the system will shutdown.
			if displayShutDownDialog() is true then
				
				shutDownSystemNow()
				
			end if
			
			#Do Nothing: System Shutdown\Sleep Aborted
			
		end if
		
		#Do nothing: EyeTV is currently recording or will begin within the next 5 minutes
		
	end if
	
end RecordingDone


--DisplayShutDownDialog
#returns false if ShutDown should be aborted
#returns true if no action was taken, shutdown should proceed
on displayShutDownDialog()
	
	set abortButtonNotPressed to true
	
	with timeout of 300 seconds
		display dialog "Warning: EyeTV has finished recording and will automatically shutdown in 2 minutes unless you click Cancel!" with icon stop buttons {"Cancel Shutdown"} giving up after 120
		
		set abortButtonNotPressed to gave up of the result
	end timeout
	
	if abortButtonNotPressed is true then
		return true
	end if
	
	return false
end displayShutDownDialog

--ShutDownSystem
#A simple function to shutdown the computer.
#Does not return an object.
on shutDownSystemNow()
	
	tell application "System Events" to shut down
	
end shutDownSystemNow

--putSystemToSleep
#A simple function to put the system to sleep.
#Does not return an object.
on putSystemToSleep()
	
	tell application "System Events" to sleep
	
end putSystemToSleep

--eyeTV_Is_CurrentlyRecording
#returns true if EyeTV is currently recording
#returns false if EyeTV is not currrently recording
on eyeTV_Is_CurrentlyRecording()
	tell application "EyeTV"
		set eyeTV_is_Recording to is_recording
		
		if eyeTV_is_Recording is true then
			return true
		else
			return false
		end if
		
	end tell
end eyeTV_Is_CurrentlyRecording

--eyeTV_Will_BeginRecording
#Accepts 1 argument, a numeric value representing the amount of minutes we should add to the current time
#returns true if EyeTV begins recording within the the given time
#returns false if EyeTV is not scheduled to record anything within the given time
on eyeTV_Will_BeginRecording(bufferInMinutes)
	tell application "EyeTV"
		set eyeTV_is_Recording to is_recording
		set current_date to current date
		set timeToCheck to (current_date + ((bufferInMinutes) * minutes))
		
		repeat with iterated_recording in programs
			if start time of iterated_recording comes after current_date then
				if start time of iterated_recording comes before timeToCheck then
					set eyeTV_is_Recording to true
					exit repeat
				end if
			end if
		end repeat
		
		if eyeTV_is_Recording is true then
			return true
		else
			return false
		end if
		
	end tell
end eyeTV_Will_BeginRecording

--eyeTV_Is_CurrentlyExporting
#returns true if EyeTV is currently exporting
#returns false if EyeTV is not currrently exporting
on eyeTV_Is_CurrentlyExporting()
	tell application "EyeTV"
		set eyeTV_is_Exporting to is_exporting
		
		if eyeTV_is_Exporting is true then
			return true
		else
			return false
		end if
		
	end tell
end eyeTV_Is_CurrentlyExporting

on waitUntil_EyeTV_HasCompletedExporting()
	
	repeat
		
		if eyeTV_Is_CurrentlyExporting() is true then
			delay 60
		else
			exit repeat
		end if
		
	end repeat
	
end waitUntil_EyeTV_HasCompletedExporting

--eyeTV_Is_CurrentlyCompacting
#returns true if EyeTV is currently compacting
#returns false if EyeTV is not currrently compacting
on eyeTV_Is_CurrentlyCompacting()
	tell application "EyeTV"
		set eyeTV_is_Compacting to is_compacting
		
		if eyeTV_is_Compacting is true then
			return true
		else
			return false
		end if
		
	end tell
end eyeTV_Is_CurrentlyCompacting

--eyeTV_Is_CurrentlySavingClipAsRecording
#returns true if EyeTV is currently saving a clip as a recording
#returns false if EyeTV is not currrently saving a clip as a recording
on eyeTV_Is_CurrentlySavingClipAsRecording()
	tell application "EyeTV"
		set eyeTV_is_SavingClipAsRecording to is_saving_clip_as_recording
		
		if eyeTV_is_SavingClipAsRecording is true then
			return true
		else
			return false
		end if
		
	end tell
end eyeTV_Is_CurrentlySavingClipAsRecording

--eyeTVSwitchToFullScreen
#forces eyeTV to switch from window mode to full screen.
#if already in full screen mode, nothing will happen.
on eyeTVSwitchToFullScreen()
	tell application "EyeTV"
		if full screen is false then
			enter full screen
		end if
	end tell
end eyeTVSwitchToFullScreen
