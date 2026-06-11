local NumberTransformations = {}

--[[Inserts commas to the number

	Parameter(s):
		number: number with or without decimal point
		precision: representation of how decimal values are expressed (optional)
	
	Return(s):
		string: number with commas
		
	Example(s):
		10 => 10
		1000 => 1,000
	   -20000 => -20,000
		500000.35 => 500,000.35
]]
function NumberTransformations.insertCommas(num: number, precision: string?) : string
	
	-- Converts number to string
	local numStr = (precision and string.format(precision, num)) or tostring(num)
	
	-- Exits if number is a 3-digit or less value
	local isNegative = num < 0
	if (isNegative and #numStr < 5) or #numStr < 4 then return numStr end
	
	-- Searches for decimal point from the number
	local decimalIndex = string.find(numStr, '%.')
	
	-- Initializes start and stop indices for inserting commas
	local start = (decimalIndex and decimalIndex-1) or #numStr
	local stop = (isNegative and 3) or 2
	local counter = 1 -- used for adding commas
	
	-- Iterates reversely to add commas between values
	for i = start, stop, -1 do
		if counter % 3 == 0 then 
			numStr = string.sub(numStr, 1, i-1)..','..string.sub(numStr, i)
		end

		counter += 1
	end 
	
	return numStr
end

return NumberTransformations