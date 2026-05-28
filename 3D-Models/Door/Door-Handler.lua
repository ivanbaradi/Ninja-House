--Door Modules
AnimateDoor = script['Animate Door']
PlayDoorSound = script['Play Door Sound']
SetCollidableParts = script['Set Collidable Parts']

--Door Dictionary type
type DoorDictionary = {
	Door: Model, -- door model
	OpenDoor: Tween, -- animation for opening door
	CloseDoor: Tween -- animation for closing door
}

--[[Centralized handler that runs any door in the game

	Parameter(s):
		DoorDictionaries: list of door dictionaries for animating doors
		Configuration: door configurations
		DoorSound: door sound for playing door noises
]]
script['Run Door'].OnInvoke = function(DoorDictionaries: {DoorDictionary}, Configuration: Configuration, DoorSound: Sound)
			
	--Configuration
	local InsideDoorOpener = Configuration['Is Inside Door Opener'] -- detects player's existence inside this part
	local WaitTime = Configuration['Close Door Wait Time'] -- waiting time to close the door(s)
	local OpeningSoundID = Configuration['Opening Sound ID'] -- sound for opening the door(s)
	local ClosingSoundID = Configuration['Closing Sound ID'] -- sound for closing the door(s)
	
	--[[Runs door animations for each door
	
		Parameter(s):
			SoundID: sound for handling door(s)
			canCollide: flag for making parts collidable; determinant for playing door animations
	]]
	local function runDoorAnimations(SoundID: IntValue, canCollide: boolean)
		PlayDoorSound:Fire(DoorSound, SoundID.Value)
		for _, DoorDictionary in ipairs(DoorDictionaries) do
			SetCollidableParts:Fire(DoorDictionary.Door, canCollide)
			DoorDictionary[(canCollide and 'CloseDoor') or 'OpenDoor']:Play()
		end
	end
	
	--Opens door
	InsideDoorOpener.Value = true
	runDoorAnimations(OpeningSoundID, false)
	
	--Loops until player left the "Door Opener" part
	repeat task.wait(WaitTime.Value) until not InsideDoorOpener.Value

	--Closes door
	runDoorAnimations(ClosingSoundID, true)
end