# Client to Client Communications

Roblox API Engine does not offer an API where client-sided scripts aka LocalScript communicate with each other. `RemoteEvent` and `BindableEvent` are examples of communications of scripts, but that's between the client and server, not client and another client.

## Client to Client Communications 
![Client-Client Diagram](/Screenshots/client-client-diagram2.png)<br>
- One-way passage between the client, server, and another client
- Represented as a RemoteEvent

## Client to Client Communications 2
![Client-Client Diagram](/Screenshots/client-client-diagram.png)<br>
- Two-way passage between the client, server, and another client
- Represented as a RemoteFunction
- Client expects data returned from another client in some cases

## Explorer

```text
🗺️ Explorer
└── 📦 ReplicatedStorage
    ├── 🗣️ Client-Client Communications
    └── 🗣️ Client-Client Communications 2
```

## Example
Suppose that the player clicks the button to open the Account Stats menu and it needs to perform a sound effect.

### Explorer
```text
🗺️ Explorer
├── 🌎 Workspace
│	└── 📁 Sound Effects
│		└── 📁 Others
│			└── 🔉 Button Clicked
├── 📦 ReplicatedStorage
│   ├── 🗣️ Client-Client Communications
│	└── 🗣️ Play Sound Effect
└── 🖼️ StarterGui
	├── 🖼️ Account Stats UI
	│	└── 🔴 Button
	│		└── 📝 Account Stats UI Button Handler
	└── 📝 Play Sound Effect
```

### Account Stats UI Button Handler
```lua
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Client to Client Communications (Event)
local Client_Client = ReplicatedStorage:FindFirstChild('Client-Client Communications')
--Button
local Button = script.Parent
--Account Stats UI
local AccountStatsUI = Button.Parent
--Account Stats Menu
local AccountStatsMenu = AccountStatsUI:FindFirstChild('Menu')

--Opens or closes Account Stats UI
function handle()
	--Tells server to get another client to play 'Button Clicked' with volume of 1
	Client_Client:FireServer('Play Sound Effect', {name = 'Button Clicked', volume = 1})
	--Tells server to get another client to close the old UI
	Client_Client:FireServer('Close Old UI', AccountStatsUI)

	if not AccountStatsMenu.Visible then
		AccountStatsMenu.Visible = true
	else
		AccountStatsMenu.Visible = false
	end
end

--Fires when the player presses this button to open/close this UI
Button.MouseButton1Click:Connect(handle)
```

The **Account Stats UI  Handler** opens or closes the Account Stats menu when the player presses its button. From the first line of `handle()`, the client passes the name of the remote event called **Play Sound Effect** and a table including the name of the sound effect and volume.

Because the script does not expect anything in return, it triggers **Client-Client Communications**, not Client-Client Communications 2.

### Client-Client Communications
```lua
--[[Handles a one-way passage between the client, server, and another client.
	
	If object is nil, then this server event will only pass the Player
	object as the parameter. In other word, no object is passed.

	Parameter(s):
		player => player who triggered this event (Player)
		remoteEventName => name of the remote event to trigger (string)
		object => any data
]]
Client_Client_EVENT.OnServerEvent:Connect(function(player: Player, remoteEventName: string, object: any)
	
	local TargetRemoteEvent = ReplicatedStorage:FindFirstChild(remoteEventName)
	
	if object ~= nil then
		TargetRemoteEvent:FireClient(player, object)
	else
		TargetRemoteEvent:FireClient(player)
	end
end)
```

The server gets the request from the client by retrieving its values *(sound effect name and volume)*.  `TargetRemoteEvent` gets the **Play Sound Effect** RemoteEvent to call `FireClient()`, which tells another client-sided script that the `Player` made the request to play the sound effect by its name and volume.

<!-- The **Client-Client-Handler** Script retrieves the RemoteEvent's name and sound effect properties. It retrieves that RemoteEvent from ReplicatedStorage and fires another client sending the targeted <code>player</code> and sound effect properties. <br> -->

### Play Sound Effect
```lua
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Sound Effects
local SoundEffects = workspace:FindFirstChild('Sound Effects')
local MessageSoundEffect = SoundEffects:FindFirstChild('Message')
local OtherSoundEffect = SoundEffects:FindFirstChild('Others')
--Player Settings
local PlayerSettings = ReplicatedStorage:FindFirstChild('Player Settings')
local CanPlaySoundEffects = PlayerSettings:FindFirstChild('Can Play Sound Effects')
local CanPlayMessageSounds = PlayerSettings:FindFirstChild('Can Play Message Sounds')


--[[ Plays sound effect on the client's side

	Parameter(s):
	soundEffect => {
		name (string) => name of the sound effect, 
		volume (number) => volume of the sound effect
	}
]]
ReplicatedStorage:FindFirstChild('Play Sound Effect').OnClientEvent:Connect(function(soundEffect {name: string, volume: number})
	
	--Sound Effect from any sound effects folder
	local SoundEffect = nil
	
	--Checks if the sound effect is a "Message" type and that player's "Message Sound" option is turned off
	if MessageSoundEffect:FindFirstChild(soundEffect.name) then
		if not CanPlayMessageSounds.Value then return end
		SoundEffect = MessageSoundEffect:FindFirstChild(soundEffect.name)

	else --Other sound effects
		if not CanPlaySoundEffects.Value then return end
		SoundEffect = OtherSoundEffect:FindFirstChild(soundEffect.name)
	end
	
	--Prevents another sound effect from playing if one is already playing
	if SoundEffects.IsPlaying then return end
	
	--Plays Sound Effect
	SoundEffects.SoundId = 'rbxassetid://'..SoundEffect.Value
	SoundEffects.Volume = soundEffect.volume
	SoundEffects:Play()
end)
```

That client retrieves the request from the server to play the sound effect on the background.
