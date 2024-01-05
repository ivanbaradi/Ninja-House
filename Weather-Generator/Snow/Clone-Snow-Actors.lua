--Needs to wait until all weather parts have IDs
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