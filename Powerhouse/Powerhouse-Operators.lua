local ServerStorage = game.ServerStorage

--Powerhouse Settings
local PowerhouseSettings = ServerStorage:FindFirstChild('Powerhouse Settings')
local ButtonMoveDistance = PowerhouseSettings['Button Move Distance']
local ButtonMoveTick = PowerhouseSettings['Button Move Tick']


--[[Moves the power button left/right and changes its color red/green

	Parameter(s):
	Button (Part) => Button from the power
	LeverSound (Sound) => Lever sound effect from the button
	buttonColor (BrickColor) => new BrickColor of the button
]]
ServerStorage['Move Power Button'].OnInvoke = function(Button, LeverSound, buttonColor)
	
	--Plays 'Lever' sound effect
	LeverSound:Play()
	
	--Changes button color
	Button.BrickColor = buttonColor
	--Button colors for detecting goal
	local LimeGreen = BrickColor.new('Lime green') --move right, decrease z-pos value
	local ReallyRed = BrickColor.new('Really red') --move left, increase z-pos value
	--Button's current position values
	local X, Y, Z = Button.Position.X, Button.Position.Y, Button.Position.Z
	
	--Stop Z-position
	local goal
	if Button.BrickColor == LimeGreen then
		goal = Z - ButtonMoveDistance.Value
	else
		goal = Z + ButtonMoveDistance.Value
	end

	--Performs button moving animation
	while wait(.01) do
		
		if Button.BrickColor == LimeGreen then
			
			Z -= ButtonMoveTick.Value
			
			if Z < goal then
				Button.Position = Vector3.new(X,Y,goal)
				--print('Overlapped!')
				break
			else
				Button.Position = Vector3.new(X,Y,Z)
				--print('Moving button to the right')
			end
			
		else --Really red
			
			Z += ButtonMoveTick.Value
			
			if Z > goal then
				Button.Position = Vector3.new(X,Y,goal)
				--print('Overlapped!')
				break
			else
				Button.Position = Vector3.new(X,Y,Z)
				--print('Moving button to the left')
			end
		end
	end

	--print('Button completely moved')
end



-----------------[[POWERHOUSE OPERATORS]]-----------------



--[[WATER FOUNTAIN LIGHTS

	Turns on/off water fountain lights

	Parameter(s):
	waterFountainLightsName (string) => Name of water fountains lights model to turn on/off
	enabled (boolean) => {true: lights will turn on, false: lights will turn off}
	material (Enum.Material) => new material for the light
]]
ServerStorage['Turn On/Off Fountain Lights'].Event:Connect(function(waterFountainLightsName, enabled, material)
		
	--print('Processing '..waterFountainLightsName)
	
	--Water Fountain Lights Model
	local WaterFountainLights = workspace:FindFirstChild(waterFountainLightsName)

	for _, WaterFountainLight in pairs(WaterFountainLights:GetChildren()) do
		local Bulb = WaterFountainLight.Bulb
		Bulb.Material = material
		Bulb.SurfaceLight.Enabled = enabled
	end
end)



--[[WATER FOUNTAIN

	Turns on/off water fountain. Each water fountains model contain all
	water fountains and a water sound to play/stop.

	Parameter(s):
	waterFountainsName (string) => name of the water fountains model to operate
	enabled (boolean) => {true: water fountain will be turned on, false: water fountain will be turned off}
]]
ServerStorage['Turn On/Off Fountain'].Event:Connect(function(waterFountainsName, enabled)
	
	--print('Processing '..waterFountainsName)
	
	--Water Fountain Model
	local WaterFountains = workspace:FindFirstChild(waterFountainsName)
	--Water Fountain (Water)
	local Water = workspace:FindFirstChild('Water (Front Water Fountain)')
	local WaterfallSound = Water['Waterfall Sound']

	for _, WaterFountain in pairs(WaterFountains:GetChildren()) do
		local WaterFalls = WaterFountain.Waterfalls
		for _, WaterFall in pairs(WaterFalls:GetChildren()) do
			WaterFall.Water.Enabled = enabled
		end
	end

	--Enables/disables waterfall sound
	if enabled then
		WaterfallSound:Play()
	else
		WaterfallSound:Stop()
	end
end)



--[[POST LIGHTS

	Turns on/off post lights from outside.
		
		
	Parameter(s):
	enabled (boolean) => {true: post lights will turn on, false: post lights will turn off}
	material (Enum.Material) => new material for all post light bulbs
	transparency (float) => new transparency value for all post light bulbs
]]
ServerStorage['Turn On/Off Post Lights'].Event:Connect(function(enabled, material, transparency)	
	for _, PostLight in pairs(workspace:FindFirstChild('Post Lights'):GetChildren()) do
		local Bulb = PostLight.Bulb
		Bulb.Transparency = transparency
		Bulb.Material = material
		Bulb.PointLight.Enabled = enabled
	end
end)



--[[CHRISTMAS TREE

	Turns on/off Christmas Tree from outside.
		
	Parameter(s):
	enabled (boolean) => {true: Christmas Tree will turn on, false: Christmas Tree will turn off}
	material (Enum.Material) => new material for all Christmas Tree lights
]]
ServerStorage['Turn On/Off Christmas Tree'].Event:Connect(function(enabled, material)
	
	local ChristmasTree = workspace:FindFirstChild('Christmas Tree')
	
	ChristmasTree.Tree.TreeTrunk.PointLight.Enabled = enabled
	
	for _, LightGroup in pairs(ChristmasTree.Lights:GetChildren()) do
		for _, Light in pairs(LightGroup:GetChildren()) do
			Light.Material = material
		end
	end
end)