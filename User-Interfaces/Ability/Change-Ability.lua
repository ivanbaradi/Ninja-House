-- Roblox Services
ReplicatedStorage = game.ReplicatedStorage
MarketplaceService = game:GetService('MarketplaceService')
UserServiceInput = game:GetService('UserInputService')

-- Remote Events & Functions
Client_Client = ReplicatedStorage:FindFirstChild('Client-Client Communications')
AddPowerEffects = ReplicatedStorage:FindFirstChild('Add Ninja Super Power Effects')
RemovePowerEffects = ReplicatedStorage:FindFirstChild('Remove Ninja Super Power Effects')
ImportantPerson = ReplicatedStorage:FindFirstChild('Player Is Important Person'):InvokeServer()

-- Button
Button = script.Parent
ButtonBackground = Button:FindFirstChild('Background')

-- Player
player = game.Players.LocalPlayer

-- Colors for the button
defaultGreen = Color3.fromRGB(89, 198, 8)
hoveredGreen = Color3.fromRGB(73, 157, 9)

-- Colors for the button icon
whiteColor = Color3.fromRGB(255, 255, 255)
yellowColor = Color3.fromRGB(255, 255, 10)
redColor = Color3.fromRGB(255, 38, 0)

-- List of speed walks
abilities = {
	{
		Name = 'Slow Walk',
		AssetId = 'rbxassetid://9525534183',
		WalkSpeed = 10,
		JumpPower = 50,
		ImageColor = whiteColor
	},
	{
		Name = 'Walk',
		AssetId = 'rbxassetid://9525534183',
		WalkSpeed = 16,
		JumpPower = 50,
		ImageColor = yellowColor
	},
	{
		Name = 'Run',
		AssetId = 'rbxassetid://9525535512',
		WalkSpeed = 40,
		JumpPower = 50,
		ImageColor = yellowColor
	},
	{
		Name = 'Ninja', -- gamepass required
		AssetId = 'rbxassetid://9525535512',
		WalkSpeed = 100,
		JumpPower = 150,
		ImageColor = redColor
	}
}

-- Index of current ability 
i = 2
-- Total abilities 
n = rawlen(abilities)
-- Highest level of abilities (the last walkspeed object requires player to own gamepass)
GamePassOwned = MarketplaceService:UserOwnsGamePassAsync(player.UserId, 87789481)
highest = (ImportantPerson or GamePassOwned) and n or n-1


--[[Handles player's walkspeed, jump power, and other assets

	Parameter(s):
		ability: dictionary about the ability
]]
function handleChange(ability: {Name: string, WalkSpeed: number, JumpPower: number, AssetId: string, ImageColor: Color3})

	local Humanoid = player.Character:WaitForChild('Humanoid')
	Humanoid.WalkSpeed = ability.WalkSpeed
	Humanoid.JumpPower = ability.JumpPower
	Button.Image = ability.AssetId
	Button.ImageColor3 = ability.ImageColor
	
	-- Add ninja power effects whenplayer is on Ninja mode
	if ability.Name == 'Ninja' then 
		AddPowerEffects:FireServer() 
	else
		RemovePowerEffects:FireServer()
	end
end



--Changes walkspeed of the player when they press the button
function changeAbility()
	
	--Tells server to have another client play 'Button Clicked' sound effect
	Client_Client:FireServer('Play Sound Effect', {name = 'Button Clicked', volume = 1})

	if i < highest then
		i += 1
	else
		i = 1
	end
	
	handleChange(abilities[i])
end

--Fires when the player presses the 'Sprint' button to change player's speedwalk
Button.MouseButton1Click:Connect(changeAbility)

--[[Fires when the player presses the following inputs to change player's walkspeed:
	• Computer: 'R' key
	• Xbox: LT
]]
UserServiceInput.InputBegan:Connect(function(input: InputObject, GPE: boolean)
	if not GPE then
		if input.KeyCode == Enum.KeyCode.R or input.KeyCode == Enum.KeyCode.ButtonL2 then changeAbility() end
	end
end)



--Will need to restore player's abilities and special effects whenever they respawn
player.CharacterAdded:Connect(function()
	handleChange(abilities[i])
end)

--Darkens the button's background color when the mouse hovers the button
Button.MouseEnter:Connect(function()
	ButtonBackground.ImageColor3 = hoveredGreen
end)


--Restores the button's background color when the mouse exits the button
Button.MouseLeave:Connect(function()
	ButtonBackground.ImageColor3 = defaultGreen
end)