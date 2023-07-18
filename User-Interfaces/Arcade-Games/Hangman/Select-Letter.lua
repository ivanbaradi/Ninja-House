local ReplicatedStorage = game.ReplicatedStorage
local Client_Client = ReplicatedStorage:FindFirstChild('Client-Client Communications')
local Client_Client2 = ReplicatedStorage:FindFirstChild('Client-Client Communications 2')
local Button = script.Parent
local Buttons = Button.Parent
local GameUI = Buttons.Parent
local HangmanUI = GameUI.Parent

--Configuration
local Configuration = HangmanUI.Configuration
local CurrentLives = Configuration['Current Lives']
local AnswerWord = Configuration['Answer Word']
local Debounce = Configuration.Debounce

--GameUI components
local CurrentLivesText = GameUI['Current Lives']
local UserWord = GameUI['User Word']

--Colors for buttons
local default = Color3.fromRGB(66, 66, 66)
local hovered = Color3.fromRGB(0, 0, 0)



--Fires when user selects this letter
Button.MouseButton1Click:Connect(function()
	
	if Debounce.Value then return end
	
	Debounce.Value = true
	
	--Game ends when both texts are exactly the same
	if UserWord.Text == AnswerWord.Value then 
		Debounce.Value = false
		return 
	end
	
	--Checks if the user got this letter correct for the word
	local correct = Client_Client2:InvokeServer('Hangman - Letter Found', Button.Name)
	
	--Decreases lives for selecting the wrong letter
	if not correct then
		
		CurrentLivesText.TextColor3 = Color3.fromRGB(255, 38, 0)
		
		Client_Client:FireServer('Play Sound Effect', {
			name = 'Arcade Wrong Answer',
			volume = 4
		})
		
		CurrentLives.Value -= 1
		CurrentLivesText.Text = 'Lives: '..CurrentLives.Value
		
		wait(.1)
		CurrentLivesText.TextColor3 = Color3.fromRGB(0,0,0)
	end
	
	--Ends the game if the user ran out of lives or got all letters correct
	if CurrentLives.Value == 0 or UserWord.Text == AnswerWord.Value then
		Client_Client:FireServer('Hangman - End Game', nil)
	end
	
	--Becomes hidden after the user selects this letter
	Button.Visible = false
	
	Debounce.Value = false
end)



Button.MouseEnter:Connect(function()
	Button.TextButton_Roundify_6px.ImageColor3 = hovered
end)



Button.MouseLeave:Connect(function()
	Button.TextButton_Roundify_6px.ImageColor3 = default
end)