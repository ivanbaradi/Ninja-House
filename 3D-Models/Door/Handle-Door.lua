--Roblox Services
ReplicatedStorage = game.ReplicatedStorage
ServerScriptService = game.ServerScriptService
Players = game:GetService('Players')

--Door Handler Modules
DoorHandler = ServerScriptService['Door Handler']
AnimateDoor = DoorHandler['Animate Door']
RunDoor = DoorHandler['Run Door']

--Game Owner's Communications
GameOwnerCommunications = ReplicatedStorage['Game Owner Settings'].Communications

--Door Model
DoorOpener = script.Parent -- part for players to touch for opening the door
Door = DoorOpener.Parent
Hinge = Door.PrimaryPart

--Prevents unneccessary functional executions
debounce = false

--Configuration
Configuration = Door.Configuration
InsideDoorOpener = Configuration['Is Inside Door Opener']
MaxDoorAngle = Configuration['Max Door Angle']

--Animations for opening and closing door
openDoor = AnimateDoor:Invoke(Hinge, MaxDoorAngle.Value)
closeDoor = AnimateDoor:Invoke(Hinge, 0)

--Triggers when a player approaches the door
DoorOpener.Touched:Connect(function(part: BasePart) 
	
	if debounce then return end

	debounce = true
	
	local Character = part:FindFirstAncestorOfClass('Model')
	local Player = Players:GetPlayerFromCharacter(Character)
	
	--Must check if other players have permission to use doors
	if not GameOwnerCommunications['Players Can Use Doors']:Invoke(Player) then 
		debounce = false
		return 
	end
	
	--Must check if the model is a character
	if not Character:FindFirstChild('Humanoid') then
		debounce = false
		return 
	end

	RunDoor:Invoke(Door, Character, openDoor, closeDoor)
	
	debounce = false	
end)

--Triggers when a player is leaving the door
DoorOpener.TouchEnded:Connect(function() 
	InsideDoorOpener.Value = false
end)