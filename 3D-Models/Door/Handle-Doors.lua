-- Roblox Services
local ServerScriptService = game.ServerScriptService
local ReplicatedStorage = game.ReplicatedStorage

-- Game Owner's Communications
local GameOwnerCommunications = ReplicatedStorage['Game Owner Settings'].Communications
local PlayerCanUseDoors = GameOwnerCommunications['Players Can Use Doors']

-- Player Inside Part
local PlayerInsidePart = ServerScriptService['Players Inside Part']
local AnyPlayerIsInPart = PlayerInsidePart['Any Player Is In Part']

-- Door Handler
local DoorHandler = ServerScriptService['Door Handler']
local DoorModules = DoorHandler['Door Modules']
local AnimateDoor = DoorModules['Animate Door']

-- Door Type Hints
local DoorTypeHints = require(DoorHandler['Door Type Hints'])

-- Door Opener
local DoorOpener = script.Parent
local DoorSound = DoorOpener['Door Sound']

-- Animating Door Model
local Doors = DoorOpener.Parent

-- Configurations
local Configuration = Doors.Configuration
local ClosingSoundId = Configuration['Closing Sound ID']
local OpeningSoundId = Configuration['Opening Sound ID']
local CurrentState = Configuration['Current State']

-- Inserts all door models into array to set all their animations
local DoorDictionaries = {}
for _, Door in pairs(Doors:GetChildren()) do
	if not Door:IsA('Model') then continue end
	table.insert(DoorDictionaries, {
		Door = Door, 
		['Open Door'] = AnimateDoor:Invoke(Door.Hinge, Door.Configuration['Max Door Angle'].Value),
		['Close Door'] = AnimateDoor:Invoke(Door.Hinge, 0)
	})
end

-- Runs indefinitely to perform door animations anytime
while task.wait() do

	--[[Handles door configurations
		
		Parameter(s):
			newState: new state for CurrentState
			doorOptions: door options to configure
	]]
	local function handle(newState: string, doorOptions: DoorTypeHints.DoorOptions)
		if newState == CurrentState.Value then return end
		DoorHandler['Run Door']:Fire(DoorDictionaries, doorOptions)
		CurrentState.Value = newState
		--print('Doors in this model are '..CurrentState.Value)
	end

	-- Determines if any player is inside Door Opener
	local AnyPlayerIsInDoorOpener = AnyPlayerIsInPart:Invoke(DoorOpener, PlayerCanUseDoors)

	handle((AnyPlayerIsInDoorOpener and 'Opened') or 'Closed', {
		DoorSound = DoorSound,
		doorSoundId = (AnyPlayerIsInDoorOpener and OpeningSoundId.Value) or ClosingSoundId.Value,
		canCollide = not AnyPlayerIsInDoorOpener -- this means false, which is meant to make door parts not collidable when opening it
	})
end