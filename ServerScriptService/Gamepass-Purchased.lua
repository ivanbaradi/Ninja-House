--[[This script handles a player's gamepass purchase]]

--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--MarketplaceService
local MarketplaceService = game:GetService("MarketplaceService")

--List of Gamepass IDs (Add more soon)
GamepassIDs = {
	['VIP'] = 78522282,
	['Ninja Super Powers'] = 87789481
	
	
}




--Returns all gamepass IDs in this game
ReplicatedStorage:FindFirstChild('Get Gamepass IDs').OnServerInvoke = function(player)
	return GamepassIDs
end




--[[Triggered when a player is finished responding to the gamepass purchase prompt

	Parameter(s):
	player: player object (Player)
	gamepassID: ID of the gamepass that the player wants to purchase (int)
	success: {true = player purchased the gamepass, false = player cancelled the purchase or there is some error} (boolean)
]]
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassID, success)
	
	if success then
		
		if gamepassID == GamepassIDs['VIP'] then
			
			--Changes button's text from 'Buy VIP Gamepass' to 'Equip' if the VIP Item is currently displayed
			local ItemDisplayCollection = ReplicatedStorage:FindFirstChild('Get Item Display Collection'):InvokeClient(player)
			if ItemDisplayCollection == 'VIP Items' then
				ReplicatedStorage:FindFirstChild('Set Equip Button State'):FireClient(player, {
					text = 'Equip',
					background_color = Color3.fromRGB(89, 198, 8),
					outline_color = Color3.fromRGB(62, 132, 8)
				})
			end
		end
		
	end
end)