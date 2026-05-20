# 🚪 Door

Doors in the game are animated. It opens whenever the player approaches it and closes when it goes away from it. By default, people are allowed to use the doors unless the game owner restricts that access. 

## 🗺️ Explorer
```text
🗺️ Explorer
├── 🌎 Workspace
│   └── 🚪 Door 
│       ├── 🔓 Door Opener
│       │   └── 📝 Handle Door
│       ├── ⚙️ Configuration
│       │   ├── ⌗ Close Door Wait Time
│       │   ├── ⌗ Closing Door Sound ID
│       │   ├── ⌗ Opening Door Sound ID
│       │   ├── ⌗ Max Door Angle
│       │   └── ☑️ Is Inside Door Opener
│       └── 🧱 ...other door parts including hinge
└── ☁️ ServerScriptServices
    └── 📝 Door Handler
        ├── 📝 Door Modules 
        ├── 🧱 Animate Door
        ├── 🧱 Run Door
        ├── ⚡️ Play Door Sound
        └── ⚡️ Set Collidable Parts
```

## 🚪🚶🏼 Handle Door
```lua
DoorOpener.Touched:Connect(function(part: BasePart) 
	
	if debounce then return end

	debounce = true
	
	local Character = part:FindFirstAncestorOfClass('Model')
	local Player = Players:GetPlayerFromCharacter(Character)
	
	--Must check if other players have permission to use doors
	if not GameOwnerCommunications['Players Can Use Doors']:Invoke(Player) then 
		debounce = false
		return 
	end
	
	--Must check if the model is a character
	if not Character:FindFirstChild('Humanoid') then
		debounce = false
		return 
	end

	RunDoor:Invoke(Door, Character, openDoor, closeDoor)
	
	debounce = false	
end)
```

Touched event is triggered when a player enters an invisible part called the `DoorOpener`, which is responsible for animating the door.  `RunDoor` relays data to another script called **Door Handler**.

```lua
DoorOpener.TouchEnded:Connect(function() 
	InsideDoorOpener.Value = false
end)
```

TouchEnded event is triggered whenever the player leaves the Door Opener, which closes the door by setting `InsideDoorOpener.Value = false`. Otherwise, the door stays open.

## ⚙️ Door Handler
```lua
script['Run Door'].OnInvoke = function(Door: Model, Character: Model, OpenDoor: Tween, CloseDoor: Tween)
		
	--Door Model
	local DoorSound = Door['Door Opener']['Door Sound']
			
	--Configuration
	local Configuration = Door.Configuration
	local InsideDoorOpener = Configuration['Is Inside Door Opener'] -- detects player's existence inside this part
	local WaitTime = Configuration['Close Door Wait Time'] -- waiting time to close the door
	local OpeningSoundID = Configuration['Opening Sound ID'] -- sound for opening the door
	local ClosingSoundID = Configuration['Closing Sound ID'] -- sound for closing the door
	
	--Opens door
	InsideDoorOpener.Value = true
	SetCollidableParts:Fire(Door, false)
	PlayDoorSound:Fire(DoorSound, OpeningSoundID.Value)
	OpenDoor:Play()
	
	--Loops until player left the "Door Opener" part
	repeat task.wait(WaitTime.Value) until not InsideDoorOpener.Value

	--Closes door
	PlayDoorSound:Fire(DoorSound, ClosingSoundID.Value)
	CloseDoor:Play()
	SetCollidableParts:Fire(Door, true)
end
```

This is the main driver of the door animations. This is served as a centralized handler for all doors in the game. You can view separate functionalities from **Door Modules** script to see behind the scenes in depth.

## 🎬 Demo
[![Watch the video](https://img.youtube.com/vi/xbzwaiTgjCg/hqdefault.jpg)](https://www.youtube.com/embed/xbzwaiTgjCg)
