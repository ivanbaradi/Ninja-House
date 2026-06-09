local StringTransformations = {}

--[[Replaces a character from a string and returns it
	as a modified string

	Parameter(s):
		i => index of a character for replacing a character
		str => string to modify
		ch => character that replaces the old character
	
	Returns(s):
		string => string modified by replacing a character
]]
function StringTransformations.replaceChar(i: number, str: string, ch: string) : string
	return str:sub(1,i-1)..ch..str:sub(i+1)
end

return StringTransformations
