local Players = game:GetService('Players')
local SpeedButtons = script.Parent
local Communications = SpeedButtons.Communications
local StartButton = SpeedButtons:FindFirstChild('Start Button')

--Configuration
local Configuration = SpeedButtons.Configuration
local MaxTime = Configuration['Max Time']
local Points = Configuration.Points
local PointsGained = Configuration['Points Gained']
local Presses = Configuration.Presses
local Presses_RED = Configuration['Presses to Add Red Button']
local PlayerUserId = Configuration['Player UserId']
local GameplayRunning = Configuration['Gameplay Running']
local PlayerPressedRed = Configuration['Player Pressed Red Button']

--Screen
local Screen = SpeedButtons.Screen
local StartGameUI = Screen['Start Game UI']
local ScoreUI = Screen['Score UI']

--ScoreUI comps
local GameOver = ScoreUI['Game Over']
local RedPressed = ScoreUI['Red Pressed!']

--BrickColors
local Black = BrickColor.new('Black')
local ReallyRed = BrickColor.new('Really red')
local LimeGreen = BrickColor.new('Lime green')



--Runs timer of the game
Communications['Run Timer'].Event:Connect(function()
	
	local currentTime = MaxTime.Value
	ScoreUI.Time.Text = 'TIME: '..MaxTime.Value..'s'
	
	while currentTime > 0 and GameplayRunning.Value do
		wait(1)
		currentTime -= 1
		ScoreUI.Time.Text = 'TIME: '..currentTime..'s'
	end
	
	GameplayRunning.Value = false
	print('Game has ended!')
	
	setMaxActivationDistances(0)
	
	--Only when the game ends due to expired time or player leaving the server
	if not PlayerPressedRed.Value then colorAllButtons(Black) end
	
	GameOver.Visible = true
	
	--Gives user time to view the score
	wait(12)
	
	--Returns to 'Start Game' UI
	ScoreUI.Enabled = false
	StartGameUI.Enabled = true
	
	--Hides all red text
	GameOver.Visible = false
	RedPressed.Visible = false
	
	--Resets stats
	Presses.Value = 0
	ScoreUI.Presses.Text = 'PRESSES: 0'
	PlayerUserId.Value = -1
	Points.Value = 0
	ScoreUI.Score.Text = 'SCORE: 0'
	PlayerPressedRed.Value = false
	print('All stats have been resetted!')
	
	--Start Button is now enabled
	StartButton.BrickColor = LimeGreen
	StartButton.ClickDetector.MaxActivationDistance = 30
end)


--This game ends if the player left the server
Players.PlayerRemoving:Connect(function(player)
	if player.UserId == PlayerUserId.Value then GameplayRunning.Value = false end
end)



--Randomly selects numbered buttons to color them green or red
function colorButtons()
	
	--Randomnly selects a numbered button to color it green
	local rand_num = math.random(9)
	--rand_num = 1 -- TEST
	SpeedButtons:FindFirstChild(tostring(rand_num)).BrickColor = LimeGreen

	--Randomnly selects a numbered button to color it red
	if Presses.Value >= Presses_RED.Value then
		local rand_num2
		repeat rand_num2 = math.random(9) until rand_num ~= rand_num2
		--rand_num2 = 2 --TEST
		SpeedButtons:FindFirstChild(tostring(rand_num2)).BrickColor = ReallyRed
	end

	--print('Buttons selection completed!')
end

--Usually fires when the player starts this game
Communications['Color Buttons'].Event:Connect(colorButtons)



--[[Colors all game buttons 1 to 9
	
	Parameter(s):
	brickColor => Brick Color object with its brick color (BrickColor)
]]
function colorAllButtons(brickColor)
	for i = 1, 9, 1 do
		SpeedButtons:FindFirstChild(tostring(i)).BrickColor = brickColor
	end
end



--[[Sets MaxActivationDistance on all buttons

	Parameter(s):
	val => number to set 'MaxActivationDistance' to all numbered buttons (float)
]]
function setMaxActivationDistances(val)
	for i = 1, 9, 1 do
		SpeedButtons:FindFirstChild(tostring(i)).ClickDetector.MaxActivationDistance = val
	end
end

--Usually fired when the player starts the game to click any of the 9 buttons
Communications['Set Max Activation Distances'].Event:Connect(setMaxActivationDistances)



--[[This event performs the following if the player pressed the game green button:
	• Increases player's score
	• Clear all buttons' colors to black
	• Colors buttons (one green and one red) out of all 9 buttons 
]]
Communications['Green Button Pressed'].Event:Connect(function()
	--print('Green button pressed!')
	Points.Value += PointsGained.Value
	ScoreUI.Score.Text = 'SCORE: '..Points.Value
	Presses.Value += 1
	ScoreUI.Presses.Text = 'PRESSES: '..Presses.Value
	colorAllButtons(Black)
	colorButtons()
end)



--[[This event performs the following if the player pressed the game red button:
	• Plays 'Red Pressed' sound effect 
	• Clear all buttons' colors to black
	• Deducts all points from player's score and all press counts
	• Shows 'GAME OVER' and 'RED PRESSED' text
	• Flickers all 9 game buttons
]]
Communications['Red Button Pressed'].Event:Connect(function()
	
	--print('Red button pressed!')
	PlayerPressedRed.Value = true
	Screen['Red Pressed Sound']:Play()
	GameplayRunning.Value = false
	GameOver.Visible = true
	RedPressed.Visible = true
	
	Points.Value = 0
	ScoreUI.Score.Text = 'SCORE: 0'
	Presses.Value = 0
	ScoreUI.Presses.Text = 'PRESSES: 0'
	
	setMaxActivationDistances(0)

	--Flickers 'Red Pressed' text
	for i=1,10,1 do
		colorAllButtons(ReallyRed)
		wait(.2)
		colorAllButtons(Black)
		wait(.2)
	end
end)