-- Roblox Services
ReplicatedStorage = game.ReplicatedStorage
ServerScriptService = game.ServerScriptService
Players = game:GetService('Players')

-- Door Handler Modules
DoorHandler = ServerScriptService['Door Handler']
AnimateDoor = DoorHandler['Animate Door']
RunDoor = DoorHandler['Run Door']

-- Game Owner's Communications
GameOwnerCommunications = ReplicatedStorage['Game Owner Settings'].Communications

-- Animating Door Model
DoorOpener = script.Parent -- part for players to touch for opening the door
Doors = DoorOpener.Parent

-- Prevents unneccessary functional executions
debounce = false

-- Configuration
Configuration = Doors.Configuration
InsideDoorOpener = Configuration['Is Inside Door Opener']

-- Inserts all door models into array to set all their animations
DoorDictionaries = {}
for _, Door in pairs(Doors:GetChildren()) do
	if not Door:IsA('Model') then continue end
	table.insert(DoorDictionaries, {
		Door = Door, 
		OpenDoor = AnimateDoor:Invoke(Door.Hinge, Door.Configuration['Max Door Angle'].Value),
		CloseDoor = AnimateDoor:Invoke(Door.Hinge, 0)
	})
end

--Triggers when a player approaches the door
DoorOpener.Touched:Connect(function(part: BasePart) 
	
	if debounce then return end

	debounce = true
	
	local Character = part:FindFirstAncestorOfClass('Model')
	local Player = Players:GetPlayerFromCharacter(Character)
	
	-- Tells 'Door Handler' script to run all door animations
	if Player and GameOwnerCommunications['Players Can Use Doors']:Invoke(Player) then
		RunDoor:Invoke(DoorDictionaries, Configuration, DoorOpener['Door Sound'])
	end
	
	debounce = false	
end)

--Triggers when a player is leaving the door
DoorOpener.TouchEnded:Connect(function() 
	InsideDoorOpener.Value = false
end)