--Roblox Services
ReplicatedStorage = game.ReplicatedStorage
ServerStorage = game.ServerStorage
MarketplaceService = game:GetService('MarketplaceService')

--Playlist
Playlist = script.Parent
SoundtrackGenre = Playlist:FindFirstChild('Configuration'):FindFirstChild('Soundtrack Genre').Value
Soundtracks = Playlist:FindFirstChild('Soundtrack List'):FindFirstChild(SoundtrackGenre):GetChildren()

--Playlist Modules
Modules = script:FindFirstChild('Playlist Modules')

--Current Song Info
currentSongName = nil
currentSongCreator = nil


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


--Indefinitely selects a random song to play
while true do
		
	--Randomly selects a song (soundtrack)
	local Song = Soundtracks[math.random(#Soundtracks)]
	Playlist.SoundId = "rbxassetid://"..Song.Value
	print("Loading '"..Song.Name.."'")
		
	if Modules:FindFirstChild('Can Play Song'):Invoke() then
		
		--Gets the name of the artist of the current song or the creator of it
		--local Artist = song:GetAttribute('Artist')

		--Sets the artist's name on Song Dashboard UI (if no artist is mentioned, use the creator's instead)	
		--if Artist then
		--	currentSongCreator = Artist
		--else
		currentSongCreator = MarketplaceService:GetProductInfo(Song.Value).Creator.Name
		--end
		
		--Sets new time position and length of the song
		--while Playlist.TimeLength == 0 do wait(.1) end
		local timePosition = 0
		local timeLength = math.ceil(Playlist.TimeLength)
		--if Playlist.TimePosition ~= 0 then Playlist.TimePosition = 0 end --in case time position isn't zero
		
		Modules:FindFirstChild('Initialize UI'):Fire(Song, timeLength, currentSongCreator)
		Modules:FindFirstChild('Play Song'):Invoke(timePosition, timeLength)
	end
end