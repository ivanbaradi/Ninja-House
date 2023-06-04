--Tic Tac Toe Model
local TicTacToe = script.Parent
--List of slot parts
local Slots = TicTacToe:FindFirstChild('Slots')
--Communications
local Communications = TicTacToe:FindFirstChild('Communications')
--Configurations
local Configurations = TicTacToe.Configuration
local CurrentPiece = Configurations:FindFirstChild('Current Piece')
local WinDisplayTime = Configurations:FindFirstChild('Win Message Display Time')
--List of Winning Combinations (Key: slot name, Value: array of winning combinations)
local winningCombinations = {
	['Slot 1'] = {{'1','2','3'},{'1','4','7'},{'1','5','9'}},
	['Slot 2'] = {{'1','2','3'},{'2','5','8'}},
	['Slot 3'] = {{'1','2','3'},{'3','5','7'},{'3','6','9'}},
	['Slot 4'] = {{'1','4','7'},{'4','5','6'}},
	['Slot 5'] = {{'2','5','8'},{'1','5','9'},{'3','5','7'},{'4','5','6'}},
	['Slot 6'] = {{'3','6','9'},{'4','5','6'}},
	['Slot 7'] = {{'1','4','7'},{'3','5','7'},{'7','8','9'}},
	['Slot 8'] = {{'2','5','8'},{'7','8','9'}},
	['Slot 9'] = {{'3','6','9'},{'1','5','9'},{'7','8','9'}}
}
--Winner UI (Displays which color [piece] won)
local WinnerUI = TicTacToe:FindFirstChild('Winner UI').TextLabel


--[[Checks if a winning combination exists after a player
	places a piece

	Parameter(s):
	yourSlot (string) => name of the slot from 'Slots' pressed by the Player
	
	Returns(s):
	boolean => {true: winning combination exists, false: winning combination does not exist yet}
]]
Communications:FindFirstChild('Check Winning Combination').OnInvoke = function(yourSlot)
	
	--Loops through all player slot's winning combinations
	for _, winningCombination in pairs(winningCombinations[yourSlot]) do		
		--Loops through all slot values from a winning combination
		for i, slotNumber in winningCombination do
			
			--Gets a slot from 'Slots' Model
			local Slot = Slots:FindFirstChild('Slot '..slotNumber)
			
			--Goes to the next combination because either there is no piece or it's from the opposing player
			if not Slot:FindFirstChild(CurrentPiece.Value) then break end
			
			--There is a winning combination with all 'X' or 'O' pieces
			if i == #winningCombination then
				return true
			end
		end
	end
	
	
	return false
end



--Removes 'X' and 'O' pieces from all slots and enables all slots to be clickable
Communications:FindFirstChild('Clear All Pieces').Event:Connect(function()
	for _, Slot in pairs(Slots:GetChildren()) do
		local GamePiece = Slot:FindFirstChildOfClass('UnionOperation')
		if GamePiece then
			GamePiece:Remove()
			Slot.ClickDetector.MaxActivationDistance = 5
		end
	end
	
	print('All pieces have been cleared')
end)



--[[Displays the 'X' (blue) or 'O' (red) winner from the Winner UI from this game


	Parameter(s):
	isTiedGame (boolean) => {true: all slots filled but no one wins, false: there is a winner}
]]
Communications:FindFirstChild('Announce Winner').OnInvoke = function(isTiedGame)
	
	--Red (X), blue (O), and white (tied) colors for text
	local redColor = Color3.fromRGB(255, 126, 121)
	local blueColor = Color3.fromRGB(92, 195, 255)
	local whiteColor = Color3.fromRGB(255, 255, 255)
	
	if isTiedGame then
		WinnerUI.TextColor3 = whiteColor
		WinnerUI.Text = 'Tie'
	elseif CurrentPiece.Value == 'X' then
		WinnerUI.TextColor3 = blueColor
		WinnerUI.Text = 'Blue Wins!'
	else
		WinnerUI.TextColor3 = redColor
		WinnerUI.Text = 'Red Wins!'
	end
	
	WinnerUI.Visible = true
	wait(WinDisplayTime.Value)
	WinnerUI.Visible = false
end