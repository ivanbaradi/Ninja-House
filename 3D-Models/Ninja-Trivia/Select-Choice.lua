--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Choice Button
local Button = script.Parent
--Communications (Game Owner Settings)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Ninja Trivia
local NinjaTrivia = Button.Parent
--Communications (Ninja Trivia)
local Communications2 = NinjaTrivia:FindFirstChild('Communications')
--Configurations
local Configurations = NinjaTrivia.Configuration
local Debouncer = Configurations.Debouncer
local UserScore = Configurations["User Score"]
local CURR_QuestionsAsked = Configurations['Current Questions Asked']
local MAX_QuestionsAsked = Configurations['Max Questions Asked']
--Game UI
local GameUI = NinjaTrivia.Screen:FindFirstChild('Game UI') 
--Tells player at their side if the answer is correct or wrong
local MessagePlayer = ReplicatedStorage:FindFirstChild('Announce to Player')
--Plays sound effect at the player's side
local PlaySoundEffect = ReplicatedStorage:FindFirstChild('Play Sound Effect')


--Fires when the player presses this choice button
Button.ClickDetector.MouseClick:Connect(function(player)
	
	if Debouncer.Value then return end
	Debouncer.Value = true
	
	--Players don't have permission to use house accessories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then 
		Debouncer.Value = false
		return 
	end
	
	--Gets choice text from Screen based on user's choice
	local UserChoice = GameUI:FindFirstChild(Button.Name)
	--Partitions the user choice text to only get the choice description
	local userChoiceText = string.sub(UserChoice.Text, 4)
	
	--Either Increases user score for answering the question correctly OR highlights the wrong answer red if the user answers the question incorrectly

	if Communications2:FindFirstChild('Is Correct Answer'):Invoke(userChoiceText) then
		UserScore.Value += 1
		PlaySoundEffect:FireClient(player, {name = 'Trivia Answer (Correct)', volume = 1})
		MessagePlayer:FireClient(player, {text = 'Correct!', textColor = Color3.fromRGB(0, 143, 0)})
	else
		UserChoice.BackgroundColor3 = Color3.fromRGB(255, 38, 0)
		UserChoice.BackgroundTransparency = 0
		PlaySoundEffect:FireClient(player, {name = 'Trivia Answer (Wrong)', volume = 1})
		MessagePlayer:FireClient(player, {text = 'Wrong', textColor = Color3.fromRGB(255, 38, 0)})
	end
	
	--Reveals the correct answer to the user
	Communications2:FindFirstChild('Reveal Answer'):Invoke(player.Name)
	
	--Removes red highlight from wrong answer (Screen)
	UserChoice.BackgroundTransparency = 1
	
	--Hides all letter choices from the screen
	Communications2:FindFirstChild('Hide All Choices'):Fire()
	
	--Either ends the game or goes to the next question
	if CURR_QuestionsAsked.Value == MAX_QuestionsAsked.Value then
		--print('Game has ended')
		Communications2:FindFirstChild('End Game'):Invoke()
	else 
		Communications2:FindFirstChild('Random Question Generator'):Fire()
		Communications2:FindFirstChild('Display Question and Choices'):Fire()
	end
	
	Debouncer.Value = false
end)