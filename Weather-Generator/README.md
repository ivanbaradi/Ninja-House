# Weather Generator

**Weather Generator** enables weather in the game.

Unfortunately, Roblox Engine's ParticleEmitter makes particles go through parts. Fortunately, **ParticlesModuleExperimantal** ModuleScript by BubasGaming allows particles *(weather parts)* to collide with other Parts. I want to thank this person for creating this module.

## Explorer

```text
🗺️ Explorer
├── 🌎 Workspace
│   ├── ⚙️ Weather Generator
│   │   ├── 📝 Assign Weather IDs
│   │   └── 🌧️ Weathers
│   │       ├── ☁️ Weather
│   │       ├── ☁️ Weather
│   │       ├── ☁️ ...
│   │       └── ☁️ Weather n
│   └── ⚪️ Collideable Particles  
├── 📦 ReplicatedStorage
│   └── 📁 Collideable Particle Actors
│       └── ⚪️ Weather Actor
│           └── 📝 Generate Collideable Weather Particles
└── 👤 StarterPlayer
    └── 📄 StarterPlayerScripts
        └── 🧵 Weather Thread
            └── 📝 Clone Weather Actors
```

**Notes:**
- This is the explorer when the server is not running.
- **n** is the the amount of weather parts so far.
- **Weather Thread**, **Weather Actor**, and **Weather Particle(s)** are just placeholders for any type of weather thread such as snow and rain. For example, if the weather is rain, then Weather Thread is renamed respectively to **Rain Thread**.

## Example Usage

Suppose that there is a snowy day in the game. Snow parts will need to be generated in the game.

### Assigning Weather IDs

```text
🗺️ Explorer
└── 🌎 Workspace
    └── ⚙️ Weather Generator
        ├── 📝 Assign Weather IDs
        └── 🌧️ Weathers
            ├── ☁️ Weather
            ├── ☁️ Weather
            └── ☁️ Weather
```

Let's say that there are three Weathers. Keep in mind that each **Weather Actor** must be assigned to corresponding **Weather** for this to work properly.

```lua
for i, Weather in pairs(script.Parent:WaitForChild('Weathers'):GetChildren()) do Weather.Name = 'Weather '..i end
```

**Assign Weather IDs** is responsible for renaming `Weather` to `Weather 1...Weather n` *(in this case `Weather 1...Weather 3`)*.


```text
🗺️ Explorer
└── 🌎 Workspace
    └── ⚙️ Weather Generator
        ├── 📝 Assign Weather IDs
        └── 🌧️ Weathers
            ├── ☁️ Weather 1
            ├── ☁️ Weather 2
            └── ☁️ Weather 3
```

This is the explorer when the server starts.

### Clone Weather Actors

```lua
wait(1)
local ReplicatedStorage = game.ReplicatedStorage
local CollideableParticleActors = ReplicatedStorage:FindFirstChild('Collideable Particle Actors')
local SnowThread = script.Parent
local WeatherGenerator = workspace:WaitForChild('Weather Generator')
local Weathers = WeatherGenerator:WaitForChild('Weathers')

for i = 1, #Weathers:GetChildren() do
	local SnowActor = CollideableParticleActors:FindFirstChild('Snow Actor'):Clone()
	SnowActor:SetAttribute('EmmiterObject', 'Weather '..i)
	SnowActor.Parent = SnowThread
end
```

Accordint to BubasGaming, **Actor** must be instantiated to create collideable particles *(weather particles)*. The amount of actors is <u>proportionate to the amount of Weather parts</u>. 

```text
🗺️ Explorer
└── 👤 StarterPlayer
    └── 📄 StarterPlayerScripts
        └── 🧵 Snow Thread
            ├── ⚪️ Snow Actor
            ├── ⚪️ Snow Actor
            ├── ⚪️ Snow Actor
            └── 📝 Clone Snow Actors
```

When the server starts, the three **Snow Actors** are placed under **Snow Thread** since there are three Weather parts.

### Generating Collideable Weather Particles

![Snow Thread Properties](../Screenshots/snow-thread-properties.png)

Basically, snow parts can be customized by configuring properties under Snow Thread.


```lua
wait(.1)
local ReplicatedStorage = game.ReplicatedStorage
local EmitterCreator = require(ReplicatedStorage.Modules:FindFirstChild('ParticlesModuleExperimental'))
local Emitter = EmitterCreator.new()
local Actor = script.Parent
local Thread = Actor.Parent
local WeatherGenerator = workspace:WaitForChild('Weather Generator')
local Weathers = WeatherGenerator:WaitForChild('Weathers')

--Emitted particle
Emitter.Part = script.Part
--Part that emmits the particles
Emitter.EmmiterObject = Weathers:FindFirstChild(Actor:GetAttribute('EmmiterObject')) 
--Location of where all particles will be stored at
Emitter.Folder = workspace:WaitForChild('Collideable Particles')

--Sets properties for Emitter
Emitter.Bounce = Thread:GetAttribute("Bounce")
Emitter.ColliderSize = Thread:GetAttribute("ColliderSize")
Emitter.CollisionComplexity = Thread:GetAttribute("CollisionComplexity")
Emitter.Drag = Thread:GetAttribute("Drag")
Emitter.LifeTime = Thread:GetAttribute("LifeTime")
Emitter.Rate = Thread:GetAttribute("Rate")
Emitter.Speed = Thread:GetAttribute("Speed")
Emitter.Friction = Thread:GetAttribute("Friction")
Emitter.FaceCamera = Thread:GetAttribute("FaceCamera")
Emitter.Wind = Thread:GetAttribute("Wind")
Emitter.WindStrenght = Thread:GetAttribute("WindStrength")
Emitter.SelfCollisions = Thread:GetChildren("SelfCollisions")
Emitter.SelfSize = Thread:GetAttribute("SelfSize")
Emitter.Iterations = Thread:GetAttribute("Iterations")
Emitter.FluidForce = Thread:GetAttribute("FluidForce")
--Emitter.Mass = Thread:GetAttribute("Mass")
Emitter.Acceleration = Thread:GetAttribute("Acceleration")
Emitter.SelfCollType = EmitterCreator.SelfCollType.Fluid

--Enables the emitter
Emitter.Enabled = true
```

This script passes all configurations for each snow emitters. Generation starts afterwards.

```text
🗺️ Explorer
└── 🌎 Workspace
    └── ⚪️ Collideable Particles
        ├── 🌨️ Part
        ├── 🌨️ Part
        ├── 🌨️ Part
        └── ...and so on
```

When server starts, snow parts, or **Part**, are generated to snow in the game. Keep in mind that `Emitter.LifeTime` is the time before snow parts disappear from the game. Otherwise, the game might lag or raise other issues.

### Explorer When Server Starts

```text
🗺️ Explorer
├── 🌎 Workspace
│   ├── ⚙️ Weather Generator
│   │   ├── 📝 Assign Weather IDs
│   │   └── 🌧️ Weathers
│   │       ├── ☁️ Weather 1
│   │       ├── ☁️ Weather 2
│   │       └── ☁️ Weather 3
│   └── ⚪️ Collideable Particles  
│       ├── 🌨️ Part
│       ├── 🌨️ Part
│       ├── 🌨️ Part
│       └── ...and so on
├── 📦 ReplicatedStorage
│   └── 📁 Collideable Particle Actors
│       └── ⚪️ Snow Actor
│           └── 📝 Generate Collideable Weather Particles
└── 👤 StarterPlayer
    └── 📄 StarterPlayerScripts
        └── 🧵 Weather Thread
            ├── ⚪️ Snow Actor
            │   └── 📝 Generate Collideable Weather Particles
            ├── ⚪️ Snow Actor
            │   └── 📝 Generate Collideable Weather Particles
            ├── ⚪️ Snow Actor
            │   └── 📝 Generate Collideable Weather Particles
            └── 📝 Clone Weather Actors
```

### Demo

[![Watch the video](https://img.youtube.com/vi/1YowiFbioWg/hqdefault.jpg)](https://www.youtube.com/embed/1YowiFbioWg)

## Sources

**Collideable Particles Module** - https://devforum.roblox.com/t/collideable-particles-module-self-collisions-update-v32/2279402/1