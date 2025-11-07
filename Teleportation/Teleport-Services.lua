local ServerStorage = game.ServerStorage

--[[Teleports player to a destination

	Parameter(s):
	model => player's character
	destinationName => name of the destination to where the player will teleport to
]]
function teleportPlayer(char: Model, destinationName: string)
	local destination = workspace:FindFirstChild(destinationName)
	local pos = destination.Position
	char:PivotTo(CFrame.new(pos.X, pos.Y, pos.Z))
	--print(char.Name..' has teleported to '..destinationName..'!')
end

ServerStorage['Teleport Player'].Event:Connect(teleportPlayer)