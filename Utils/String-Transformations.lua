local StringTransformations = {}

--[[Formats string by captilazing first character and
	the rest is lowercased

	Parameter(s):
		str: target string
		sep: separator (optional)
	Return(s):
		string: proper string
]]
function StringTransformations.toProper(str: string, sep: string?) : string
	
	local strs = (sep and string.split(str, sep)) or {str}
	local res = ''
	
	for i, temp in ipairs(strs) do
		res = res..string.upper(string.sub(temp, 1, 1))..string.lower(string.sub(temp, 2))..((i < #strs and sep) or '')
	end
	
	return res
end



--[[Removes leading spaces from a string

	Parameter(s):
		str: target string

	Return(s):
		string: string without leading spaces
]]
function StringTransformations.leftTrim(str: string) : string
		
	local i = 1
	
	while i <= #str do
		if string.sub(str, i, i) ~= " " then break end
		i += 1
	end
		
	return string.sub(str, i)
end



--[[Removes trailing spaces from a string

	Parameter(s):
		str: target string

	Return(s):
		string: string without trailing spaces
]]
function StringTransformations.rightTrim(str: string) : string

	local i = #str

	while i >= 1 do
		if string.sub(str, i, i) ~= " " then break end
		i -= 1
	end

	return string.sub(str, 1, i)
end



--[[Removes both leading and trailing spaces from a string

	Parameter(s):
		str: target string

	Return(s):
		string: string without leading and trailing spaces
]]
function StringTransformations.trim(str: string) : string
	return StringTransformations.leftTrim(StringTransformations.rightTrim(str))
end



--[[Replaces a character from a string and returns it
	as a modified string

	Parameter(s):
		i: index of a character for replacing a character
		str: target string
		ch: character that replaces the old character
	
	Returns(s):
		string => string modified by replacing a character
]]
function StringTransformations.replaceChar(i: number, str: string, ch: string) : string
	return string.sub(str, 1, i-1)..ch..string.sub(str, i+1)
end



return StringTransformations