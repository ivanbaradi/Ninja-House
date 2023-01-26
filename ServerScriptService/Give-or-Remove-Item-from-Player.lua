--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--ServerStorage
local ServerStorage = game.ServerStorage


--[[Gives item to the player

	Parameter(s):
	player => player who invoked this function (Player)
	item => name of the item to give to the player (string)
	item folder name => name of the items folder ['Items' or 'VIP Items'] (string)
	
	Return(s):
	boolean = {
		true: item is successfully given to the player,
		false: item fails to be given to the player
	}
]]
function giveItemToPlayer(player, item, item_folder_name)
	
	--Clones item and places it to the player's backpack and StarterGui
	if not player.StarterGear:FindFirstChild(item) then

		--Gets Items Folder based on the name of the item folder (Folder)
		local ItemsFolder = ReplicatedStorage:FindFirstChild(item_folder_name)
		--Item from the Items Folder (Tool)
		local Item = ItemsFolder:FindFirstChild(item)

		--Ensures the item is not removed from ReplicatedStorage
		if Item then

			--Need to check for compatible character rigtype for the item being given
			local success, error_message = script:FindFirstChild('RigType is Compatible'):Invoke(player.Character, Item)

			--Plays error sound effect and sends error message to player about incompatible rigtype
			if not success then 

				ReplicatedStorage:FindFirstChild('Announce to Player'):FireClient(player, {
					text = error_message, 
					textColor = Color3.fromRGB(252, 0, 6)
				})

				ReplicatedStorage:FindFirstChild('Play Sound Effect'):FireClient(player, {
					name = 'Error!', 
					volume = 2
				})

				return false
			end

			Item:Clone().Parent = player.Backpack
			Item:Clone().Parent = player.StarterGear

			--print(player.Name..' equipped '..item)
			return true
		end

		return false
	end
	
	return false
end

--Remote Function for giving item to the player
ReplicatedStorage:FindFirstChild('Give Item to Player').OnServerInvoke = giveItemToPlayer
--Bindable Function for giving item to player
ServerStorage:FindFirstChild('Give Item to Player').OnInvoke = giveItemToPlayer

--[[Removes item from the player

	Parameter(s):
	player => player who triggered this event (Player)
	item => name of the item to remove from the player's inventory (String)
]]
function removeItemFromPlayer(player, item)
	
	--Gets item from the starter gear
	local ItemSG = player.StarterGear:FindFirstChild(item)
	--Item is already removed from the player
	if not ItemSG then return end
	
	--Removes item from player's StarterGear
	ItemSG:Remove()
	--Item from the player's backpack
	local ItemBP = player.Backpack:FindFirstChild(item)	 

	--Removes item from the player's backpack or character
	if ItemBP then
		ItemBP:Remove()
	else
		player.Character:FindFirstChild(item):Remove()
	end

	--print(player.Name..' unequipped '..item)
end

--Remote Event for removing items from the player
ReplicatedStorage:FindFirstChild('Remove Item from Player').OnServerEvent:Connect(removeItemFromPlayer)
--Bindable Event for removing items from the player
ServerStorage:FindFirstChild('Remove Item from Player').Event:Connect(removeItemFromPlayer)