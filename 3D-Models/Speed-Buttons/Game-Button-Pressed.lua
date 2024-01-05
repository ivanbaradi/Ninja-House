local ReplicatedStorage = game.ReplicatedStorage
local Button = script.Parent
local SpeedButtons = Button.Parent
local Communications = SpeedButtons.Communications

--Configurations
local Configuration  = SpeedButtons.Configuration
local Debouncer = Configuration.Debouncer

--Screen
local Screen = SpeedButtons.Screen
local ScoreUI = Screen['Score UI']

--ScoreUI comps
local RedPressed = ScoreUI['Red Pressed!']

--Game Communications
local ClearAllButtons = Communications:FindFirstChild('Clear All Buttons')

--Fires when the player presses this game button
Button.ClickDetector.MouseClick:Connect(function(player)
	
	if Debouncer.Value then return end
	
	Debouncer.Value = true
	
	--Other players are not allowed to play this game yet!
	if player.UserId ~= Configuration['Player UserId'].Value then
		
		ReplicatedStorage:FindFirstChild('Play Sound Effect'):FireClient(player, {
			name = 'Warning',
			volume = 1
		})
		
		ReplicatedStorage:FindFirstChild('Announce to Player'):FireClient(player, {
			text = 'Wait until this player is done with the game',
			textColor = Color3.fromRGB(255, 251, 0)
		})
		
		Debouncer.Value = false
		
		return
	end
	
	if Button.BrickColor == BrickColor.new('Lime green') then --Points earned!
		Communications['Green Button Pressed']:Fire()
	elseif Button.BrickColor == BrickColor.new('Really red') then --GAME OVER!!!
		Communications['Red Button Pressed']:Fire()
	end
	
	Debouncer.Value = false
end)