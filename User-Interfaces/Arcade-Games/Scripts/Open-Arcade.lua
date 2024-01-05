--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Screen
local Screen = script.Parent
--Arcade Machine
local ArcadeMachine = Screen.Parent
--Configurations
local Configuration = ArcadeMachine.Configuration
local ArcadeUI = Configuration:FindFirstChild('Arcade UI')



--Opens the arcade UI at the client's side
Screen.ProximityPrompt.Triggered:Connect(function(player)
	
	--Will need to check if any arcade UI is open at the player's side
	if ReplicatedStorage:FindFirstChild('Arcade UI Is Open'):InvokeClient(player) then return end
	
	--Plays 'Arcade Bass Hit' sound effect at the player's side
	ReplicatedStorage:FindFirstChild('Play Sound Effect'):FireClient(player, {
		name = 'Arcade Bass Hit',
		volume = 1
	})
	
	--Enables the arcade UI and its menu at the player's side
	ReplicatedStorage:FindFirstChild('Open Arcade UI'):FireClient(player, ArcadeUI.Value)
end)