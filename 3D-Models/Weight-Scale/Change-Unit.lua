--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Communications (Game Owner Settings)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Unit Button
local UnitButton = script.Parent
--Weight Scale
local WeightScale = UnitButton.Parent
--Screen
local Screen = WeightScale.Screen.SurfaceGui
local Unit = Screen.Unit
local Weight = Screen.Weight


--Changes weight unit to pounds or kilograms
UnitButton.ClickDetector.MouseClick:Connect(function(player)
	
	--Checks if the player has permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	if Unit.Text == 'LB' then
		Unit.Text = 'KG'
	else
		Unit.Text = 'LB'
	end
end)