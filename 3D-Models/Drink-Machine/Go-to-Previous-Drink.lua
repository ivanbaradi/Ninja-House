--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Game Owner Settings (Communications)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Right Button
local Button = script.Parent
--Drink Machine
local DrinkMachine = Button.Parent
--Drink Machine (Configurations)
local DrinkMachine_Configs = DrinkMachine:FindFirstChild('Configuration')
--Drink Machine (Communications)
local DrinkMachine_Comm = DrinkMachine:FindFirstChild('Communications')
--Drink Number (References folder from 'Drinks Folder')
local DrinkNumber = DrinkMachine_Configs:FindFirstChild('Drink Number')
--Drinks Folder
local DrinksFolder = DrinkMachine:FindFirstChild('Drinks')
--Menu from the UI of the Drink Machine
local Menu = DrinkMachine.Screen.SurfaceGui.Menu


--Fires when the player presses this button to go to the next drink 
Button.ClickDetector.MouseClick:Connect(function(player)

	--Checks if other players have permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	--Checks if the drink is still pouring
	if DrinkMachine_Comm:FindFirstChild('Check If Drink is Pouring'):Invoke(player) then return end
	--Checks if the dispenser glass is still full
	if DrinkMachine_Comm:FindFirstChild('Check if Dispenser Glass is Full'):Invoke(player) then return end

	--Goes to the previous drink; Otherwise go to the last drink
	if DrinkNumber.Value > 1 then 
		DrinkNumber.Value -= 1 
	else
		DrinkNumber.Value = #DrinksFolder:GetChildren()
	end

	--Requests another script to change the drink based on the drink number
	DrinkMachine_Comm:FindFirstChild('Change Drink'):Fire(DrinkNumber.Value)
end)