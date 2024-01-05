--ServerStorage
local ServerStorage = game.ServerStorage
--Add Commas to Floats (BindableFunction)
local AddCommasToFloats = ServerStorage:FindFirstChild('Add Commas to Floats')
--Conveyor
local Conveyor = script.Parent
--Treadmill
local Treadmill = Conveyor.Parent
--Properties
local Properties = Treadmill:FindFirstChild('Properties')
local Calories = Properties:FindFirstChild('Calories')
local Studs = Properties:FindFirstChild('Studs')
local Speed = Properties:FindFirstChild('Speed')
--UIs from the dashboard
local CaloriesUI = Treadmill.Calories.SurfaceGui.TextLabel
local StudsUI = Treadmill.Studs.SurfaceGui.TextLabel
--Debouncer (prevents unneccessary touch events from happening)
local debounce = false



--Increases studs and calories as long as the player moves on the running conveyor
Conveyor.Touched:Connect(function(part)
	
	if debounce then return end
	
	debounce = true
	
	local Humanoid = part.Parent:FindFirstChild('Humanoid')
	
	if Humanoid then
		if Humanoid.Health ~= 0 then
			wait(1)

			Calories.Value += (0.2 * Speed.Value)
			CaloriesUI.Text = AddCommasToFloats:Invoke(nil, Calories.Value, '%.1f')

			Studs.Value += Speed.Value
			StudsUI.Text = AddCommasToFloats:Invoke(nil, Studs.Value, '%.1f')
		end
	end
	
	debounce = false
end)