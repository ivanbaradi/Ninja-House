--Game Owner Communications
local ReplicatedStorage = game.ReplicatedStorage
local GameOwnerComms = ReplicatedStorage['Game Owner Settings']['Communications']

--Powerhouse Operators
local ServerStorage = game.ServerStorage
local MovePowerButton = ServerStorage['Move Power Button']
local FountainSwitcher = ServerStorage['Turn On/Off Fountain']

--Button
local Button = script.Parent
--Debouncer
local debounce = false

--CONFIGURE name of 'Water Fountains' model here
local waterFountainsName = 'Front Water Fountains'
--CONFIGURE error message here for disabling 'Enable Switch' configuration
local errMessage = "Ice must have froze the water fountain :("

--Model and its parts
local Button = script.Parent
local Slider = Button.Parent
local Model = Slider.Parent


--Fires when the player presses this button to turn on/off fountain lights
Button.ClickDetector.MouseClick:Connect(function(player)

	if debounce then return end
	debounce = true

	--Checks if player has permission to use outdoor accessories
	if not GameOwnerComms['Players Can Use Outdoor Accessories']:Invoke(player) then 
		debounce = false
		return 
	end
	
	--Checks if this power switch is enabled
	if not Model.Configuration['Enable Switch'].Value then
		ReplicatedStorage['Announce to Player']:FireClient(player, {text = errMessage, textColor = Color3.fromRGB(255, 255, 10)})
		ReplicatedStorage['Play Sound Effect']:FireClient(player, {name = 'Warning', volume = 1})
		debounce = false
		return
	end

	if Button.BrickColor == BrickColor.new('Really red') then --turn on
		FountainSwitcher:Fire(waterFountainsName, true)
		MovePowerButton:Invoke(Button, Button.Lever, BrickColor.new('Lime green'))
	else --turn off
		FountainSwitcher:Fire(waterFountainsName, false)
		MovePowerButton:Invoke(Button, Button.Lever, BrickColor.new('Really red'))
	end

	debounce = false
end)