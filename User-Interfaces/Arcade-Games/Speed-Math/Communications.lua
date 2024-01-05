--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage

--Speed Math UIs
local SpeedMathUI = script.Parent
local Menu = SpeedMathUI.Menu
local _Game = SpeedMathUI.Game
local Results = SpeedMathUI.Results
local QuitGame = SpeedMathUI['Quit Game?']
local Instructions = SpeedMathUI.Instructions

--Game UI components
local TimerUI = _Game.Timer
local MathEquationUI = _Game['Math Equation']
local ScoreLabelUI = _Game['Score']
local UserAnswerUI = _Game['User Answer']


--Client-to-Client Communications
local CLIENT_CLIENT = ReplicatedStorage:FindFirstChild('Client-Client Communications')

--Configurations
local Configuration = SpeedMathUI.Configuration
local MaxTime = Configuration['Max Time']
local UserScore = Configuration['User Score']
local CorrectAnswers = Configuration['Correct Answers']
local WrongAnswers = Configuration['Wrong Answers']
local PointsAdded = Configuration['Points Added']
local PointsDeducted = Configuration['Points Deducted']
local MathAnswer = Configuration['Math Answer']
local MinOperand = Configuration['Min Operand']
local MaxOperand = Configuration['Max Operand']
local GameplayRunning = Configuration['Gameplay Running']
local totalPages = Configuration['Total Instruction Pages']
local currentPage = Configuration['Current Instruction Page']

--Speed Math EVENTS
local ResetStats = ReplicatedStorage:FindFirstChild('Speed Math - Reset Stats')
local GenerateMathEquation = ReplicatedStorage:FindFirstChild('Speed Math - Generate Math Equation')
local RunTimer = ReplicatedStorage:FindFirstChild('Speed Math - Run Timer')
local StartGame = ReplicatedStorage:FindFirstChild('Speed Math - Start Game')

--Other EVENTS
local AddCommasToNumber = ReplicatedStorage:FindFirstChild('Add Commas to Number')

--Math operators
local operators = {'+','-','x', '÷'}



--Initializes total number of 'Instruction' pages
function initInstructionPages()
	
	for _, comp in pairs(Instructions:GetChildren()) do
		if string.sub(comp.Name, 1, 4) == 'Page' then
			totalPages.Value += 1
		end
	end
	
	--print('Total instruction pages: '..totalPages.Value)
end



--Resets time, user score, and amount of correct and wrong answers
function resetStats()
	UserScore.Value = 0
	CorrectAnswers.Value = 0
	WrongAnswers.Value = 0
	--print("Timer, user score, correct answers, and wrong answers have been resetted")
end

--Occurs when the player decides to press the 'Quit' button to reset stats
ResetStats.OnClientEvent:Connect(resetStats)



--[[Generates a math equation

	This method performs the following:
	• Randomly selects a math operator
	• Randomly selects math operands
	• Generates a math answer by computing the math equation
	• Displays the math equation at the Game UI
]]
function generateMathEquation()
	
	--Selects random operator
	local operator = operators[math.random(#operators)]
	--Selects random operands
	local op, op2
	
	--For subtraction, 1st operand must be greater or equal to 2nd op
	if operator == '-' then
		
		repeat
			op = math.random(MinOperand.Value, MaxOperand.Value)
			op2 = math.random(MinOperand.Value, MaxOperand.Value)
		until op >= op2
		
		MathAnswer.Value = op - op2
		
	--For division, math answer MUST be a whole number
	elseif operator == '÷' then
		
		repeat
			op = math.random(MinOperand.Value, MaxOperand.Value)
			op2 = math.random(1, MaxOperand.Value)
		until op % op2 == 0 
		
		MathAnswer.Value = op / op2
		
	--For Addition or multiplication
	else
		
		op = math.random(MinOperand.Value, MaxOperand.Value)
		op2 = math.random(MinOperand.Value, MaxOperand.Value)
		
		if operator == '+' then
			MathAnswer.Value = op + op2
		else
			MathAnswer.Value = op * op2
		end
	end
	
	--Displays the math equation at Game UI
	MathEquationUI.Text = tostring(op)..' '..operator..' '..tostring(op2)
end

--Occurs when the player answered the math equation and goes to the next one
GenerateMathEquation.OnClientEvent:Connect(generateMathEquation)



--Runs the timer of the speed math game until it expires
RunTimer.OnClientEvent:Connect(function()
	
	--Sets current time and initially displays it at the Game UI
	local currentTime = MaxTime.Value
	
	--Updates current time and then diplays it
	repeat
		
		--Occurs when the player pressed 'No' button to quit the game
		if not GameplayRunning.Value then return end
		
		TimerUI.Text = 'Time: '..currentTime..'s'	
		wait(1)
		currentTime -= 1
		
	until currentTime == -1
	
	--In case that the player is still in the 'Quit Game' UI
	QuitGame.Visible = false
	
	--Directs player to 'Results' UI 
	if GameplayRunning.Value and currentTime == -1 then
		print('Timer has expired!')
		GameplayRunning.Value = false
		_Game.Visible = false
		showResults()
	end
end)



--[[This event performs the following while the game is starting:
	• Directs player to the Game UI
	• Starts Timer
	• Generates math equation
]]
StartGame.OnClientEvent:Connect(function()
	_Game.Visible = true
	GameplayRunning.Value = true
	CLIENT_CLIENT:FireServer('Speed Math - Run Timer', nil)
	generateMathEquation()
end)



--Shows game results after the game ends due to expired time
function showResults()
	
	--Total number of math equations generated and answered so far from the gameplay
	local totalEquations = CorrectAnswers.Value + WrongAnswers.Value
	
	--Colors for text
	local black = Color3.fromRGB(0, 0, 0)
	local red = Color3.fromRGB(255, 38, 0)
	
	--Displays 'Points Deducted' and 'Wrong Answers' text differently
	if WrongAnswers.Value > 0 then
		Results['Points Deducted'].Text = AddCommasToNumber:InvokeServer(-1 * PointsDeducted.Value * WrongAnswers.Value)..'pts'
		Results['Points Deducted'].TextColor3 = red
		Results['Wrong Answers'].TextColor3 = red
	else
		Results['Points Deducted'].Text = '0pts'
		Results['Points Deducted'].TextColor3 = black
		Results['Wrong Answers'].TextColor3 = black
	end
		
	--Displays the rest of the gameplay
	Results['Total Points'].Text = AddCommasToNumber:InvokeServer(UserScore.Value)..'pts'
	Results['Points Gained'].Text = AddCommasToNumber:InvokeServer(PointsAdded.Value * CorrectAnswers.Value)..'pts'
	Results['Correct Answers'].Text = CorrectAnswers.Value
	Results['Wrong Answers'].Text = WrongAnswers.Value
	Results['Total Equations'].Text = totalEquations
	
	--Calculates ratio of correct answers over total generated-answered math equations
	if totalEquations == 0 then
		Results.Ratio.Text = '0.00'
	else
		Results.Ratio.Text = string.format('%.2f', CorrectAnswers.Value / totalEquations)
	end
	
	--Directs player to 'Results' UI for the player to see summary
	Results.Visible = true
	
	--Resets UI components from 'Game' UI
	ScoreLabelUI.Text = 'Points: 0'
	UserAnswerUI.Text = ''
	
	--Resets game stats
	resetStats()
end



--Restores 'Instructions' UI to its initial state
ReplicatedStorage:FindFirstChild('Speed Math - Restore Instructions').OnClientEvent:Connect(function()
	Instructions['Page '..currentPage.Value].Visible = false
	currentPage.Value = 1
	Instructions['Page 1'].Visible = true
	Instructions:FindFirstChild('Next/Play').TextLabel.Text = 'Next'
	Instructions:FindFirstChild('Previous').Visible = false
	print('Instructions UI restored!')
end)



--Runs when the player joins the game
initInstructionPages()