--Game Owner Communications
local ReplicatedStorage = game.ReplicatedStorage
local GameOwnerComms = ReplicatedStorage['Game Owner Settings']['Communications']

--Powerhouse Operators
local ServerStorage = game.ServerStorage
local MovePowerButton = ServerStorage['Move Power Button']

--CONFIGURE POWER HANDLER HERE
local PowerHandler = ServerStorage['Turn On/Off Post Lights']

--Button
local Button = script.Parent
--Debouncer
local debounce = false


--Fires when the player presses this button to turn on/off post lights
Button.ClickDetector.MouseClick:Connect(function(player)

	if debounce then return end
	debounce = true

	--Checks if player has permission to use outdoor accessories
	if not GameOwnerComms['Players Can Use Outdoor Accessories']:Invoke(player) then 
		debounce = false
		return 
	end

	if Button.BrickColor == BrickColor.new('Really red') then --turn on
		PowerHandler:Fire(true, Enum.Material.Neon, 0.45)
		MovePowerButton:Invoke(Button, Button.Lever, BrickColor.new('Lime green'))
	else --turn off
		PowerHandler:Fire(false, Enum.Material.Glass, 0.2)
		MovePowerButton:Invoke(Button, Button.Lever, BrickColor.new('Really red'))
	end

	debounce = false
end)


