local StringAnalyses = {}

--[[Counts all occurrences of a specified substring

	Parameters:
		str: string
		subStr: target substring
		
	Returns:
		number: number of occurrences of a substring
]]
function StringAnalyses.countSubstring(str: string, subStr: string) : number
	
	local n, m = #str, #subStr
	
	if m > n then return 0 end
	if str == subStr then return 1 end

	local res = 0
	
	for i = 1, n do
		for j = i, n do
			if string.sub(str, i, j) == subStr then
				res += 1
			end
		end
	end
	
	return res
end



--[[Creates and returns a table of all words and their occurrences.

	Parameters:
		str: string
		
	Returns:
		table: table of words and their occurrences
]]
function StringAnalyses.createWordCounts(str: string) : {[string] : number}
	
	local res = {}
	
	for _, word in ipairs(string.split(str, ' ')) do
		res[word] = (res[word] and res[word]+1) or 1
	end
	
	return res
end



--[[Checks of a specified substring exists in a string

	Parameters:
		str: string
		subStr: target substring
		
	Returns:
		boolean: specified substring exists in a string. False, otherwise.
]]
function StringAnalyses.exists(str: string, subStr: string) : boolean
	
	local n, m = #str, #subStr

	if str == subStr then return true end
	if m > n then return false end

	for i = 1, n do
		for j = i, n do
			if string.sub(str, i, j) == subStr then
				return true
			end
		end
	end

	return false
end



--[[Gets all substrings from a string

	Parameters:
		str: string
		compressed: removes duplicated substrings (optional)
		
	Returns:
		{string}: table of substrings from a string
]]
function StringAnalyses.getAllSubstrings(str: string, compressed: boolean?) : {string}
	
	local n = #str
	local res = {}

	for i = 1, n do
		for j = i, n do
			local subStr = string.sub(str, i, j)
			if (compressed and not table.find(res, subStr)) or not compressed then
				table.insert(res, subStr)
			end
		end
	end
	
	return res
end


return StringAnalyses