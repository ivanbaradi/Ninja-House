wait(.1)
--ServerStorage
local ServerStorage = game.ServerStorage
--MarketplaceServices
local MarketplaceServices = game:GetService('MarketplaceService')
--TV
local TV = script.Parent
--Previous and Next TV Channels
local PreviousButton, NextButton = TV:FindFirstChild('Previous Button'), TV:FindFirstChild('Next Button')
--First channel of the TV
local TV_Channel = ServerStorage:FindFirstChild('TV Channels [Video]'):GetChildren()[1]
--Gets the product info of the asset based on its ID
local TV_ProductInfo = MarketplaceServices:GetProductInfo(TV_Channel.Value)

--Initializes the channel's Video ID to display onto the TV with the first channel
TV:FindFirstChild('Screen'):FindFirstChild('TV Gui'):FindFirstChild('VideoFrame').Video = 'rbxassetid://'..TV_Channel.Value

--Initializes ProximityPrompt ObjectTexts from previous and next channel buttons
PreviousButton.ProximityPrompt.ObjectText = TV_ProductInfo.Name
NextButton.ProximityPrompt.ObjectText = TV_ProductInfo.Name

--Debuggers
--print('Asset Id = '..TV_Channel.Value)
--print('Previous Button ObjectText = '..PreviousButton.ProximityPrompt.ObjectText)
--print('Next Button ObjectText = '..NextButton.ProximityPrompt.ObjectText)