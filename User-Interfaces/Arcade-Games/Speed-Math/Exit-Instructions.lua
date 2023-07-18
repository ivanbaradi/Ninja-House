--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Client-Client Communications
local CLIENT_CLIENT = ReplicatedStorage:FindFirstChild('Client-Client Communications')
--Button
local Button = script.Parent
--Button colors
local default = Color3.fromRGB(94, 94, 94)
local hovered = Color3.fromRGB(1, 25, 147)
--Instructions UI
local Instructions = Button.Parent
--Speed Game UI
local SpeedGameUI = Instructions.Parent
--Configuration
local Configuration = SpeedGameUI.Configuration
local currentPage = Configuration['Current Instruction Page']
local totalPages = Configuration['Total Instruction Pages']


--Directs player back to the main menu
Button.MouseButton1Click:Connect(function()
	
	--Plays 'Button Clicked 2' sound effect
	CLIENT_CLIENT:FireServer('Play Sound Effect',{
		name = 'Button Clicked 2',
		volume = 1
	})
	
	--In case that this button's color does not return back to default
	Button.BackgroundColor3 = default

	Instructions.Visible = false
	Instructions.Parent.Menu.Visible = true
	
	--Restores 'Instructions' UI
	CLIENT_CLIENT:FireServer('Speed Math - Restore Instructions', nil)
	
end)



--Changes button color to blue when the mouse hovers the button
Button.MouseEnter:Connect(function()
	Button.BackgroundColor3 = hovered
end)



--Changes button color back to default when the mouse exits the button
Button.MouseLeave:Connect(function()
	Button.BackgroundColor3 = default
end)
