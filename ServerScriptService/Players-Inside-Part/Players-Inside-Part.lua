-- Roblox Services
local Players = game:GetService('Players')

--[[Checks if there are any players that are inside a specific part

	Parameter(s):
		Zone: part served to detect players inside it
		OwnerPermissionFunction: BindableFunction served as a game owner's permission (optional)
		
	Return(s):
		([Player] : boolean) : If there is a key-value pair, it means that 
		there are players inside the zone. Otherwise, nil.
]]
script['Any Player Is In Part'].OnInvoke = function(Zone: BasePart, OwnerPermissionFunction: BindableFunction?) : {[Player] : boolean}
	
	-- Set up the query parameters to only check for character parts
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = {Zone} -- Ignore the zone part itself
	overlapParams.RespectCanCollide = false
	
	-- Gets all parts inside zone
	local Parts = workspace:GetPartsInPart(Zone, overlapParams)

	-- Gets all players inside the zone
	local playersChecked = {}

	-- Iterates all parts inside zone
	for _, part in ipairs(Parts) do
		local Model = part:FindFirstAncestorOfClass("Model")
		if Model then
			local Humanoid = Model:FindFirstChild('Humanoid')
			local Player = Players:GetPlayerFromCharacter(Model)
			if Player and not playersChecked[Player] then
				
				-- Player must have specified permission if there is one
				if OwnerPermissionFunction and not OwnerPermissionFunction:Invoke(Player) then continue end
				
				-- Player cannot be dead
				if Humanoid.Health == 0 then continue end
				
				playersChecked[Player] = true
				--print(Player.Name .. " is inside "..Zone.Name.."!")
			end
		end
	end	
	
	return next(playersChecked)
end