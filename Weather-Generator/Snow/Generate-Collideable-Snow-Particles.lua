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