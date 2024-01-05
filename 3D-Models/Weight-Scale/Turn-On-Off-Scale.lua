--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Communications
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Power Button
local PowerButton = script.Parent
--Power Button colors
local green = BrickColor.new('Lime green')
local red = BrickColor.new('Really red')
--Weight Scale
local WeightScale = PowerButton.Parent
--Unit Button
local UnitButton = WeightScale:FindFirstChild('Unit Button')
--Weigh Character Script
local WeighCharacter = WeightScale.Base:FindFirstChild('Weigh Character')



--[[Changes power button's color, turns on/off the
	screen, and sets MaxActivation for the unit
	button

	Parameter(s):
	newColor => sets color for the Power Button
	enabled => {true: screen will turn on, false: screen will turn off}
	maxActivationDistance => sets max amount of studs to use the unit button
	enabled1 => {true: 'Weigh Character' script is enabled, 'Weigh Character' script is disabled}
]]
function setState(newColor, enabled, maxActivationDistance, enabled1)
	PowerButton.BrickColor = newColor
	WeightScale.Screen.SurfaceGui.Enabled = enabled
	UnitButton.ClickDetector.MaxActivationDistance = maxActivationDistance
	WeighCharacter.Enabled = enabled1
end


--Turns on/off scale
PowerButton.ClickDetector.MouseClick:Connect(function(player)
	
	--Checks if the player has permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	if PowerButton.BrickColor == red then --turn on scale
		setState(BrickColor.new('Lime green'), true, 20, true)
	else --turn off scale
		setState(BrickColor.new('Really red'), false, 0, false)
	end
end)