--Roblox Services
ReplicatedStorage = game.ReplicatedStorage
ServerStorage = game.ServerStorage
MarketplaceService = game:GetService('MarketplaceService')
FormatNumberToTime = game.ServerScriptService:FindFirstChild('Other Modules'):FindFirstChild('Format Number to Time')

--Playlist
Playlist = script.Parent
SoundtrackGenre = Playlist:FindFirstChild('Configuration'):FindFirstChild('Soundtrack Genre').Value
Soundtracks = Playlist:FindFirstChild('Soundtrack List'):FindFirstChild(SoundtrackGenre):GetChildren()

--Current Song Info
currentSongName = nil
currentSongCreator = nil

--Events and Functions for updating song's attributes
UpdateTimePosition = ReplicatedStorage:FindFirstChild('Update Song Time Position')
UpdateName = ReplicatedStorage:FindFirstChild('Update Song Name')
UpdateTimeLength = ReplicatedStorage:FindFirstChild('Update Song Length')
UpdateCreator = ReplicatedStorage:FindFirstChild('Update Song Creator')
UpdateProgressBar = ReplicatedStorage:FindFirstChild('Update Song Progress Bar')

--Gets the current song name to allow other scripts to use it
ServerStorage:FindFirstChild('Get Current Song Name').OnInvoke = function()
	while not currentSongName do wait(.1) end
	return currentSongName
end



--Gets the current song name to allow other scripts to use it
ServerStorage:FindFirstChild('Get Current Song Creator').OnInvoke = function()
	while not currentSongCreator do wait(.1) end
	return currentSongCreator
end



--[[Gives song time to load and determines if the song can play

	Return(s):
		boolean: flag of song validation
]]
function canPlaySong() : boolean
	
	local maxTime = 5 -- max time of song loading
	local startTime = tick() -- start time song loading
	
	repeat
		task.wait(.1)
		local loadTime = tick() - startTime -- current loading time
		--print('Song load time: '..loadTime)
	until Playlist.IsLoaded or loadTime > maxTime
	
	return Playlist.IsLoaded
end


--[[Initializes some parts of Song UI before the song starts playing

	Parameter(s):
		song: song object including its name and assetID
		timeLength: time length of the song
]]
function initializeUI(song: IntValue, timeLength: number)
	--print('Initializing UI for new song')
	UpdateName:FireAllClients(song.Name)
	UpdateCreator:FireAllClients(currentSongCreator)
	UpdateTimeLength:FireAllClients(FormatNumberToTime:Invoke(timeLength))
	UpdateTimePosition:FireAllClients('0:00')
	UpdateProgressBar:FireAllClients(0, timeLength)
end



--[[Plays a new song

	Parameter(s):
		song: song object including its name and assetID
		timePosition: time position of the song
		timeLength: time length of the song
]]
function playSong(song: IntValue, timePosition: number, timeLength: number)
	
	Playlist:Play()
	--print('Now playing '.."'"..song.Name.."'")
	while timePosition < timeLength do
		wait(1)
		timePosition += 1		
		UpdateTimePosition:FireAllClients(FormatNumberToTime:Invoke(timePosition))
		UpdateProgressBar:FireAllClients(timePosition, timeLength)
	end
end



--Indefinitely selects a random song to play
while true do
		
	--Randomly selects a song (soundtrack)
	local song = Soundtracks[math.random(#Soundtracks)]
	Playlist.SoundId = "rbxassetid://"..song.Value
	--print("Loading '"..song.Name.."'")
		
	if canPlaySong() then
		
		--Gets the name of the artist of the current song or the creator of it
		--local Artist = song:GetAttribute('Artist')

		--Sets the artist's name on Song Dashboard UI (if no artist is mentioned, use the creator's instead)	
		--if Artist then
		--	currentSongCreator = Artist
		--else
		currentSongCreator = MarketplaceService:GetProductInfo(song.Value).Creator.Name
		--end
		
		--Sets new time position and length of the song
		--while Playlist.TimeLength == 0 do wait(.1) end
		local timePosition = 0
		local timeLength = math.ceil(Playlist.TimeLength)
		--if Playlist.TimePosition ~= 0 then Playlist.TimePosition = 0 end --in case time position isn't zero
		
		initializeUI(song, timeLength)
		playSong(song, timePosition, timeLength)
	end
end