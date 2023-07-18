--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Hangman Words
local HangmanWords = ReplicatedStorage:FindFirstChild('Hangman Words')
--Hangman UI
local HangmanUI = script.Parent
--Hangman menus
local MenuUI = HangmanUI.Menu
local GameUI = HangmanUI.Game
--Game UI
local UserWord = GameUI['User Word']
local CurrentLivesText = GameUI['Current Lives']
--Configuration
local Configuration = HangmanUI.Configuration
local AnswerWord = Configuration['Answer Word']
local MaxLives = Configuration['Max Lives']
local CurrentLives = Configuration['Current Lives']
--Other EVENTS/FUNCTIONS (not associated with Hangman)
local ReplaceChar = ReplicatedStorage:FindFirstChild('Replace Char From String')
--Client-to-Client Communications
local Client_Client = ReplicatedStorage:FindFirstChild('Client-Client Communications')



--[[This method performs the following while the game starts:
	• Randomly selects a word and sets it as the 'Answer Word'
	• Clears 'User Word'
	• Initializes 'User Word' by adding underscores
	• Shows all letter buttons
]]
ReplicatedStorage:FindFirstChild('Hangman - Start Game').OnClientEvent:Connect(function()
	
	--Set user's current lives to be same as max lives
	CurrentLives.Value = MaxLives.Value
	CurrentLivesText.Text = 'Lives: '..CurrentLives.Value

	--Randomly selects word as the 'Answer Word' 
	local HangmanWordsChildren = HangmanWords:GetChildren()
	AnswerWord.Value = HangmanWordsChildren[math.random(#HangmanWordsChildren)].Name
	
	print('Answer Word: ['..AnswerWord.Value..']')
	
	--Clears out 'User Word' for a new word
	UserWord.Text = ''

	--Loops all characters from 'Answer Word' to add underscores to the 'User Word'
	for i = 1, string.len(AnswerWord.Value), 1 do

		local char = string.sub(AnswerWord.Value,i,i)
		
		if char ~= ' ' then
			UserWord.Text = UserWord.Text..'_' --letter
		else
			UserWord.Text = UserWord.Text..' ' --space
		end
	end
	
	--print('User Word: ['..UserWord.Text..']')
	
	--Shows all letter buttons
	for _, letterButton in pairs(GameUI['Letter Buttons']:GetChildren()) do letterButton.Visible = true end
	
	print('Game has now started!')
	GameUI.Visible = true
end)



--[[This method performs the following while the game ends:
	• Reveals answer if the player lost all lives. Otherwise, tell the player that they won!
	• Shows 'Play Again' button
	
	This event DOES NOT get executed if the player decides to quit the game
]]
ReplicatedStorage:FindFirstChild('Hangman - End Game').OnClientEvent:Connect(function()
	
	--Reveals answer when the player lost
	if CurrentLives.Value == 0 then 
		UserWord.Text = AnswerWord.Value
		print('You lost...')
	else
		print('Congrats! You won!')
	end
	
	--Shows 'Play Again' button
	GameUI['Play Again'].Visible = true
	
	print('Game has now ended!')
end)


--[[Returns if any letters are found from the “Answer Word” 
	based on the user’s input. False, otherwise. 
	
	It also replaces underscores from 'User Word' with the
	user's letter if user input the correct letter

	Parameter(s):
	userLetter => letter the user selected (string)
	
	Return(s):
	boolean => {true: letter is found, false: letter is not found}
]]
ReplicatedStorage:FindFirstChild('Hangman - Letter Found').OnClientInvoke = function(userLetter)

	--Indicator for finding the user letter from 'Answer Word'
	local found = false

	--Loops through all letters from 'Answer Word'
	for i = 1, string.len(AnswerWord.Value), 1 do
		
		--Gets current letter from 'Answer Word' (can be lowercase or uppercase)
		local answerLetter = string.sub(AnswerWord.Value,i,i)
		
		--Replaces underscores with answer letter from 'User Word' (including uppercased letters)
		if userLetter == answerLetter or userLetter == string.lower(answerLetter) then
			UserWord.Text = ReplaceChar:InvokeServer(i, UserWord.Text, answerLetter)
			found = true
		end
	end

	return found
end