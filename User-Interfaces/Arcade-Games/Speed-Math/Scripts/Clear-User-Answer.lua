--UserInputService
local UserInputService = game:GetService('UserInputService')
--Button
local Button = script.Parent
--Game UI
local GameUI = Button.Parent
--Button colors
local default = Color3.fromRGB(94, 94, 94)
local hovered = Color3.fromRGB(1, 25, 147)



--Inputs this number to the 'User Answer' textbox
function handler()
	Button.BackgroundColor3 = default
	GameUI['User Answer'].Text = ''
end

--Fires when the player pressed the 'C' button from the Game UI
Button.MouseButton1Click:Connect(handler)
--Fires when the player pressed the 'C' key button
UserInputService.InputBegan:Connect(function(input)
	if GameUI.Visible and (input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.Delete) then handler() end
end)



--Changes button color to blue when the mouse hovers the button
Button.MouseEnter:Connect(function()
	Button.BackgroundColor3 = hovered
end)



--Changes button color back to default when the mouse exits the button
Button.MouseLeave:Connect(function()
	Button.BackgroundColor3 = default
end)