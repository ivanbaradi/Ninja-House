# Teleportation

Teleportation allows players to different areas of the game. As of this update, it only teleports them back to spawn.

*In the future update, players will be able to teleport to different areas and other Roblox experiences with UI interaction.*

## Explorer

```text
🗺️ Explorer
├──	👨🏻‍🔧 ServerScriptServices
│  	└── 📝 Teleport Services
└── 📦 ServerStorage
	└── 🗣️ Teleport Player
```

## Services

**Teleport Services** is an API of teleportations.

*In the future, there will be more methods for teleporting players to more places in the game and other experiences.*

## Example

Suppose that the character touches water and you don't want them being stuck there. Instead, you want them to be teleported back to spawn.

### Explorer
```text
🗺️ Explorer
├── 🌎 Workspace
│  	└── ⛰️ Terrain
│  		└── 🪨 Infinite Soil
│  			└── 📝 Teleport Player to Spawn
├──	👨🏻‍🔧 ServerScriptServices
│  	└── 📝 Teleport Services
└── 📦 ServerStorage
	└── 🗣️ Teleport Player
```

### Teleport Player to Spawn
```lua
local ServerStorage = game.ServerStorage
local Players = game:GetService('Players')
local debounce = false

--Players will be teleported back to spawn if they touch infinite water
script.Parent.Touched:Connect(function(hit: Part)
	
	if debounce then return end
	debounce = true
	
	local model = hit.Parent
	if model then
		local humanoid = model:FindFirstChild('Humanoid')
		if humanoid then 
			if humanoid.Health > 0 then ServerStorage['Teleport Player']:Fire(model, 'SpawnLocation') end
		end
	end
	wait(.5)
	debounce = false
end)
```

This script teleports players back to spawn if they touch **Infinite Soil**.

The player also has to be alive for teleportation to work, because it wouldn't really make sense if a dead player gets teleported, right?

The player's character is described as a `Model`, but not all models are characters, which is why we need to check if the soil touches only characters. To do this, a conditional statement checks if a model contains a `Humanoid` instance. if `Humanoid ~= nil`, then it denotes that the Model is a character.

The script then communicates with **Teleport Services** to have it teleport players back to **SpawnLocation**, which is where players initially spawn at.

### Teleport Services

```lua
local ServerStorage = game.ServerStorage

--[[Teleports player to a destination

	Parameter(s):
		model => player's character
		destinationName => name of the destination to where the player will teleport to
]]
function teleportPlayer(char: Model, destinationName: string)
	local destination = workspace:FindFirstChild(destinationName)
	local pos = destination.Position
	char:PivotTo(CFrame.new(pos.X, pos.Y, pos.Z))
end

ServerStorage['Teleport Player'].Event:Connect(teleportPlayer)
```

**Teleport Player to Spawn** fires **Teleport Player** to teleport player's character, `char`, to SpawnLocation, `destinationName`. 

### Demo

[![Watch the video](https://img.youtube.com/vi/Zs9z7stJKOo/hqdefault.jpg)](https://www.youtube.com/embed/Zs9z7stJKOo)