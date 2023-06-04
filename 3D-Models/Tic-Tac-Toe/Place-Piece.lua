--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Game Owner Settings (Communications)
local GameOwnerCommunications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--ServerStorage
local ServerStorage = game.ServerStorage
--Tic Tac Toe Pieces
local GamePieces = ServerStorage:FindFirstChild('Tic Tac Toe Pieces')
--Slot
local Slot = script.Parent
--Tic Tac Toe Game Model
local TicTacToe = Slot.Parent.Parent
--Configurations
local Configurations = TicTacToe:FindFirstChild('Configuration')
local CurrentPiece = Configurations:FindFirstChild('Current Piece')
local SlotsOccupied = Configurations:FindFirstChild('Slots Occupied')
local Debounce = Configurations:FindFirstChild('Debounce')
--Communications
local Communications = TicTacToe:FindFirstChild('Communications')
local CheckWinningCombination = Communications:FindFirstChild('Check Winning Combination')
local AnnounceWinner = Communications:FindFirstChild('Announce Winner')
local ClearAllPieces = Communications:FindFirstChild('Clear All Pieces')


--[[Announces winner, clears all pieces, resets slot vacants to 0, and sets current piece to 'X'

	Parameter(s):
	isTiedGame => {true: all slots filled but no one wins, false: there is a winner}
]]
function resetGame(isTiedGame)
	AnnounceWinner:Invoke(isTiedGame)
	ClearAllPieces:Fire()
	SlotsOccupied.Value = 0
	CurrentPiece.Value = 'X'
end



--Fires when the player clicks the slot
Slot.ClickDetector.MouseClick:Connect(function(player)
	
	if Debounce.Value then return end
	Debounce.Value = true
	
	--Players don't have permission to use house accessories
	if not GameOwnerCommunications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then 
		Debounce.Value = false
		return
	end
	
	--Places tic tac toe piece to the game
	local CurrentPiecePart = GamePieces:FindFirstChild(CurrentPiece.Value):Clone()
	CurrentPiecePart.Position = Vector3.new(Slot.Position.X, Slot.Position.Y, Slot.Position.Z)
	CurrentPiecePart.Parent = Slot
	
	--Occupies slot
	Slot.ClickDetector.MaxActivationDistance = 0
	SlotsOccupied.Value += 1
	
	--Checks if the game needs to continue
	if CheckWinningCombination:Invoke(Slot.Name) then --Red or Blue Wins!
		resetGame(false)
	else 
		
		if SlotsOccupied.Value == 9 then --Tied Game
			resetGame(true)
		else --Game Continues
			if CurrentPiece.Value == 'X' then
				CurrentPiece.Value = 'O' --Red's turn
				print("It's Red's turn")
			else
				CurrentPiece.Value = 'X' --Blue's turn
				print("It's Blue's turn")
			end
		end
	end
	
	Debounce.Value = false
end)