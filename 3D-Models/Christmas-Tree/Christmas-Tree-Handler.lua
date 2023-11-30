--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
local Communications = ReplicatedStorage['Game Owner Settings'].Communications

--ProximityPrompt
local ProximityPrompt = script.Parent

--Christmas Tree and its parts
local TreeTrunk = ProximityPrompt.Parent
local Tree = TreeTrunk.Parent
local ChristmasTree = Tree.Parent



--[[Turns on/off Christmas Tree

	Parameter(s):
	enabled (boolean) => {true: Christmas Tree will turn on, false: Christmas Tree will turn off}
	material (Enum.Material) => new material for all Christmas Tree lights
]]
function setState(enabled, material)
	
	TreeTrunk.PointLight.Enabled = enabled
	
	for _, LightGroup in pairs(ChristmasTree.Lights:GetChildren()) do
		for _, Light in pairs(LightGroup:GetChildren()) do
			Light.Material = material
		end
	end
end



--Activates when the player interacts with this prompt to turn on/off the Christmas
ProximityPrompt.Triggered:Connect(function(player)
	
	if not Communications['Players Can Home Accessories']:Invoke(player) then return end
	
	TreeTrunk.Click:Play()
	
	if ProximityPrompt.ActionText == 'Turn On' then
		setState(true, Enum.Material.Neon)
		ProximityPrompt.ActionText = 'Turn Off'
	else
		setState(false, Enum.Material.SmoothPlastic)
		ProximityPrompt.ActionText = 'Turn On'
	end
end)