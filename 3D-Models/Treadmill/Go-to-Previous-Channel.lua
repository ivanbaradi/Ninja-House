--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Button
local Button = script.Parent
--Treadmill
local Treadmill = Button.Parent
--Game Owner Communications
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Collection of TV channels [images]
local Channels = ServerStorage:FindFirstChild('TV Channels [Image]'):GetChildren()
--Current TV Channel Number
local Channel_Number = Treadmill:FindFirstChild('Properties'):FindFirstChild('Channel Number')


Button.ClickDetector.MouseClick:Connect(function(player)
	
	--Checks if other players have permission to use home accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	--Goes to the previous channel
	if Channel_Number.Value > 1 then
		Channel_Number.Value -= 1
	else
		Channel_Number.Value = #Channels
	end
	
	Treadmill.Screen.SurfaceGui.ImageLabel.Image = 'rbxassetid://'..Channels[Channel_Number.Value].Value
end)