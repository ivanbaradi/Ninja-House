# 🎵 Playlist

Playlist plays background music in a Roblox game.

## 🗺️ Explorer
```text
🗺️ Explorer
├── 🌎 Workspace
│   └── 🔊 Playlist
│       ├── 📁 Soundtrack List
│       │   ├── 📁 Original
│       │   │   └── #️⃣ ...list of songs
│       │   └── 📁 ...other genres
│       ├── 📝 Run Playlist
│       │   └── 📝 Playlist Modules
│       │       ├── 🧱 Can Play Song
│       │       ├── 🧱 Play Song
│       │       └── ⚡️ Initialize Song UI
│       └── ⚙️ Configuration
│           └── #️⃣ Soundtrack Genre
└── 🖥️ Song Dashboard UI
    └── 🖼️ Dashboard
        ├── 🏷️ Song Creator      
        ├── 🏷️ Song Length
        ├── 🏷️ Song Name
        ├── 🏷️ Song Time Position
        ├── 🖼️ Outline
        ├── 🖼️ Song Progress Bar
        └── 👨‍💻 Update Song Dashboard
```

## 📝 Run Playlist
```lua
while true do
	Song = Soundtracks[math.random(#Soundtracks)]
	Playlist.SoundId = "rbxassetid://"..Song.Value
		
	if canPlaySong:Invoke() then
		SongCreator = MarketplaceService:GetProductInfoAsync(Song.Value).Creator.Name
		timePosition = 0
		timeLength = math.ceil(Playlist.TimeLength)
		initializeSongUI:Fire(Song, timeLength, SongCreator)
		playSong:Invoke(timePosition, timeLength)
	end
end
```

This snippet from **Run Playlist** randomly selects a song to play from a configured soundtrack genre, which then updates all clients' song dashboards. Unplayable songs are skipped. 

Keep in mind that this script runs in the server rather than client meaning that every player will hear the same song within the same time position.

## 🤔 How Songs are Stored

All songs are stored as `IntValue` objects, which  store integers as values. In Roblox, each song includes a SoundId. In this case, every `IntValue` holds SoundID for the **Run Playlist** to fetch information about the song including its creator, update UI, and  play it on the background.  