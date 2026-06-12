-- Modules
local TimeConversions = {}


--[[Converts seconds to minutes and seconds time format (MM:SS)

	Parameter(s):
		secs => seconds 
	
	Return(s):
		string => converted minutes and seconds time format (MM:SS)

	Examples:
		30 => 0:30
		60 => 1:00
		130 => 2:10
]]
function TimeConversions.toTime(secs: number) : string
	
	-- Add minutes
	local res = math.floor(secs/60)..':'
	
	-- Add seconds (now ranges from 0 to 59 seconds)
	secs %= 60
	return (secs >= 10 and res..secs) or res..'0'..secs
end



--[[Converts the time from 24HR to 12HR format

	Parameter(s):
		_24Hr: 24HR time format

	Return(s):
		string: converted 12HR time format (HH:MM meridiem)

	Example(s): 
		00:00 => 12:00AM
		07:00 => 7:00AM
		12:30 => 12:30PM
		13:15 => 3:15PM
]]
function TimeConversions.to12Hr(_24Hr: string) : string
	
	-- Gets hour and minute marks from 24HR format
	local oldHr = tonumber(string.sub(_24Hr, 1, 2))
	local min = tonumber(string.sub(_24Hr, 4, 5))
	min = (min < 10 and '0'..min) or min
	
	-- Configures meridiem
	local meridiem = (oldHr >= 0 and oldHr < 12 and 'AM') or 'PM'
	
	-- Configures hour mark from 12HR format
	local newHr = ((oldHr == 0 or oldHr == 12) and 12) or oldHr % 12
	return string.format('%s:%s %s', newHr, min, meridiem)
end



--[[Converts the time from 12HR to 24HR format

	Parameter(s):
		_12Hr: 12HR time format

	Return(s):
		string: converted 24HR time format (HH:MM)

	Example(s): 
		12:00AM => 00:00
		7:00AM => 07:00
		12:30PM => 12:30
		3:15PM => 13:15
]]
function TimeConversions.to24Hr(_12Hr: string) : string
		
	-- Gets hour mark from 24HR format
	local meridiem = string.sub(_12Hr, -2)
	local hrIsTwoDigit = #_12Hr == 7
	local oldHr = tonumber(string.sub(_12Hr, 1, (hrIsTwoDigit and 2) or 1))
	local newHr = (meridiem == 'PM' and oldHr ~= 12 and oldHr+12) or (meridiem == 'AM' and oldHr == 12 and '00') or oldHr
	
	-- Gets minute mark from 12HR format
	local start = (hrIsTwoDigit and 4) or 3 
	local min = string.sub(_12Hr, start, start+1)
	
	return string.format('%s:%s', newHr, min)
end


--[[Converts number of days to weeks

	Parameter(s):
		days: number of days
		
	Return(s):
		number: number of weeks based on conversion
]]
function TimeConversions.toWeeks(days: number) : number
	return math.floor(days/7)
end



--[[Converts number of days to years

	Parameter(s):
		days: number of days
		
	Return(s):
		number: number of years based on conversion
]]
function TimeConversions.toYears(days: number) : number
	return math.floor(days/365)
end


return TimeConversions