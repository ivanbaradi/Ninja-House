--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Sound Effects
local SoundEffects = workspace:FindFirstChild('Sound Effects')
local MessageSoundEffect = SoundEffects:FindFirstChild('Message')
local OtherSoundEffect = SoundEffects:FindFirstChild('Others')
--Player Settings
local PlayerSettings = ReplicatedStorage:FindFirstChild('Player Settings')
local CanPlaySoundEffects = PlayerSettings:FindFirstChild('Can Play Sound Effects')
local CanPlayMessageSounds = PlayerSettings:FindFirstChild('Can Play Message Sounds')


--[[ Plays sound effect on the client's side

	Parameter(s):
		soundEffect => {
			name (string) => name of the sound effect, 
			volume (number) => volume of the sound effect
		}
]]
ReplicatedStorage:FindFirstChild('Play Sound Effect').OnClientEvent:Connect(function(soundEffect: {name: string, volume: number})
	
	--Sound Effect from any sound effects folder
	local SoundEffect = nil
	
	--Checks if the sound effect is a "Message" type and that player's "Message Sound" option is turned off
	if MessageSoundEffect:FindFirstChild(soundEffect.name) then
		if not CanPlayMessageSounds.Value then return end
		SoundEffect = MessageSoundEffect:FindFirstChild(soundEffect.name)

	else --Other sound effects
		if not CanPlaySoundEffects.Value then return end
		SoundEffect = OtherSoundEffect:FindFirstChild(soundEffect.name)
	end
	
	--Prevents another sound effect from playing if one is already playing
	if SoundEffects.IsPlaying then return end
	
	--Plays Sound Effect
	SoundEffects.SoundId = 'rbxassetid://'..SoundEffect.Value
	SoundEffects.Volume = soundEffect.volume
	SoundEffects:Play()
end)