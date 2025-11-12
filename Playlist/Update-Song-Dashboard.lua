--Roblox Services
ReplicatedStorage = game.ReplicatedStorage

--Song UI DashBoard
Dashboard = script.Parent

--Song UI RemoteEvents
updateSongNameEvent = ReplicatedStorage:WaitForChild('Update Song Name')
updateSongCreatorEvent = ReplicatedStorage:WaitForChild('Update Song Creator')
updateSongLengthEvent = ReplicatedStorage:WaitForChild('Update Song Length')
updateSongTimePosEvent = ReplicatedStorage:WaitForChild('Update Song Time Position')
updateSongProgBarEvent = ReplicatedStorage:WaitForChild('Update Song Progress Bar')



--[[Updates the name of the song whenever the
	song changes

	Parameter(s):
	songName => name of the song 
]]
function updateSongName(songName: string)
	Dashboard:WaitForChild('Song Name').Text = songName
end



--[[Updates the creator of the song whenever the
	song changes

	Parameter(s):
	songCreator => creator of the song 
]]
function updateSongCreator(songCreator: string)
	Dashboard:WaitForChild('Song Creator').Text = songCreator
end



--[[Updates the length of the song whenever the
	song changes

	Parameter(s):
	songLength => length of the song 
]]
function updateSongLength(songLength: string)
	Dashboard:WaitForChild('Song Length').Text = songLength
end



--[[Updates the time position of the song 
	whenever the song changes

	Parameter(s):
	songTimePosition => current time position of the song 
]]
function updateSongTimePos(songTimePosition: string)
	Dashboard:WaitForChild('Song Time Position').Text = songTimePosition
end



--[[Updates the song progress bar state
	whenever the song changes

	Parameter(s):
	timer => current time of the song in seconds 
	songLength => length of the song in seconds 
]]
function updateSongProgressBar(timer: number, songLength: number)
	Dashboard:WaitForChild('Song Progress Bar'):WaitForChild('Progress').Size = UDim2.fromScale(timer / songLength, 1)
end

--Triggers when a song has changed
updateSongNameEvent.OnClientEvent:Connect(updateSongName)
updateSongCreatorEvent.OnClientEvent:Connect(updateSongCreator)
updateSongLengthEvent.OnClientEvent:Connect(updateSongLength)
updateSongTimePosEvent.OnClientEvent:Connect(updateSongTimePos)
updateSongProgBarEvent.OnClientEvent:Connect(updateSongProgressBar)

--Will need to update some parts of Song UI when client joins the game
ReplicatedStorage:FindFirstChild('Initialize UI on Join'):FireServer()