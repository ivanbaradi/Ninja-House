--Button
local Button = script.Parent
--Game UI
local GameUI = Button.Parent
--Button colors
local default = Color3.fromRGB(94, 94, 94)
local hovered = Color3.fromRGB(1, 25, 147)
--User Input Service
local UserInputService = game:GetService('UserInputService')


--Inputs this number to the 'User Answer' textbox
function handler()
	Button.BackgroundColor3 = default
	GameUI['User Answer'].Text = GameUI['User Answer'].Text..Button.Name
end

--Fires when the player presses the number button at the UI
Button.MouseButton1Click:Connect(handler)
--Fires when the player presses the number key button 
UserInputService.InputBegan:Connect(function(input)
	if GameUI.Visible and input.KeyCode == Enum.KeyCode.Zero then handler() end
end)



--Changes button color to blue when the mouse hovers the button
Button.MouseEnter:Connect(function()
	Button.BackgroundColor3 = hovered
end)



--Changes button color back to default when the mouse exits the button
Button.MouseLeave:Connect(function()
	Button.BackgroundColor3 = default
end)