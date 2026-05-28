# 🚪 Door

Doors in the game are animated. It opens whenever the player approaches it and closes when it goes away from it. By default, people are allowed to use the doors unless the game owner restricts that access. 

## 🗺️ Explorer
```text
🗺️ Explorer
├── 🌎 Workspace
│	└── 🚪 Animating Door
│		├── 🚪 Door 
│		│   ├── 🧱 Hinge
│		│   ├── 🧱 ...other door parts
│		│   └── ⚙️ Configuration
│		│      	└── ⌗ Max Door Angle
│		├── 🚪 ...other doors 
│		├── 🔓 Door Opener
│		│   ├── 🔊 Door Sound
│		│   └── 📝 Handle Door
│		└── ⚙️ Configuration
│			├── ⌗ Close Door Wait Time
│			├── ⌗ Closing Door Sound ID
│			├── ⌗ Opening Door Sound ID
│			└── ☑️ Is Inside Door Opener
└── ☁️ ServerScriptServices
	└── 📝 Door Handler
		├── 📝 Door Modules 
		├── 🧱 Animate Door
		├── 🧱 Run Door
		├── ⚡️ Play Door Sound
		└── ⚡️ Set Collidable Parts
```

## 🚪🚶🏼 Handle Door

### 📖 Door Dictionary
```lua
type DoorDictionary = {
	Door: Model, -- door model
	OpenDoor: Tween, -- animation for opening door
	CloseDoor: Tween -- animation for closing door
}
```

`DoorDictionary` is a dictionary that includes information about the door including its 3D structure, and their opening and closing door animations. 


```lua
DoorDictionaries = {}
for _, Door in pairs(Doors:GetChildren()) do
	if not Door:IsA('Model') then continue end
	table.insert(DoorDictionaries, {
		Door = Door, 
		OpenDoor = AnimateDoor:Invoke(Door.Hinge, Door.Configuration['Max Door Angle'].Value),
		CloseDoor = AnimateDoor:Invoke(Door.Hinge, 0)
	})
end
```

Each door gets iterated to initialize their animations as well as their `Max Door Angle`, which is the maximum angle of an opened door, to get inserted into `DoorDictionaries`.


### ⚡️ Touched Event
```lua
DoorOpener.Touched:Connect(function(part: BasePart) 
	
	if debounce then return end

	debounce = true
	
	local Character = part:FindFirstAncestorOfClass('Model')
	local Player = Players:GetPlayerFromCharacter(Character)
	
	--Must check if the model is a character
	if not Character:FindFirstChild('Humanoid') then
		debounce = false
		return 
	end
	
	--Must check if other players have permission to use doors
	if not GameOwnerCommunications['Players Can Use Doors']:Invoke(Player) then 
		debounce = false
		return 
	end

	RunDoor:Invoke(DoorDictionaries, Configuration, DoorOpener['Door Sound'])
	
	debounce = false	
end)
```

TouchedEvent is triggered when a player enters an invisible part called the `DoorOpener`, which is responsible for animating the door.  `RunDoor` relays data to another script called **Door Handler** for executing the rest of functionalities.

```lua
DoorOpener.TouchEnded:Connect(function() 
	InsideDoorOpener.Value = false
end)
```

TouchEnded event is triggered whenever the player leaves the Door Opener, which closes the door by setting `InsideDoorOpener.Value = false`. Otherwise, the door stays open.

## ⚙️ Door Handler
```lua
script['Run Door'].OnInvoke = function(DoorDictionaries: {DoorDictionary}, Configuration: Configuration, DoorSound: Sound)
			
	local InsideDoorOpener = Configuration['Is Inside Door Opener']
	local WaitTime = Configuration['Close Door Wait Time']
	local OpeningSoundID = Configuration['Opening Sound ID']
	local ClosingSoundID = Configuration['Closing Sound ID']
	
	local function runDoorAnimations(SoundID: IntValue, canCollide: boolean)
		PlayDoorSound:Fire(DoorSound, SoundID.Value)
		for _, DoorDictionary in ipairs(DoorDictionaries) do
			SetCollidableParts:Fire(DoorDictionary.Door, canCollide)
			DoorDictionary[(canCollide and 'CloseDoor') or 'OpenDoor']:Play()
		end
	end
	
	-- Opens door
	InsideDoorOpener.Value = true
	runDoorAnimations(OpeningSoundID, false)
	
	-- Loops until player left the "Door Opener" part
	repeat task.wait(WaitTime.Value) until not InsideDoorOpener.Value

	-- Closes door
	runDoorAnimations(ClosingSoundID, true)
end
```

This is the main driver of the door animations. This is served as a centralized handler for all doors in the game. You can view separate functionalities from **Door Modules** script to see behind the scenes in depth.

## 🎬 Demo
[![Watch the video](https://img.youtube.com/vi/xbzwaiTgjCg/hqdefault.jpg)](https://www.youtube.com/embed/xbzwaiTgjCg)