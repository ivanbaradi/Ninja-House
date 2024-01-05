--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Game Owner (Communications)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Start Button
local Button = script.Parent
--ClickDetector
local ClickDetector = Button.ClickDetector
--Drink Machine
local DrinkMachine = Button.Parent
--Drink Machine (Communications)
local DrinkMachine_Comm = DrinkMachine:FindFirstChild('Communications')
--Drink Machine (Configurations)
local DrinkMachine_Configs = DrinkMachine:FindFirstChild('Configuration')


--[[Changes the Frame from the 'Screen' of the Drink Machine

	Parameter(s):
	old UI => UI that will disappear (Frame)
	new UI => UI that will appear (Frame)
]]
function changeUIFrame(oldUI, newUI)
	oldUI.Visible = false
	newUI.Visible = true
end



--Pours the drink
function pourDrink()

	--Duration of pouring glass to the dispenser in seconds
	local duration = DrinkMachine_Configs:FindFirstChild('Duration (secs)')
	--Half of the duration
	local half_duration = math.floor(duration.Value/2)
	--Current state of the pouring drink
	local drinkIsPouring = DrinkMachine_Configs:FindFirstChild('Drink Is Pouring')
	--Current second of pouring the glass to the dispenser
	local currentSecond = 0
	--UI from the Screen
	local Screen = DrinkMachine.Screen.SurfaceGui
	--Frames from the UI
	local Menu, Message = Screen.Menu, Screen.Message
	--Drainers from the Drink Machine
	local Drainer1, Drainer2 = DrinkMachine.Dispenser["Drainer 1"], DrinkMachine.Dispenser['Drainer 2']
	--Dispenser Glass and Sucker Glass from the Drink Machine
	local DispenserGlass, SuckerGlass = DrinkMachine['Dispenser Glass'], DrinkMachine['Sucker Glass']
	--Draining sound effect
	local Draining = Drainer1.Drain.Draining

	--Drink will start pouring
	drinkIsPouring.Value = true

	--Changes frame to 'Message' and sets text message
	changeUIFrame(Menu, Message)
	Message.TextLabel.Text = 'Please wait while we are preparing your drink'

	wait(5)
	
	--Drainer begins to drain drink
	Message.TextLabel.Text = 'Now pouring your drink'
	Draining:Play()
	Drainer1.Liquid.Transparency = 0
	Drainer2.Liquid.Transparency = 0

	--Loops until duration expires
	while currentSecond < duration.Value do
		
		wait(1)
		currentSecond += 1
		
		--Dispenser and Sucker glasses have liquids that are halfway to the top since pouring is 50% completed
		if currentSecond == half_duration then
			
			--Empties liquids from the Sucker Glass by "half"
			SuckerGlass.Liquid.Transparency = 1
			
			DispenserGlass['Liquid (Half)'].Transparency = 0
			SuckerGlass['Liquid (Half)'].Transparency = 0
		end
		
		--print('Drainage time: '..currentSecond..' secs')
	end

	--Drainer stops
	Draining:Stop()
	Drainer1.Liquid.Transparency = 1
	Drainer2.Liquid.Transparency = 1
	
	--Transparencies of 'Liquid (Half)' are 1 since both glasses are no longer filled halfway
	DispenserGlass['Liquid (Half)'].Transparency = 1
	SuckerGlass['Liquid (Half)'].Transparency = 1

	--Fills liquids to the Dispenser Glass
	DispenserGlass.Liquid.Transparency = 0


	Message.TextLabel.Text = 'Enjoy your drink!'
	wait(10)
	
	--Changes frame to 'Menu'
	changeUIFrame(Message, Menu)

	--Drink stops pouring
	drinkIsPouring.Value = false
end


--Fires whenever the player clicks this button to start pouring the drink
ClickDetector.MouseClick:Connect(function(player)
	
	--Checks whether players have permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	--Checks if the drink is still pouring
	if DrinkMachine_Comm:FindFirstChild('Check If Drink is Pouring'):Invoke(player) then return end
	--Checks if the Dispenser Glass is full
	if DrinkMachine_Comm:FindFirstChild('Check if Dispenser Glass is Full'):Invoke(player) then return end
	
	--Button changes to red indicating that it may not be used
	Button.Color = Color3.fromRGB(255, 0, 0)
	--Drink starts pouring!
	pourDrink()
	--Button changes to green indicating that it can be used now
	Button.Color = Color3.fromRGB(0, 255, 0)
end)