-- Door Type Hints
local DoorTypeHints = require(script['Door Type Hints'])

-- Door Modules
local DoorModules = script['Door Modules']
local AnimateDoor = DoorModules['Animate Door']
local PlayDoorSound = DoorModules['Play Door Sound']
local SetCollidableParts = DoorModules['Set Collidable Parts']

-- Centralized handler that runs any door in the game
script['Run Door'].Event:Connect(function(DoorDictionaries: {DoorTypeHints.DoorDictionary}, doorOptions: DoorTypeHints.DoorOptions)
	local DoorSound, doorSoundId, canCollide = doorOptions.DoorSound, doorOptions.doorSoundId, doorOptions.canCollide	
	PlayDoorSound:Fire(DoorSound, doorSoundId)
	for _, DoorDictionary in ipairs(DoorDictionaries) do
		SetCollidableParts:Fire(DoorDictionary.Door, canCollide)
		DoorDictionary[(canCollide and 'Close Door') or 'Open Door']:Play()
	end
end)