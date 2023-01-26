--[[Client-to-Client Communications enables the interactions between 
	the client, server, and another client 
]]

--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Client to Client Communications (Remote Event)
local Client_Client_EVENT = ReplicatedStorage:FindFirstChild('Client-Client Communications')
--Client to Client Communications (Remote Function)
local Client_Client_FUNC = ReplicatedStorage:FindFirstChild('Client-Client Communications 2')



--[[Handles a one-way passage between the client, server, and another client

	Parameter(s):
	player => player who triggered this event (Player)
	remoteEventName => name of the remote event to trigger (string)
	object => collection of data (table)
]]
Client_Client_EVENT.OnServerEvent:Connect(function(player, remoteEventName, object)
	ReplicatedStorage:FindFirstChild(remoteEventName):FireClient(player, object)
end)



--[[Handles a two-way passage between the client, server, and another client.
	In most cases, the client that invokes the server expects a return of some
	data from another client invoked by the server

	Parameter(s):
	player => player who invoked this function (Player)
	remoteFuncName => name of the remote function to invoke (string)
	object => collection of data (table)
]]
Client_Client_FUNC.OnServerInvoke = function(player, remoteFuncName, object)
	return ReplicatedStorage:FindFirstChild(remoteFuncName):InvokeClient(player, object)
end