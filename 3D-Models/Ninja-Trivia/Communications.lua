--ServerStorage
local ServerStorage = game.ServerStorage
--Ninja Trivia Game
local NinjaTrivia = script.Parent
--Communications
local Communications = NinjaTrivia:FindFirstChild('Communications')
--List of questions that are already asked
local visitedQuestions = {}
--Trivia Questions
local TriviaQuestions = ServerStorage:FindFirstChild('Trivia Questions')
--Gets all genres from 'Trivia Questions' folder
local TriviaGenres = TriviaQuestions:GetChildren()
--Screen
local Screen = NinjaTrivia:FindFirstChild('Screen')
local GameUI = Screen:FindFirstChild('Game UI')
local ScoreUI = Screen:FindFirstChild('Score UI')
--Configurations
local Configurations = NinjaTrivia:FindFirstChild('Configuration')
local Question = Configurations:FindFirstChild('Question')
local Genre = Configurations:FindFirstChild('Genre')
local CURR_Questions = Configurations:FindFirstChild('Current Questions Asked')
local MAX_Questions = Configurations:FindFirstChild('Max Questions Asked')
local UserScore = Configurations:FindFirstChild('User Score')
--Choice Letters
local letters = {'A','B','C','D'}

--BINDABLE FUNCTIONS
local QuestionAsked = Communications:FindFirstChild('Question Asked')
local GetRandGenre = Communications:FindFirstChild('Get Random Genre')
local GetRandQuestion = Communications:FindFirstChild('Get Random Question')
local IsCorrectAnswer = Communications:FindFirstChild('Is Correct Answer')
local RevealAnswer = Communications:FindFirstChild('Reveal Answer')
local EndGame = Communications:FindFirstChild('End Game')

--BINDABLE EVENTS
local SwitchUI = Communications:FindFirstChild('Switch UI')
local DisplayQuestionChoices = Communications:FindFirstChild('Display Question and Choices')
local HideAllChoices = Communications:FindFirstChild('Hide All Choices')
local RandQuestGeneration = Communications:FindFirstChild('Random Question Generator')



--[[Checks if the question is asked already
	
	Return(s):
	state = {true: question is already asked}
]]
QuestionAsked.OnInvoke = function()
	
	for i = 1, #visitedQuestions, 1 do
		if Question.Value == visitedQuestions[i] then
			return true
		end
	end
	
	return false
end



--[[Selects a random trivia genre name

	Return(s):
	SelectedGenre (string) => randomly selected trivia genre
]]
GetRandGenre.OnInvoke = function()
	local selectedGenre = TriviaQuestions:FindFirstChild(TriviaGenres[math.random(#TriviaGenres)].Name)
	return selectedGenre.Name
end



--[[Selects a random question from a trivia genre
	
	Return(s):
	SelectedQuestion (string) => randomly selected question
]]
GetRandQuestion.OnInvoke = function()
	local GenreQuestions = TriviaQuestions:FindFirstChild(Genre.Value):GetChildren()
	local selectedQuestion = GenreQuestions[math.random(#GenreQuestions)]
	return selectedQuestion.Name
end



--[[Switches the screen's user interface

	Parameter(s):
	oldUI (string) => name of the UI that will become invisible
	newUI (string) => name of the UI that will become visible
]]
SwitchUI.Event:Connect(function(oldUI, newUI)
	Screen:FindFirstChild(oldUI).Enabled = false
	Screen:FindFirstChild(newUI).Enabled = true
end)



--[[Checks if the answer from the question is correct

	Parameter(s):
	userChoice (string) => the choice the user selected as the answer
	
	Return(s):
	boolean = {true: the answer is correct, false: the answer is wrong}
]]
IsCorrectAnswer.OnInvoke = function(userChoice)
	
	--Gets genre
	local getGenre = TriviaQuestions:FindFirstChild(Genre.Value)
	--Gets question from the genre
	local getQuestion = getGenre:FindFirstChild(Question.Value)
	
	return getQuestion:FindFirstChild(userChoice).Value 
end



--[[This generator does the following:
	• Gets a random genre
	• Gets a random question
	• Adds a new question to 'visitedQuestions' array
]]
RandQuestGeneration.Event:Connect(function()
	
	--Gets a random question that hasn't been asked yet
	repeat
		Genre.Value = GetRandGenre:Invoke()
		Question.Value = GetRandQuestion:Invoke()
	until not QuestionAsked:Invoke()

	--print('Selected Genre = ['..Genre.Value..']')
	--print('Selected Question = ['..Question.Value..']')

	--Adds a new question to 'visitedQuestions' array
	table.insert(visitedQuestions, Question.Value)
	
	--DEBUGGER: PRINTS ALL VISITED QUESTIONS
	--print('Printing all visited questions')
	--for i = 1, #visitedQuestions, 1 do
	--	print('QUESTION '..i..': '..visitedQuestions[i])
	--end
	--print()
end)



--Displays new question and choices on the screen
DisplayQuestionChoices.Event:Connect(function()
	
	--Gets selected genre and question from Trivia Questions including its choices
	local getGenre = TriviaQuestions:FindFirstChild(Genre.Value)
	local getQuestion = getGenre:FindFirstChild(Question.Value)
	
	--Displays new question
	GameUI:FindFirstChild('Question').Text = Question.Value
	--Displays new genre
	GameUI:FindFirstChild('Current Genre').Text = 'Genre:  '..Genre.Value
	
	--Displays choices based on the amount of choices the question has and makes their buttons clickable
	for i, Choice in pairs(getQuestion:GetChildren()) do
		local letter = letters[i]
		local ChoiceText = GameUI:FindFirstChild(letter)
		ChoiceText.Text = letter..'. '..Choice.Name
		ChoiceText.Visible = true
		NinjaTrivia[letter].ClickDetector.MaxActivationDistance = 30
	end
	
	--Displays new number of questions asked so far
	CURR_Questions.Value += 1
	GameUI:FindFirstChild('Current Questions Asked Ratio').Text = 'Question '..CURR_Questions.Value..' of '..MAX_Questions.Value
end)



--Makes all letter buttons unclickable and hides all letter choices from the screen
HideAllChoices.Event:Connect(function()
	for i = 1, #letters, 1 do
		local letter = letters[i]
		NinjaTrivia[letter].ClickDetector.MaxActivationDistance = 0
		GameUI:FindFirstChild(letter).Visible = false
	end
end)



--[[Highlights the answer on the screen

	Parameter(s):
	playerName (string) => player's username (Player who answered this question)
]]
RevealAnswer.OnInvoke = function(playerName)
	
	--Gets current genre and its question from 'Trivia Questions' folder
	local GetGenre = TriviaQuestions:FindFirstChild(Genre.Value)
	local GetQuestion = GetGenre:FindFirstChild(Question.Value)
	
	--Gets the text about who answered this question
	local AnsweredBy = GameUI:FindFirstChild('Answered By')
	
	--Gets correct answer from Trivia Questions by looping all choices from current question
	local GetCorrectAnswer
	for _, Choice in pairs(GetQuestion:GetChildren()) do
		if Choice.Value then
			GetCorrectAnswer = Choice
			break
		end
	end
	
	--Reveals the player who answered this question
	AnsweredBy.Text = playerName..' answered this question'
	AnsweredBy.Visible = true
	
	--Loops through all choices from Game UI to find and highlights correct answer green
	for i = 1, #letters, 1 do
		local letter = letters[i]
		local ChoiceText = GameUI:FindFirstChild(letter)
		if GetCorrectAnswer.Name == string.sub(ChoiceText.Text, 4) then
			ChoiceText.BackgroundColor3 = Color3.fromRGB(0, 143, 0)
			ChoiceText.BackgroundTransparency = 0
			wait(8)
			ChoiceText.BackgroundTransparency = 1
			break
		end
	end
	
	--Hides the player who answered this question
	AnsweredBy.Visible = false
end


--[[After the game ends, this method performs the following:
	• Reveals the ratio of user score to max questions asked
	• Calculates the percentage of user score
	• Resets user score and questions asked
	• Empties the 'visitedQuestions array'
	• Returns to 'Start UI' screen
]]
EndGame.OnInvoke = function()
	
	local PerfectLabel = ScoreUI:FindFirstChild('Perfect Label')
	
	--Displays 'PERFECT!' text if users answered all questions correctly
	if UserScore.Value == MAX_Questions.Value then PerfectLabel.Visible = true end
	
	--Calculates user score to max questions asked
	local percentage = math.floor((UserScore.Value / MAX_Questions.Value) * 100)
	ScoreUI:FindFirstChild('Score Text').Text = UserScore.Value..'/'..MAX_Questions.Value..' ('..percentage..'%)'
	
	--Reveals that score to the 'Score UI' screen 
	SwitchUI:Fire('Game UI','Score UI')
	wait(10)
	
	--Hides 'PERFECT!' text
	PerfectLabel.Visible = false
	
	--Resets user score, current questions asked, and visitedQuestions array
	UserScore.Value = 0
	CURR_Questions.Value = 0
	visitedQuestions = {}
	
	--Goes back to the 'Start UI' screen for players to play again
	SwitchUI:Fire('Score UI', 'Start UI')
	Screen.ClickDetector.MaxActivationDistance = 30
end