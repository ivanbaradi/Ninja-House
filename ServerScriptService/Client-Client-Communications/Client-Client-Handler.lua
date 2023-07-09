--[[Client-to-Client Communications enables the interactions between 
	the client, server, and another client 
]]

--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Client to Client Communications (Remote Event)
local Client_Client_EVENT = ReplicatedStorage:FindFirstChild('Client-Client Communications')
--Client to Client Communications (Remote Function)
local Client_Client_FUNC = ReplicatedStorage:FindFirstChild('Client-Client Communications 2')



--[[Handles a one-way passage between the client, server, and another client.
	
	If object is nil, then this server event will only pass the Player
	object as the parameter. In other word, no object is passed.

	Parameter(s):
	player => player who triggered this event (Player)
	remoteEventName => name of the remote event to trigger (string)
	object => any data
]]
Client_Client_EVENT.OnServerEvent:Connect(function(player, remoteEventName, object)
	
	local TargetRemoteEvent = ReplicatedStorage:FindFirstChild(remoteEventName)
	
	if object ~= nil then
		TargetRemoteEvent:FireClient(player, object)
	else
		TargetRemoteEvent:FireClient(player)
	end
end)



--[[Handles a two-way passage between the client, server, and another client.
	In most cases, the client that invokes the server expects a return of some
	data from another client invoked by the server.
	
	If object is nil, then this server invoke will only pass the Player
	object as the parameter. In other word, no object is passed.

	Parameter(s):
	player => player who invoked this function (Player)
	remoteFuncName => name of the remote function to invoke (string)
	object => any data
]]
Client_Client_FUNC.OnServerInvoke = function(player, remoteFuncName, object)
	
	local TargetRemoteFunction = ReplicatedStorage:FindFirstChild(remoteFuncName)
	
	if object ~= nil then return TargetRemoteFunction:InvokeClient(player, object) end
	
	return TargetRemoteFunction:InvokeClient(player)
end