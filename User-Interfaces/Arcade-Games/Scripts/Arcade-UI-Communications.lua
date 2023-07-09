--THIS SCRIPT APPIES TO ANY ARCADE UI


--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Player
local Player = game.Players.LocalPlayer
--PlayerGui
local PlayerGui = Player.PlayerGui
--Client-to-Client Communications
local CLIENT_CLIENT = ReplicatedStorage:FindFirstChild('Client-Client Communications')
--List of Arcade UI names
local ArcadeUI_Names = {'Hangman UI', 'Speed Math UI'}


--[[Checks if any arcade UI is opened (enabled)

	Return(s):
	boolean => {
		true: one of the arcade UIs is opened, 
		false: none of the arcade UIs is opened
	}
]]
ReplicatedStorage:FindFirstChild('Arcade UI Is Open').OnClientInvoke = function()
	
	--Loops through all arcade UIs to see if one of them is open
	for _, ArcadeUI_Name in pairs(ArcadeUI_Names) do
		
		local ArcadeUI = PlayerGui:FindFirstChild(ArcadeUI_Name)
		
		--[[Will need to play the 'Warning' sound effect at the player's
		side and instruct player to close the opened arcade game]]
		if ArcadeUI.Enabled then 
			
			CLIENT_CLIENT:FireServer('Play Sound Effect', {
				name = 'Warning',
				volume = 1
			})
			
			CLIENT_CLIENT:FireServer('Announce to Player', {
				text = 'Please close your arcade game before opening another one',
				textColor = Color3.fromRGB(255, 251, 0)
			})
			
			return true 
		end
	end
	
	return false
end



--[[Opens (enables) arcade UI game after they interact with 
	the arcade machine  with the ProximityPrompt that tells 
	them to 'Play' the arcade 
	
	Enabling the arcade UI means that the arcade UI is open at the
	player's side

	Parameter(s):
	ArcadeUI_Name (string) => name of the arcade UI to open
]]
ReplicatedStorage:FindFirstChild('Open Arcade UI').OnClientEvent:Connect(function(ArcadeUI_Name)
	PlayerGui:FindFirstChild(ArcadeUI_Name).Enabled = true
end)