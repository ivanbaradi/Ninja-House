--ServerStorage
local ReplicatedStorage = game.ReplicatedStorage
--Communications (Game Owner Setting)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Screen
local Screen = script.Parent
--ClickDetector
local ClickDetector = Screen.ClickDetector
--Ninja Trivia
local NinjaTrivia = Screen.Parent
--Communications (Ninja Trivia)
local Communications2 = NinjaTrivia:FindFirstChild('Communications')


--Starts the game when the player clicks the screen
ClickDetector.MouseClick:Connect(function(player)
	
	--Check if player has permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	--Screen is now unclickable
	ClickDetector.MaxActivationDistance = 0
	
	--Switches interface to 'Game UI' to display the game
	Communications2:FindFirstChild('Switch UI'):Fire('Start UI','Game UI')
	--Randomly selects a genre and any of its question
	Communications2:FindFirstChild('Random Question Generator'):Fire()
	--Displays a new question and choices on the screen
	Communications2:FindFirstChild('Display Question and Choices'):Fire()
end)
