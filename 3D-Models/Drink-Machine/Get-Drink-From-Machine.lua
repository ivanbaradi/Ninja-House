--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--ServerStorage
local ServerStorage = game.ServerStorage
--Game Owner Settings (Communications)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Dispenser Glass
local DispenserGlass = script.Parent
--Drink Machine
local DrinkMachine = DispenserGlass.Parent
--Drink Machine (Communications)
local DrinkMachine_Comms = DrinkMachine:FindFirstChild('Communications')
--Drink Machine (Configurations)
local DrinkMachine_Config = DrinkMachine:FindFirstChild('Configuration')



--Fires whenever the player clicks this glass
DispenserGlass:FindFirstChild('ClickDetector').MouseClick:Connect(function(player)
	
	
	--Checks if other players have permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	--Checks if the dispenser glass is empty
	if DrinkMachine_Comms:FindFirstChild('Check if Dispenser Glass is Empty'):Invoke(player) then return end
	
	--Gets the current drink number from Drink Machine's Configurations
	local drinkNumber = DrinkMachine_Config:FindFirstChild('Drink Number').Value
	--Gets a drink from 'Drinks' Folder
	local Drink = DrinkMachine.Drinks:GetChildren()[drinkNumber]

	--Adds drink to the player's inventory (returns false if the player has that drink)
	local success = ServerStorage:FindFirstChild('Give Item to Player'):Invoke(player, Drink.Name, 'Items')
	if success then
		
		--Empties out the liquid from the Dispenser Glass
		DispenserGlass.Liquid.Transparency = 1
		--Fills in the liquid to the Sucker Glass
		DrinkMachine:FindFirstChild('Sucker Glass').Liquid.Transparency = 0
		
		--Changes 'Equip' button if the Inventory UI displays that dispensed drink
		if Drink.Name == ReplicatedStorage:FindFirstChild('Get Item Display Name'):InvokeClient(player) then
			ReplicatedStorage:FindFirstChild('Set Equip Button State'):FireClient(player, {
				text = 'Unequip', 
				background_color = Color3.fromRGB(252, 0, 6), 
				outline_color = Color3.fromRGB(161, 5, 5)
			})
		end
		
	else
		ReplicatedStorage:FindFirstChild('Announce to Player'):FireClient(player, {
			text = "You already have "..Drink.Name..' in your inventory',
			textColor = Color3.fromRGB(255, 255, 10)
		})
		
		--Plays 'Warning' Sound Effect
		ReplicatedStorage:FindFirstChild('Play Sound Effect'):FireClient(player, {
			name = 'Warning', 
			volume = 1
		})
	end
end)