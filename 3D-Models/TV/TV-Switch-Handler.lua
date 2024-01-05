--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--ServerStorage
local ServerStorage = game.ServerStorage
--TV Switch
local Switch = script.Parent
--ProximityPrompt
local ProximityPrompt = Switch:FindFirstChild('ProximityPrompt')
--Switch button colors
local green = Color3.fromRGB(0, 255, 0)
local red = Color3.fromRGB(255, 0, 0)
--TV
local TV = Switch.Parent
--TV GUI
local TV_GUI = TV.Screen:FindFirstChild('TV Gui')
--VideoFrame
local VideoFrame = TV_GUI:FindFirstChild('VideoFrame')
--Game Owner Settings
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--debouncer (prevents the event from being executed unneccesary times)
local debounce = false
--Collection of TV Channels {Name = name of the TV channel, Value = AssetID of the TV Channel} (Video Format)
local TV_Channels_VIDEO = ServerStorage:FindFirstChild('TV Channels [Video]'):GetChildren()



--[[Changes states of the TV

	Parameter(s):
	TV_state => {true: TV is on, false: TV is off} (boolean)
	channel proxyprompt state => {true: enables prompt to switch channels, false: disables prompt} (boolean)
	volume => volume of the TV (double)
]]
function setTV_State(TV_state, channel_proxyprompt_state, volume)
	TV_GUI.Enabled = TV_state
	TV:FindFirstChild('Previous Button').ProximityPrompt.Enabled = channel_proxyprompt_state
	TV:FindFirstChild('Next Button').ProximityPrompt.Enabled = channel_proxyprompt_state
	VideoFrame.Volume = volume
end



--Prompts user to turn the TV on or off
ProximityPrompt.Triggered:Connect(function(player)
	
	if debounce then return end
	
	debounce = true
	
	--Check 'Players Can Use Home Accessories' configuration for non-owner players
	if not Communications:FindFirstChild('Players Can Home Accessories'):Invoke(player) then 
		debounce = false
		return 
	end
	
	
	Switch:FindFirstChild('Click'):Play()
	
	
	if ProximityPrompt.ActionText == "Turn On" then	
		Switch.Color = green
		ProximityPrompt.ActionText = 'Please Wait'
		wait(4)
		
		--BUG:'Playing' property for VideoFrame is automatically set to false
		if VideoFrame.Playing == false then VideoFrame.Playing = true end
		
		setTV_State(true, true, 1)
		ProximityPrompt.ActionText = 'Turn Off'
	else
		Switch.Color = red
		setTV_State(false, false, 0)
		ProximityPrompt.ActionText = 'Turn On'
	end
	
	debounce = false
end)