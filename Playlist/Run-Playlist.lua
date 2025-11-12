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
initializeSongUI = Modules:FindFirstChild('Initialize Song UI')
playSong = Modules:FindFirstChild('Play Song')
canPlaySong = Modules:FindFirstChild('Can Play Song')

--Current Song Info
Song = nil
SongCreator = nil
timePosition = nil
timeLength = nil

--Will need to update some parts of Song UI when client joins the game
ReplicatedStorage:FindFirstChild('Initialize UI on Join').OnServerEvent:Connect(function(player: Player)
	repeat task.wait(.1) until Song and SongCreator and timeLength and timePosition
	initializeSongUI:Fire(Song, timeLength, SongCreator)
end)


--Selects a random song to play during runtime
while true do
		
	--Randomly selects a song (soundtrack)
	Song = Soundtracks[math.random(#Soundtracks)]
	Playlist.SoundId = "rbxassetid://"..Song.Value
	print("Loading '"..Song.Name.."'")
		
	if canPlaySong:Invoke() then
		
		--Gets the name of the artist of the current song or the creator of it
		--local Artist = song:GetAttribute('Artist')

		--Sets the artist's name on Song Dashboard UI (if no artist is mentioned, use the creator's instead)	
		--if Artist then
		--	SongCreator = Artist
		--else
		SongCreator = MarketplaceService:GetProductInfo(Song.Value).Creator.Name
		--end
		
		--Sets new time position and length of the song
		--while Playlist.TimeLength == 0 do wait(.1) end
		timePosition = 0
		timeLength = math.ceil(Playlist.TimeLength)
		--if Playlist.TimePosition ~= 0 then Playlist.TimePosition = 0 end --in case time position isn't zero
		
		initializeSongUI:Fire(Song, timeLength, SongCreator)
		playSong:Invoke(timePosition, timeLength)
	else
		print("'"..Song.Name.."' cannot be played.")
	end
end