--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Game Owner Settings
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Speed Button
local Button = script.Parent
--Treadmill
local Treadmill = Button.Parent
--Treadmill Properties
local Properties = Treadmill:FindFirstChild('Properties')
local Speed = Properties:FindFirstChild('Speed')
--Treadmill Settings
local Settings = ServerStorage:FindFirstChild('Treadmill Settings')
--Conveyor
local Conveyor = Treadmill:FindFirstChild('Conveyor')


--Increases conveyor speed by 0.5 when clicked by player
Button.ClickDetector.MouseClick:Connect(function(player)
	
	--Checks if players have permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	if Speed.Value < Settings:FindFirstChild('Max Speed').Value then
		Speed.Value += 0.5
		Treadmill.Speed.SurfaceGui.TextLabel.Text = string.format('%.1f', Speed.Value)
		Conveyor.AssemblyLinearVelocity = Conveyor.CFrame.LookVector * Speed.Value
	else
		ReplicatedStorage:FindFirstChild('Announce to Player'):FireClient(player, {
			text = 'Maximum speed has reached',
			textColor = Color3.fromRGB(255, 255, 10)
		})

		ReplicatedStorage:FindFirstChild('Play Sound Effect'):FireClient(player, {
			name = 'Warning', 
			volume = 1 
		})
	end
end)