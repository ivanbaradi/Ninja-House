# 🧱 Players Inside Part

Players will need to know if they are inside a part or we call the **Zone**. Zones are basically <u>invisible parts that detect player characters inside of it</u> to perform something such as teleporting enough players to go to another location. 

Keep in mind that zones can detect other parts from non-player models which is why it's important to implement validations.

#  🖥️ Analyzing Players

```lua
local playersChecked = {}

for _, part in ipairs(Parts) do
    local Model = part:FindFirstAncestorOfClass("Model")
    if Model then
        local Humanoid = Model:FindFirstChild('Humanoid')
        local Player = Players:GetPlayerFromCharacter(Model)
        if Player and not playersChecked[Player] then
            
            if OwnerPermissionFunction and not OwnerPermissionFunction:Invoke(Player) then continue end
    
            if Humanoid.Health == 0 then continue end
            
            playersChecked[Player] = true
        end
    end
end	
```

This snippet iterates through all character `Parts`. When a Roblox character enters inside, one of its `BasePart` get detected and  determined if it's a `Model` and `Player`. This is because every Roblox character is represented as a <u>model and some models are owned by players</u>. We don't want to deal with other objects and NPCs besides players. 

Usually, we check if `Humanoid` exists to validate NPCs, but we don't need to because all player characters are `Model`.

The `OwnerPermissionFunction` is served as an optional parameter if permissions are needed to add the player to `playersChecked`, which is a <u>table that stores players inside the zone</u>. Otherwise, we can simply add them to that table.

