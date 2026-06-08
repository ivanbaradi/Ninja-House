# 🚪 Door

Doors in the game are animated. It opens whenever the player approaches it and closes when it goes away from it. By default, people are allowed to use the doors unless the game owner restricts that access. 

# 🗺️ Explorer
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
│			├── ⌗ Closing Door Sound ID
│			├── ⌗ Opening Door Sound ID
│			└── ⌗ Current State
└── ☁️ ServerScriptServices
	└── 📝 Door Handler
		├── 📝 Door Modules 
		│	├── 🧱 Animate Door
		│	├── ⚡️ Play Door Sound
		│	└── ⚡️ Set Collidable Parts
		├── 🧩 Door Type Hints
		└── ⚡️ Run Door
```

# 🚪🚶🏼 Handle Door

## 📖 Door Dictionary
```lua
type DoorDictionary = {
	Door: Model, -- door model
	OpenDoor: Tween, -- animation for opening door
	CloseDoor: Tween -- animation for closing door
}
```

`DoorDictionary` includes information about the door including its 3D structure, and their opening and closing door animations. 


```lua
local DoorDictionaries = {}
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

## ⚙️ Door Options
```lua
type DoorOptions = {
	DoorSound: Sound, -- door sound object
	doorSoundId: number, -- asset Id for door sound
	canCollide: boolean -- parts are collidable. false, otherwise.
}
```

`DoorOptions` are configured to play sounds from other doors and to make their parts collidable. If `canCollide == false`, this means that the door is going to open.


## 🧱 Door Opener

```lua
local function handle(newState: string, doorOptions: DoorTypeHints.DoorOptions)
	if newState == CurrentState.Value then return end
	DoorHandler['Run Door']:Fire(DoorDictionaries, doorOptions)
	CurrentState.Value = newState
end

local AnyPlayerIsInDoorOpener = AnyPlayerIsInPart:Invoke(DoorOpener, PlayerCanUseDoors)

handle((AnyPlayerIsInDoorOpener and 'Opened') or 'Closed', {
	DoorSound = DoorSound,
	doorSoundId = (AnyPlayerIsInDoorOpener and OpeningSoundId.Value) or ClosingSoundId.Value,
	canCollide = not AnyPlayerIsInDoorOpener -- this means false, which is meant to make door parts not collidable when opening it
})
```

This part of the code runs indefinitely to perform door animations anytime. `DoorOpener` is served as a zone to check whether the players are inside it by invoking `AnyPlayerIsInPart` *(not included in the directory)*. If that's true, then it will open door(s). Otherwise, all closes.

# ⚙️ Door Handler
```lua
script['Run Door'].Event:Connect(function(DoorDictionaries: {DoorTypeHints.DoorDictionary}, doorOptions: DoorTypeHints.DoorOptions)
	local DoorSound, doorSoundId, canCollide = doorOptions.DoorSound, doorOptions.doorSoundId, doorOptions.canCollide
	PlayDoorSound:Fire(DoorSound, doorSoundId)
	for _, DoorDictionary in ipairs(DoorDictionaries) do
		SetCollidableParts:Fire(DoorDictionary.Door, canCollide)
		DoorDictionary[(canCollide and 'Close Door') or 'Open Door']:Play()
	end
end)a
```

This is the main driver of the door animations. This is served as a centralized handler for all doors in the game. You can view separate functionalities from **Door Modules** script to see what's behind the scenes.

# 🎬 Demo
[![Watch the video](https://img.youtube.com/vi/xbzwaiTgjCg/hqdefault.jpg)](https://www.youtube.com/embed/xbzwaiTgjCg)