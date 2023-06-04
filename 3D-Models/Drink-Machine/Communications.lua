--[[THIS SCRIPT HANDLES APIS REQUESTED BY MULTIPLE SCRIPTS FROM THE DRINK MACHINE]]

------------------------------------[[ REPLICATEDSTORAGE ]]------------------------------------

--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--'Announce to Player' Event
local announceToPlayer = ReplicatedStorage:FindFirstChild('Announce to Player')
--'Play Sound Effect' Event
local playSoundEffect = ReplicatedStorage:FindFirstChild('Play Sound Effect')
--Yellow Color (Warning Text to Player)
local yellowColor = Color3.fromRGB(255, 255, 10)

------------------------------------[[ DRINK MACHINE ]]------------------------------------

--Drink Machine
local DrinkMachine = script.Parent
--Collection of drinks {Name: name of the drink, Value: BrickColor of the drink}
local Drinks = DrinkMachine:FindFirstChild('Drinks'):GetChildren()
--Communications
local Communications = DrinkMachine:FindFirstChild('Communications')
--Configurations
local Configurations = DrinkMachine:FindFirstChild('Configuration')
--UI from the Drink Machine
local UI = DrinkMachine:FindFirstChild('Screen'):FindFirstChild('SurfaceGui')
--Menu from the UI
local Menu = UI:FindFirstChild('Menu')
--Dispenser Glass and Sucker Glass
local DispenserGlass, SuckerGlass = DrinkMachine:FindFirstChild('Dispenser Glass'), DrinkMachine:FindFirstChild('Sucker Glass')
--Drainers from the Drink Machine
local Drainer1, Drainer2 = DrinkMachine.Dispenser["Drainer 1"], DrinkMachine.Dispenser["Drainer 2"]


------------------------------------------[[ VALIDATIONS ]]------------------------------------------

--[[Checks if the drink is pouring

	Returns true if:
	- The player pressed the 'Start' button while the drink is being poured to
	- The player pressed the 'Left' button while the drink is being poured to
	- The player pressed the 'Right' button while the drink is being poured to

	Parameter(s):
	player => player object (Player)

	Return(s):
	boolean => {true: drink is pouring, false: drink is not pouring}
]]
Communications:FindFirstChild('Check If Drink is Pouring').OnInvoke = function(player)
	
	if Configurations:FindFirstChild('Drink Is Pouring').Value then 
		
		--Let players know that the drink is pouring
		announceToPlayer:FireClient(player, {
			text = 'Please wait until the machine is done processing',
			textColor = yellowColor
		})

		--Plays 'Warning' Sound Effect
		playSoundEffect:FireClient(player, {
			name = 'Warning', 
			volume = 1
		})
		
		
		return true 
	end
	
	return false
end



--[[Checks if the dispenser glass is empty

	Returns true if:
	- The player pressed the 'Dispenser Glass' when there is no liquid in it

	Parameter(s):
	player => player object (Player)

	Return(s):
	boolean => {true: dispenser glass is empty, false: dispenser glass is full}
]]
Communications:FindFirstChild('Check if Dispenser Glass is Empty').OnInvoke = function(player)
	
	if DrinkMachine:FindFirstChild('Dispenser Glass').Liquid.Transparency == 1 then
		
		--Lets player know that the dipenser glass isn't full yet
		announceToPlayer:FireClient(player, {
			text = "The glass must be full to be served",
			textColor = yellowColor
		})
		
		--Plays 'Warning' Sound Effect
		playSoundEffect:FireClient(player, {
			name = 'Warning', 
			volume = 1
		})
		
		return true
	end
	
	return false
end



--[[Checks if the dispenser glass is full

	Returns true if:
	- The player pressed the 'Start' button when there is liquid in the dispenser glass
	- The player pressed the 'Left' button when there is liquid in the dispenser glass
	- The player pressed the 'Right' button when there is liquid in the dispenser glass
	
	Parameter(s):
	player => player object (Player)

	Return(s):
	boolean => {true: dispenser glass is full, false: dispenser glass is empty}
]]
Communications:FindFirstChild('Check if Dispenser Glass is Full').OnInvoke = function(player)
	
	if DrinkMachine:FindFirstChild('Dispenser Glass').Liquid.Transparency == 0 then

		--Lets player know that there is nothing in the dispenser glass
		announceToPlayer:FireClient(player, {
			text = "Get your drink first before you can use this machine",
			textColor = yellowColor
		})

		--Plays 'Warning' Sound Effect
		playSoundEffect:FireClient(player, {
			name = 'Warning', 
			volume = 1
		})

		return true
	end

	return false
end

------------------------------------------[[ OTHER APIS ]]------------------------------------------

--[[Changes the drink

	Happens if:
	- The player pressed the 'Left' arrow to go to the previous drink
	- The player pressed the 'Right' arrow to go to the next drink
	
	Parameter(s):
	drink number => index of the drink from 'Drinks' Folder (int)
]]
Communications:FindFirstChild('Change Drink').Event:Connect(function (drinkNumber)
	
	--Updates 'Drink Number' from Configurations
	Configurations:FindFirstChild('Drink Number').Value = drinkNumber

	--Indexes a drink from 'Drinks' folder with the drink number
	local Drink = Drinks[drinkNumber]

	--Changes display of the drink from the UI
	Menu['Drink Name'].Text = Drink.Name
	Menu['Drink Image'].Image = ReplicatedStorage.Items:FindFirstChild(Drink.Name).TextureId
	
	--Changes liquid colors from objects with liquids
	Drainer1.Liquid.BrickColor = BrickColor.new(Drink.Value)
	Drainer2.Liquid.BrickColor = BrickColor.new(Drink.Value)
	DispenserGlass.Liquid.BrickColor = BrickColor.new(Drink.Value)
	SuckerGlass.Liquid.BrickColor = BrickColor.new(Drink.Value)
	DispenserGlass['Liquid (Half)'].BrickColor = BrickColor.new(Drink.Value)
	SuckerGlass['Liquid (Half)'].BrickColor = BrickColor.new(Drink.Value)
end)


