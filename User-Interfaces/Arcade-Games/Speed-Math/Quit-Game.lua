--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--UserInputService
local UserInputService = game:GetService('UserInputService')
--Client-to-Client Communications
local Client_Client = ReplicatedStorage:FindFirstChild('Client-Client Communications')
--Answer Button
local Button = script.Parent
--Game UI
local GameUI = Button.Parent
local UserAnswer = GameUI['User Answer']
--Speed Math Game
local SpeedMathUI = GameUI.Parent
--Quit Game UI
local QuitGameUI = SpeedMathUI['Quit Game?']
--Button colors
local default = Color3.fromRGB(94, 94, 94)
local hovered = Color3.fromRGB(1, 25, 147)
--Client-to-Client Communications
local Client_Client = ReplicatedStorage:FindFirstChild('Client-Client Communications')



--Directs player to Leave Game UI
function handler()
	Button.BackgroundColor3 = default

	Client_Client:FireServer('Play Sound Effect', {
		name = 'Button Clicked 2',
		volume = 1
	})

	GameUI.Visible = false
	QuitGameUI.Visible = true
end



--Fires when the player pressed the 'Q' button from the Game UI
Button.MouseButton1Click:Connect(handler)
--Fires when the player pressed the 'Q' key button
UserInputService.InputBegan:Connect(function(input)
	if GameUI.Visible and input.KeyCode == Enum.KeyCode.Q then handler() end
end)



--Changes button color to blue when the mouse hovers the button
Button.MouseEnter:Connect(function()
	Button.BackgroundColor3 = hovered
end)



--Changes button color back to default when the mouse exits the button
Button.MouseLeave:Connect(function()
	Button.BackgroundColor3 = default
end)
