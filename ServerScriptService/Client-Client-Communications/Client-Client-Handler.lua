--[[Client-to-Client Communications enables the interactions between 
	the client, server, and another client.]]

-- Roblox Services
local ReplicatedStorage = game.ReplicatedStorage

-- Client to Client Communications Systems
local ClientClientEvent = ReplicatedStorage['Client-Client Communications']
local ClientClientFunction = ReplicatedStorage['Client-Client Communications 2']


--[[Handles a one-way passage between the client, server, and another client.

	Parameter(s):
		player => player who triggered this event 
		remoteEventName => name of the remote event to trigger
		object => any data (optional)
		folderName => folder's name from ReplicatedStorage where the Remote Event is at (optional)
]]
ClientClientEvent.OnServerEvent:Connect(function(player: Player, remoteEventName: string, object: any?, folderName: string?)	
	local Location = (folderName and ReplicatedStorage[folderName]) or ReplicatedStorage
	Location[remoteEventName]:FireClient(player, object)
end)



--[[Handles a two-way passage between the client, server, and another client.
	In most cases, the client that invokes the server expects a return of some
	data from another client invoked by the server unless it's a void function.

	Parameter(s):
		player => player who invoked this function 
		remoteFuncName => name of the remote function to invoke
		object => any data (optional)
		folderName => folder's name from ReplicatedStorage where the Remote Event is at (optional)
]]
ClientClientFunction.OnServerInvoke = function(player: Player, remoteFuncName: string, object: any?, folderName: string?)
	local Location = (folderName and ReplicatedStorage[folderName]) or ReplicatedStorage
	return Location[remoteFuncName]:InvokeClient(player, object)	
end