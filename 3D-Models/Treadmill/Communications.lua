--ServerScriptService
local ServerScriptService = game.ServerScriptService
--'Format Number to Time' Event (Converts seconds to time in MM:SS format)
local FormatTime = ServerScriptService['Other Modules']['Format Number to Time']
--Treadmill
local Treadmill = script.Parent
--Properties
local Properties = Treadmill:FindFirstChild('Properties')
local Time = Properties:FindFirstChild('Time')
local Speed = Properties:FindFirstChild('Speed')
local Calories = Properties:FindFirstChild('Calories')
local Studs = Properties:FindFirstChild('Studs')
local TreadmillRunning = Properties:FindFirstChild('Treadmill is Running')
--Treadmill (Communications)
local TreadmillComms = Treadmill:FindFirstChild('Communications')
--Conveyor
local Conveyor = Treadmill:FindFirstChild('Conveyor')
--UIs from the dashboard
local TimeUI = Treadmill.Time.SurfaceGui.TextLabel
local SpeedUI = Treadmill.Speed.SurfaceGui.TextLabel
local CaloriesUI = Treadmill.Calories.SurfaceGui.TextLabel
local StudsUI = Treadmill.Studs.SurfaceGui.TextLabel
--Treadmill time and speed buttons
local IncreaseTimeButton = Treadmill:FindFirstChild('Increase Time Button')
local DecreaseTimeButton = Treadmill:FindFirstChild('Decrease Time Button')
local IncreaseSpeedButton = Treadmill:FindFirstChild('Increase Speed Button')
local DecreaseSpeedButton = Treadmill:FindFirstChild('Decrease Speed Button')
--Power Button
local PowerButton = Treadmill:FindFirstChild('Power Button')



--[[Sets MaxActivationDistances for both time
	and speed buttons

	Parameter(s):
	a = MaxActivationDistance for 'Increase Time' Button
	b = MaxActivationDistance for 'Decrease Time' Button
	c = MaxActivationDistance for 'Increase Speed' Button
	d = MaxActivationDistance for 'Decrease Speed' Button
]]
function setMaxActivationDistances(a,b,c,d)
	IncreaseTimeButton.ClickDetector.MaxActivationDistance = a
	DecreaseTimeButton.ClickDetector.MaxActivationDistance = b
	IncreaseSpeedButton.ClickDetector.MaxActivationDistance = c
	DecreaseSpeedButton.ClickDetector.MaxActivationDistance = d
end



--Powers off the treadmill
function powerOffTreadmill()
	
	--Disables power button
	PowerButton.ClickDetector.MaxActivationDistance = 0
	
	--Allows players to view stats for 10 seconds before powering off the treadmill
	setMaxActivationDistances(0,0,0,0)
	Speed.Value = 0.0
	wait(10)
	
	--In case the player didn't manually power off the treadmill
	TreadmillRunning.Value = false

	--Reverts speed, calories, and studs to 0 and displays it on the dashboard
	SpeedUI.Text = string.format('%.1f',Speed.Value)
	Calories.Value = 0.0
	CaloriesUI.Text = string.format('%.1f',Calories.Value)
	Studs.Value = 0.0
	StudsUI.Text = string.format('%.1f',Studs.Value)

	--Reverts time to 10 minutes (600 seconds) and displays it on the dashboard
	Time.Value = 600
	TimeUI.Text = FormatTime:Invoke(Time.Value)
	
	--Disables speed buttons and enables time buttons
	setMaxActivationDistances(20,20,0,0)
	
	--Enables power button
	PowerButton.ClickDetector.MaxActivationDistance = 20
	PowerButton.BrickColor = BrickColor.new('Lime green')
end


--Powers on the treadmill
TreadmillComms:FindFirstChild('Power On Treadmill').Event:Connect(function()
	
	print('Treadmill has started!')
	

	--Sets the speed value of the conveyor to 1.0 and displays it on the dashboard
	Speed.Value = 1.0
	SpeedUI.Text = string.format('%.1f',Speed.Value)
	
	--Disables time buttons and enables speed buttons
	setMaxActivationDistances(0,0,20,20)
		
	--Powers up the conveyor of the treadmill
	Conveyor.AssemblyLinearVelocity = Conveyor.CFrame.LookVector * 1
	
	--Runs the treadmill until time has expires
	while TreadmillRunning.Value and Time.Value > 0 do
		wait(1)
		Time.Value -= 1
		TimeUI.Text = FormatTime:Invoke(Time.Value)
	end
	
	print('Conveyor stopped!')
	
	--Powers off the treadmill after time expires
	Conveyor.AssemblyLinearVelocity = Conveyor.CFrame.LookVector * 0
	powerOffTreadmill()

	print('Treadmill has ended!')
end)