--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Game Owner Settings (Communications)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Power Button
local PowerButton = script.Parent
--Treadmill
local Treadmill = PowerButton.Parent
--Treadmill (Communications)
local TreadmillComms = Treadmill:FindFirstChild('Communications')
--Treadmill Properties
local Properties = Treadmill:FindFirstChild('Properties')
local TreadmillRunning = Properties:FindFirstChild('Treadmill is Running')



PowerButton.ClickDetector.MouseClick:Connect(function(player)
	
	--Checks whether other players have permission to use home accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	if PowerButton.BrickColor == BrickColor.new('Lime green') then
		PowerButton.BrickColor = BrickColor.new('Really red')
		TreadmillRunning.Value = true
		TreadmillComms:FindFirstChild('Power On Treadmill'):Fire()
	else
		TreadmillRunning.Value = false
	end
end)