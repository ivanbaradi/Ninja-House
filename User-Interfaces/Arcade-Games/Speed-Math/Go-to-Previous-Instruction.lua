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
--Speed Math UI
local SpeedMathUI = Instructions.Parent
--Configuration
local Configuration = SpeedMathUI.Configuration
local currentPages = Configuration['Current Instruction Page']



--Goes to the previous page of 'Instructions' UI
Button.MouseButton1Click:Connect(function()
	
	--Plays 'Button Clicked 2' sound effect
	CLIENT_CLIENT:FireServer('Play Sound Effect',{
		name = 'Button Clicked 2',
		volume = 1
	})
	
	--In case that this button's color does not return back to default
	Button.BackgroundColor3 = default
	
	--Takes player to the previous page from 'Instructions' UI
	Instructions['Page '..currentPages.Value].Visible = false
	currentPages.Value -= 1
	Instructions['Page '..currentPages.Value].Visible = true
	
	--Changes to 'Next' button assuming that player is not at the last page
	Instructions:FindFirstChild('Next/Play').TextLabel.Text = 'Next'
	
	--Hides 'Previous' button since player is at the first page
	if currentPages.Value == 1 then Button.Visible = false end
end)



--Changes button color to blue when the mouse hovers the button
Button.MouseEnter:Connect(function()
	Button.BackgroundColor3 = hovered
end)



--Changes button color back to default when the mouse exits the button
Button.MouseLeave:Connect(function()
	Button.BackgroundColor3 = default
end)
