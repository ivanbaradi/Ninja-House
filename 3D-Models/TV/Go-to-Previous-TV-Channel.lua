--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Channel Button
local ChannelButton = script.Parent
--TV Model
local TV = ChannelButton.Parent
--Collection of TV Channels {Name = name of the TV channel, Value = AssetID of the TV Channel} (Video Format)
local TV_Channels_VIDEO = ServerStorage:FindFirstChild('TV Channels [Video]'):GetChildren()
--Current TV Channel
local ChannelNumber = TV:FindFirstChild('Channel Number')
--Video Frame
local VideoFrame = TV.Screen['TV Gui']['VideoFrame']
--ProximityPrompt
local ProximityPrompt = ChannelButton:FindFirstChild('ProximityPrompt')
--Game Owner Settings
local GameOwnerSettings = ReplicatedStorage:FindFirstChild('Game Owner Settings')
--Communications
local Communications = GameOwnerSettings:FindFirstChild('Communications')
--MarketPlace
local MarketplaceService = game:GetService('MarketplaceService')



--Prompts user to go to the previous channel
ProximityPrompt.Triggered:Connect(function(player)
	
	--Checksif other players can use home acceories
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then return end
	
	ChannelButton:FindFirstChild('Click'):Play()
	
	--Changes the channel
	if ChannelNumber.Value > 1  then
		ChannelNumber.Value -= 1
	else
		ChannelNumber.Value = #TV_Channels_VIDEO
	end
	
	--Gets the channel station number 
	local Channel = TV_Channels_VIDEO[ChannelNumber.Value]
	--Switches channel
	VideoFrame.Video = 'rbxassetid://'..Channel.Value
	--Gets the channel's name
	local ChannelName = MarketplaceService:GetProductInfo(Channel.Value).Name
	
	--Changes the ObjectText of previous and next channel with the new channel's name 
	ProximityPrompt.ObjectText = ChannelName
	TV:FindFirstChild('Next Button').ProximityPrompt.ObjectText = ChannelName
end)