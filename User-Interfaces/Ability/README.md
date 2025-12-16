# Ability

**Ability** is defined as a character's movements such as walkspeed and jump power. It can be configured through a UI. Abilities improve as the player presses its button and eventually resets when player is at max ability and that they press the button again.

## Explorer

```text
🗺️ Explorer
├── 📦 ReplicatedStorage
│   ├── 🥷 Add Ninja Super Power Effects
│   └── 🥷 Remove Ninja Super Power Effects
├── 📑 ServerScriptService
│   └── 📝 Ninja Super Power Effects Handler
└── 🖼️ Ability UI
    └── 🔴 Button
        ├── 🔳 Background
        ├── 🔲 Outline
        └── 📝 Change Ability
```

## Abilities

```lua
abilities = {
	{
		Name = 'Slow Walk',
		AssetId = 'rbxassetid://9525534183',
		WalkSpeed = 10,
		JumpPower = 50,
		ImageColor = whiteColor
	},
	{
		Name = 'Walk',
		AssetId = 'rbxassetid://9525534183',
		WalkSpeed = 16,
		JumpPower = 50,
		ImageColor = yellowColor
	},
	{
		Name = 'Run',
		AssetId = 'rbxassetid://9525535512',
		WalkSpeed = 40,
		JumpPower = 50,
		ImageColor = yellowColor
	},
	{
		Name = 'Ninja', -- gamepass required
		AssetId = 'rbxassetid://9525535512',
		WalkSpeed = 100,
		JumpPower = 150,
		ImageColor = redColor
	}
}
```

`abilities` is defined to be all character's abilities. The last one can be traversed if the player owns **Ninja Super Powers** gamepass.

At the start of the game, `i = 2` meaning that character's `WalkSpeed = 16` and `JumpPower = 50`, which is normally defaulted in Roblox games. `AssetId` and `ImageColor` customizes the ability UI button. 

Basically, whenever the player presses the button to change ability, it goes to the next ability and `i = 0` once it reaches the last one or `n-1` *(in this case `abilities[3]`)*.

## Ninja Super Powers

```lua
--[[Adds fire to the player's character

	Parameter(s):
	player (Player) => targeted player to add fire to its character
]]
ReplicatedStorage:FindFirstChild('Add Ninja Super Power Effects').OnServerEvent:Connect(function(player: Player)
	
	--Gets player's charatcer
	local char = player.Character

	--Only loops through character's body parts
	for _, bodyPart in pairs(char:GetChildren()) do
		
		--Do not add fire to the character's head because the player won't be able to see in 1st person + possible lag
		if bodyPart.Name == 'Head' then continue end
		
		if bodyPart:IsA('MeshPart') --[[R15]] or bodyPart:IsA('Part') --[[R6]] then
			local Fire = Instance.new('Fire', bodyPart)
			Fire.Name = 'Ninja Effect'
			Fire.Color = Color3.fromRGB(253, 141, 66)
			Fire.Size = BodyParts[bodyPart.Name]['Fire Size']
			Fire.Heat = 1
		end
	end
end)
```

This script basically adds `Fire` effect to every character's body parts. `Fire Size` can be configured through its script. When Ninja Super Power are disabled `Remove Ninja Super Power Effects` RemoteEvent is fired *(See its snippet for functionality)*.

