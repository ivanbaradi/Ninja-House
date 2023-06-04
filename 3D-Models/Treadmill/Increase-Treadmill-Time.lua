--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--ServerScriptServices
local ServerScriptService = game.ServerScriptService
--Game Owner Settings (Communications)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Button from this script
local Button = script.Parent
--Treadmill Model
local Treadmill = Button.Parent
--Treadmill Properties (this one)
local TreadmillProperties = Treadmill:FindFirstChild('Properties')
--Current Treadmill Time from Properties
local TreadmillTime = TreadmillProperties:FindFirstChild('Time')
--Treadmill Settings from ServerStorage
local TreadmillSettings = ServerStorage:FindFirstChild('Treadmill Settings')



Button.ClickDetector.MouseClick:Connect(function(player)
	
	--Checks of other players have permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	--Increases treadmill time by 30 seconds
	if not TreadmillProperties:FindFirstChild('Treadmill is Running').Value then
		
		if TreadmillTime.Value < TreadmillSettings:FindFirstChild('Max Time').Value then
			TreadmillTime.Value += 30
			Treadmill.Time.SurfaceGui.TextLabel.Text = ServerScriptService['Other Modules']['Format Number to Time']:Invoke(TreadmillTime.Value)
		else
			ReplicatedStorage:FindFirstChild('Announce to Player'):FireClient(player, {
				text = 'Maximum time has reached',
				textColor = Color3.fromRGB(255, 255, 10)
			})
			
			ReplicatedStorage:FindFirstChild('Play Sound Effect'):FireClient(player, {
				name = 'Warning', 
				volume = 1 
			})
		end
	end
end)