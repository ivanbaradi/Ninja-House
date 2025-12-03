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