--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--User Input Service
local UserInputService = game:GetService('UserInputService')
--Answer Button
local Button = script.Parent
--Game UI
local GameUI = Button.Parent
local UserAnswer = GameUI['User Answer']
local UserScoreLabel = GameUI['Score']
--Speed Math Game
local SpeedMathUI = GameUI.Parent
--Configurations
local Configuration = SpeedMathUI.Configuration
local MathAnswer = Configuration['Math Answer']
local UserScore = Configuration['User Score']
local PointsAdded = Configuration['Points Added']
local PointsDeducted = Configuration['Points Deducted']
local CorrectAnswers = Configuration['Correct Answers']
local WrongAnswers = Configuration['Wrong Answers']
--Button colors
local default = Color3.fromRGB(94, 94, 94)
local hovered = Color3.fromRGB(1, 25, 147)
--Client-to-Client Communications
local Client_Client = ReplicatedStorage:FindFirstChild('Client-Client Communications')
--Add Commas to Number (Remote Function)
local AddCommasToNumber = ReplicatedStorage:FindFirstChild('Add Commas to Number')


--Answers the math equation 
function handler()
	
	--Removes all spaces from 'User Answer' text
	UserAnswer.Text = UserAnswer.Text:gsub("%s+", "")

	--Player did not enter an answer at the gray textbox
	if UserAnswer.Text == '' then

		Client_Client:FireServer('Play Sound Effect', {
			name = 'Warning',
			volume = 1
		})

		Client_Client:FireServer('Announce to Player', {
			text = 'Please input your answer at the gray box',
			textColor = Color3.fromRGB(255, 251, 0)
		})

		return
	end

	--Converts the user's answer from string to number
	local userAnswerInt = tonumber(UserAnswer.Text)

	--Adds points to player's score
	if userAnswerInt == MathAnswer.Value then
		UserScore.Value += PointsAdded.Value
		CorrectAnswers.Value += 1
		UserScoreLabel.Text = 'Points: '..AddCommasToNumber:InvokeServer(UserScore.Value)
	else  --Deducts points from player's score
		
		--Changes player's score label red
		UserScoreLabel.TextColor3 = Color3.fromRGB(255, 38, 0)
		
		--Plays 'Arcade Wrong Answer' sound effect for getting the math equation wrong
		Client_Client:FireServer('Play Sound Effect', {
			name = 'Arcade Wrong Answer',
			volume = 4
		})

		UserScore.Value -= PointsDeducted.Value
		WrongAnswers.Value += 1
		UserScoreLabel.Text = 'Points: '..AddCommasToNumber:InvokeServer(UserScore.Value)

		wait(.1)
		UserScoreLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	end

	--Generates another math equation
	Client_Client:FireServer('Speed Math - Generate Math Equation', nil)

	--Clears "User Answer" textbox
	UserAnswer.Text = ''
end


--Triggers when the player pressed the 'Answer' button to compute math equation
Button.MouseButton1Click:Connect(handler)
--Triggers when the player pressed the 'Return' key button to compute math equation
UserInputService.InputBegan:Connect(function(input)
	if GameUI.Visible and input.KeyCode == Enum.KeyCode.Return then handler() end
end)



--Changes button color to blue when the mouse hovers the button
Button.MouseEnter:Connect(function()
	Button.BackgroundColor3 = hovered
end)



--Changes button color back to default when the mouse exits the button
Button.MouseLeave:Connect(function()
	Button.BackgroundColor3 = default
end)
