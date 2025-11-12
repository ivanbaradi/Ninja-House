--Roblox Services
ReplicatedStorage = game.ReplicatedStorage
FormatNumberToTime = game.ServerScriptService:FindFirstChild('Other Modules'):FindFirstChild('Format Number to Time')

--Playlist
Playlist = script:FindFirstAncestor('Playlist')

--Events and Functions for updating song's attributes
UpdateName = ReplicatedStorage:FindFirstChild('Update Song Name')
UpdateTimePosition = ReplicatedStorage:FindFirstChild('Update Song Time Position')
UpdateProgressBar = ReplicatedStorage:FindFirstChild('Update Song Progress Bar')
UpdateCreator = ReplicatedStorage:FindFirstChild('Update Song Creator')
UpdateTimeLength = ReplicatedStorage:FindFirstChild('Update Song Length')


--[[Gives song time to load and determines if the song can play

	Return(s):
		boolean: flag of song validation
]]
script:FindFirstChild('Can Play Song').OnInvoke = function() : boolean
	local maxTime = 5 -- max time of song loading
	local startTime = tick() -- start time song loading

	repeat
		task.wait(.1)
		local loadTime = tick() - startTime -- current loading time
		--print('Song load time: '..loadTime)
	until Playlist.IsLoaded or loadTime > maxTime

	return Playlist.IsLoaded
end


--[[Plays a new song

	Parameter(s):
		timePosition: time position of the song
		timeLength: time length of the song
]]
script:FindFirstChild('Play Song').OnInvoke = function(timePosition: number, timeLength: number)
	
	local SoundId = Playlist.SoundId -- previous SoundId
	Playlist:Play()
	
	while timePosition < timeLength do
		
		wait(1)
		
		--Terminates because the song has abruptly changed
		if SoundId ~= Playlist.SoundId then return end
		
		timePosition += 1		
		UpdateTimePosition:FireAllClients(FormatNumberToTime:Invoke(timePosition))
		UpdateProgressBar:FireAllClients(timePosition, timeLength)
	end
end



--[[Initializes some parts of Song UI before the song starts playing

	TODO: Fix where UI gets updated when server starts

	Parameter(s):
		Song: song object including its name and assetID
		timeLength: time length of the song
		songCreator: song creator's name
]]
script:FindFirstChild('Initialize Song UI').Event:Connect(function(Song: IntValue, timeLength: number, songCreator: string)
	--print("Initializing UI for '"..song.Name)
	UpdateName:FireAllClients(Song.Name)
	UpdateCreator:FireAllClients(songCreator)
	UpdateTimeLength:FireAllClients(FormatNumberToTime:Invoke(timeLength))
	UpdateTimePosition:FireAllClients('0:00')
	UpdateProgressBar:FireAllClients(0, timeLength)
end)