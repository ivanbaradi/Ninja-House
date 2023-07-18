local ReplicatedStorage = game.ReplicatedStorage
local OwnerCommunications = ReplicatedStorage['Game Owner Settings']['Communications']
local Button = script.Parent
local SpeedButtons = Button.Parent
local GameCommunications = SpeedButtons:FindFirstChild('Communications')

--Configurations
local Configuration = SpeedButtons.Configuration
local Debouncer = Configuration.Debouncer

--Screen's UIs
local Screen = SpeedButtons.Screen
local StartGameUI = Screen['Start Game UI']
local ScoreUI = Screen['Score UI']

--ScoreUI Comps
local PlayerName1 = ScoreUI['Player Name 1']
local PlayerName2 = ScoreUI['Player Name 2']



--Starts the game after the player presses the green button
Button.ClickDetector.MouseClick:Connect(function(player)
	
	if Debouncer.Value then return end
	
	Debouncer.Value = true
	
	--Players don't have permission to use house accessories
	if not OwnerCommunications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then
		Debouncer.Value = false
		return 
	end
	
	--Sets player userId so only this player can play this game
	Configuration['Player UserId'].Value = player.UserId
	
	--Sets player's username and display name; Display it at ScoreUI
	if player.Name ~= player.DisplayName then
		PlayerName1.Text = player.DisplayName
		PlayerName2.Text = '@'..player.Name
		PlayerName2.Visible = true
	else
		PlayerName1.Text = player.Name
		PlayerName2.Visible = false
	end
	
	--Starts game
	Configuration['Gameplay Running'].Value = true
	GameCommunications:FindFirstChild('Set Max Activation Distances'):Fire(30)
	GameCommunications:FindFirstChild('Color Buttons'):Fire()
	GameCommunications:FindFirstChild('Run Timer'):Fire()
	
	--Switches to Score UI
	StartGameUI.Enabled = false
	ScoreUI.Enabled = true
	
	--Disables this button
	Button.BrickColor = BrickColor.new('Really red')
	Button.ClickDetector.MaxActivationDistance = 0
	
	print('Game has started!')
	
	Debouncer.Value = false
end)