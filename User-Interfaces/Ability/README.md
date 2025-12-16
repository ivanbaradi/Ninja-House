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
local BodyParts = {
	
	--R6 and R15 body parts
	['Head'] = {['Fire Size'] = 0},
	['HumanoidRootPart'] = {['Fire Size'] = 3},
	
	--R15 models body parts
	['UpperTorso'] = {['Fire Size'] = 4},
	['LowerTorso'] = {['Fire Size'] = 3},
	['LeftUpperArm'] = {['Fire Size'] = 3.5},
	['LeftLowerArm'] = {['Fire Size'] = 3},
	['LeftHand'] = {['Fire Size'] = 3},
	['RightUpperArm'] = {['Fire Size'] = 3.5},
	['RightLowerArm'] = {['Fire Size'] = 3},
	['RightHand'] = {['Fire Size'] = 3},
	['LeftUpperLeg'] = {['Fire Size'] = 3},
	['LeftLowerLeg'] = {['Fire Size'] = 3},
	['LeftFoot'] = {['Fire Size'] = 3},
	['RightUpperLeg'] = {['Fire Size'] = 3},
	['RightLowerLeg'] = {['Fire Size'] = 3},
	['RightFoot'] = {['Fire Size'] = 3},
	
	--R6 models body parts
	['Torso'] = {['Fire Size'] = 5},
	['Left Arm'] = {['Fire Size'] = 3},
	['Right Arm'] = {['Fire Size'] = 3},
	['Left Leg'] = {['Fire Size'] = 3},
	['Right Leg'] = {['Fire Size'] = 3}
}
```

`Fire Size` can be configured here for all R6 and R15 body parts. Be sure to view all character's body parts to make sure that you're not missing any parts to add fire effects. If you don't want to add fire on some body parts, set `['Fire Size'] = 0`.

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

This event basically adds `Fire` effect to every character's body parts. When Ninja Super Powers are disabled, `Remove Ninja Super Power Effects` RemoteEvent removes all `Fire` effects.