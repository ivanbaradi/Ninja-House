local NumberTransformations = {}

--[[Adds commas to the number

	Parameter(s):
		number => value that needs commas and greater than
	
	Return(s):
		string => number with commas
]]
function NumberTransformations.addCommasToNumber(number: number) : string

	--No commas needed if -1,000 < number < 1,000
	if number > -1000 and number < 1000 then return number end

	--Number with commas (String)
	local formattedNumber = tostring(number)
	--Counter (when to place commas)
	local counter = 1
	--End Index (Stops at the second leftest digit)
	local endIndex = 2
	if number < 0 then endIndex = 3 end

	--Reversely loops through a number (String)
	for i = string.len(formattedNumber), endIndex, -1 do

		--Adds comma
		if counter % 3 == 0 then 
			formattedNumber = string.sub(formattedNumber, 1, i-1)..','..string.sub(formattedNumber, i)
		end

		counter += 1
	end

	return formattedNumber
end

--[[Adds commas to floating-point values

	Parameter(s):
		num => floating-point number to add commas too
		precision => values to add after the decimal point
	
	Return(s):
		string => floating-point number with commas
]]
function NumberTransformations.addCommasToFloats(num : number, precision: string) : string

	--Formats the string to include values after decimal
	local formattedStr = string.format(precision, num)
	--Index to the last value
	local i = string.len(formattedStr)

	--Reversely loops values until it references a period
	while string.sub(formattedStr, i, i) ~= '.' do i -= 1 end

	return NumberTransformations.addCommasToNumber(tonumber(string.sub(formattedStr, 1, i-1)))..string.sub(formattedStr, i)
end

return NumberTransformations
