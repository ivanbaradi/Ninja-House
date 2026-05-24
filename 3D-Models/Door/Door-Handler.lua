--Door Modules
AnimateDoor = script['Animate Door']
PlayDoorSound = script['Play Door Sound']
SetCollidableParts = script['Set Collidable Parts']

--[[Centralized handler that runs any door in the game

	Parameter(s):
		Door: target door
		OpenDoor: opening door animation
		CloseDoor: closing door animation
]]
script['Run Door'].OnInvoke = function(Door: Model, OpenDoor: Tween, CloseDoor: Tween)
		
	--Door Model
	local DoorSound = Door['Door Opener']['Door Sound']
			
	--Configuration
	local Configuration = Door.Configuration
	local InsideDoorOpener = Configuration['Is Inside Door Opener'] -- detects player's existence inside this part
	local WaitTime = Configuration['Close Door Wait Time'] -- waiting time to close the door
	local OpeningSoundID = Configuration['Opening Sound ID'] -- sound for opening the door
	local ClosingSoundID = Configuration['Closing Sound ID'] -- sound for closing the door
	
	--Opens door
	InsideDoorOpener.Value = true
	SetCollidableParts:Fire(Door, false)
	PlayDoorSound:Fire(DoorSound, OpeningSoundID.Value)
	OpenDoor:Play()
	
	--Loops until player left the "Door Opener" part
	repeat task.wait(WaitTime.Value) until not InsideDoorOpener.Value

	--Closes door
	PlayDoorSound:Fire(DoorSound, ClosingSoundID.Value)
	CloseDoor:Play()
	SetCollidableParts:Fire(Door, true)
end