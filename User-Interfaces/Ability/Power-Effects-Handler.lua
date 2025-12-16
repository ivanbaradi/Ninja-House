--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage

--[[Set of body parts from both R6 and R15 character
	models. Used to modify 'Ninja Effect' objects 
	from each of the corresponding body parts.
	
	Key:
		Body Part => Name of the R6 or R15 body part
	
	Properties:
		Fire Size => Size of the fire from 'Ninja Effect'
]]
local BodyParts = {
	
	--R6 and R15 body parts
	['Head'] = {['Fire Size'] = 0},
	['HumanoidRootPart'] = {['Fire Size'] = 3},
	
	--R15 models body parts
	['UpperTorso'] = {['Fire Size'] = 4},
	['LowerTorso'] = {['Fire Size'] = 3},
	['LeftUpperArm'] = {['Fire Size'] = 3.5},
	['LeftLowerArm'] = {['Fire Size'] = 3},
	['LeftHand'] = {['Fire Size'] = 3},
	['RightUpperArm'] = {['Fire Size'] = 3.5},
	['RightLowerArm'] = {['Fire Size'] = 3},
	['RightHand'] = {['Fire Size'] = 3},
	['LeftUpperLeg'] = {['Fire Size'] = 3},
	['LeftLowerLeg'] = {['Fire Size'] = 3},
	['LeftFoot'] = {['Fire Size'] = 3},
	['RightUpperLeg'] = {['Fire Size'] = 3},
	['RightLowerLeg'] = {['Fire Size'] = 3},
	['RightFoot'] = {['Fire Size'] = 3},
	
	--R6 models body parts
	['Torso'] = {['Fire Size'] = 5},
	['Left Arm'] = {['Fire Size'] = 3},
	['Right Arm'] = {['Fire Size'] = 3},
	['Left Leg'] = {['Fire Size'] = 3},
	['Right Leg'] = {['Fire Size'] = 3}
}



--[[Adds fire to the player's character

	Parameter(s):
		player (Player) => targeted player to add fire to its character
]]
ReplicatedStorage:FindFirstChild('Add Ninja Super Power Effects').OnServerEvent:Connect(function(player: Player)
	
	--Gets player's charatcer
	local char = player.Character

	--Only loops through character's body parts
	for _, bodyPart in pairs(char:GetChildren()) do	
		if bodyPart:IsA('MeshPart') --[[R15]] or bodyPart:IsA('Part') --[[R6]] then
			local Fire = Instance.new('Fire', bodyPart)
			Fire.Name = 'Ninja Effect'
			Fire.Color = Color3.fromRGB(253, 141, 66)
			Fire.Size = BodyParts[bodyPart.Name]['Fire Size']
			Fire.Heat = 1
			--print('Ninja effects add to '..bodyPart.Name)
		end
	end
end)



--[[Removes fire from the player's character

	Parameter(s):
		player (Player) => targeted player to remove fire from its character

]]
ReplicatedStorage:FindFirstChild('Remove Ninja Super Power Effects').OnServerEvent:Connect(function(player: Player)
	
	--Gets player's charatcer
	local char = player.Character	
	
	--Only loops through character's body parts
	for _, bodyPart in pairs(char:GetChildren()) do
		if bodyPart:IsA('MeshPart') or bodyPart:IsA('Part') then
			local NinjaEffect = bodyPart:FindFirstChild('Ninja Effect')
			if NinjaEffect then NinjaEffect:Remove() end
		end
	end
end)