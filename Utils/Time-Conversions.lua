-- Modules
local TimeConversions = {}


--[[Converts seconds the following time format, MM:SS (Formerly named FormatNumberToTime)

	Parameter(s):
		timer => time in secs 
	
	Return(s):
		formatted time => converted time in 'MM:SS' format

	Examples:
		30 seconds => 0:30
		105 seconds => 1:45
]]
function TimeConversions.toTime(timer: number) : string
	
	--[[Converts seconds to minutes and seconds
	
		Parameter(s):
			timer => number of secs
		
		Return(s):
			string => converted time
	]]
	local function convertSecsToMinsSecs(timer: number)
		--Minutes
		local minutes = math.floor(timer/60)
		--Seconds from 0 to 59
		local seconds = timer % 60

		if seconds >= 0 and seconds < 10 then
			return minutes..':0'..seconds
		end

		return minutes..':'..seconds
	end



	if timer >= 0 and timer < 10 then
		return '0:0'..timer
	elseif timer >= 10 and timer < 60 then
		return '0:'..timer
	end

	return convertSecsToMinsSecs(timer)
end



--[[Converts the time from 24HR to 12HR format

	Parameter(s):
		from24hr: 24HR time format

	Return(s):
		string: converted 12HR time format, HH:MM meridiem

	Example(s): 
		00:00 => 12:00AM
		07:00 => 7:00AM
		12:30 => 12:30PM
		13:15 => 3:15PM
]]
function TimeConversions.to12Hr(from24hr: string) : string
	
	-- Gets hour and minute marks from 24HR format
	local oldHr = tonumber(string.sub(from24hr, 1, 2))
	local min = tonumber(string.sub(from24hr, 4, 5))
	min = (min < 10 and '0'..min) or min
	
	-- Configures meridiem
	local isAM = oldHr >= 0 and oldHr < 12
	local meridiem = (isAM and 'AM') or 'PM'
	
	-- Configures hour mark from 12HR format
	local newHr = ((oldHr == 0 or oldHr == 12) and 12) or (isAM and oldHr) or oldHr-12
	return string.format('%s:%s%s', newHr, min, meridiem)
end



--[[Converts the time from 12HR to 24HR format

	Parameter(s):
		from12hr: 12HR time format

	Return(s):
		string: converted 24HR time format, HH:MM meridiem

	Example(s): 
		12:00AM => 00:00
		7:00AM => 07:00
		12:30PM => 12:30
		3:15PM => 13:15
]]
function TimeConversions.to24Hr(from12hr: string) : string
		
	-- Gets hour mark from 24HR format
	local meridiem = string.sub(from12hr, -2)
	local hrIsTwoDigit = string.len(from12hr) == 7
	local oldHr = tonumber(string.sub(from12hr, 1, (hrIsTwoDigit and 2) or 1))
	local newHr = (meridiem == 'PM' and oldHr ~= 12 and oldHr+12) or (meridiem == 'AM' and oldHr == 12 and '00') or oldHr
	
	-- Gets minute mark from 12HR format
	local start = (hrIsTwoDigit and 4) or 3 
	local min = string.sub(from12hr, (hrIsTwoDigit and 4) or 3, start+1)
	
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