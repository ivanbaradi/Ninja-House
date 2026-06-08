--Roblox Services
local TweenService = game:GetService("TweenService")

--[[Animates opening or closing door

	Parameter(s):
		Hinge: target door's hinge
		ry: value for animating the door 
		
	Return(s):
		Tween: tween for animating a door
]]
script['Animate Door'].OnInvoke = function(Hinge: Part, ry: number) : Tween
	return TweenService:Create(
		Hinge, 
		TweenInfo.new(.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
		{CFrame = Hinge.CFrame * CFrame.Angles(0, math.rad(ry), 0)}
	)
end

--[[Configures all collidable parts of a door. 

	Parameter(s):
		Door => target door
		canCollide => boolen flag for collidable parts
]]
script['Set Collidable Parts'].Event:Connect(function(Door: Model, canCollide: boolean)
	for _, obj in pairs(Door:GetChildren()) do
		if obj:IsA('BasePart') then obj.CanCollide = canCollide end
	end
end)


--[[Plays door sound

	Parameter(s):
		DoorSound => target door's sound
		doorSoundID => sound ID for creating a door sound
]]
script['Play Door Sound'].Event:Connect(function(DoorSound: Sound, doorSoundID: number)
	DoorSound.SoundId = 'rbxassetid://'..doorSoundID
	DoorSound:Play()
end)