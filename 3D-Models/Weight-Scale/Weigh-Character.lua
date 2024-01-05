--ServerStorage
local ServerStorage = game.ServerStorage
--ReplicatedStorage
local ReplicatedStorage = game.ReplicatedStorage
--Communications (Game Owner Settings)
local Communications = ReplicatedStorage:FindFirstChild('Game Owner Settings'):FindFirstChild('Communications')
--Players
local Players = game:GetService('Players')
--Add Commas to Float BindableFunction
local AddCommasToFloat = ServerStorage:FindFirstChild('Add Commas to Floats')
--Debouncer (prevents unneccesary event firings)
local debounce = false
--Base 
local Base = script.Parent
--Weight Scale
local WeightScale = Base.Parent
--Configuration
local Configuration = WeightScale:FindFirstChild('Configuration')
local Blinks = Configuration:FindFirstChild('Blinks')
local DisplayTime = Configuration:FindFirstChild('Display Time')
local Multiplier = Configuration:FindFirstChild('Multiplier')
--Power Button
local PowerButton = WeightScale:FindFirstChild('Power Button')
--Unit Button
local UnitButton = WeightScale:FindFirstChild('Unit Button')
--Screen
local SurfaceGui = WeightScale.Screen.SurfaceGui
local ScreenWeight = SurfaceGui.Weight
local ScreenUnit = SurfaceGui.Unit



--[[Sets visibilities of 'Weight' and 'Unit' texts

	Parameter(s):
	a => {true: Weight text is visible; false: Weight text is invisible} (boolean)
	b => {true: Unit text is visible; false: Unit text is invisible} (boolean)
]]
function setTextVisibilities(a, b)
	ScreenWeight.Visible = a
	ScreenUnit.Visible = b
end

--[[Sets MaxActivationDistances from 'Power' and
	'Unit' buttons

	Parmeter(s):
	a => new MaxActivationDistance for 'Power' button (int)
	b => new MaxActivationDistance for 'Unit' button (int)
]]
function setMaxActivationDistance(a, b)
	PowerButton.ClickDetector.MaxActivationDistance = a
	UnitButton.ClickDetector.MaxActivationDistance = b
end



--[[Measures Roblox character's weight

	Parameter(s):
	char => player's character who stepped on the scale (Character)
	
	Return(s)
	totalWeight => sum of weight of all character's body parts in pounds or kilograms (float)
]]
function getCharacterWeight(char)
	
	--Sum of weight of all character's body parts in pounds
	local totalWeight = 0
	
	--Sums all body parts by adding XYZ body parts
	for _, obj in pairs(char:GetChildren()) do
		if obj:IsA('MeshPart') or obj:IsA('Part') then
			totalWeight += (obj.Size.X + obj.Size.Y + obj.Size.Z)
		end
	end
	
	--Converts weight to kilograms and returns it
	if ScreenUnit.Text == 'KG' then
		return AddCommasToFloat:Invoke(nil, (totalWeight * Multiplier.Value) / 2.205, '%.1f')
	end
	
	--Returns the weight in pounds
	return AddCommasToFloat:Invoke(nil, totalWeight * Multiplier.Value, '%.1f')
end



--Weighs the character if the player steps on the base
Base.Touched:Connect(function(part)
	
	if debounce then return end
	
	debounce = true
	
	--Player's character
	local character = part:FindFirstAncestorOfClass('Model')
	--Gets character's humanoid
	local Humanoid = character:FindFirstChild('Humanoid')
	
	--Changes weight on the screen
	if Humanoid then
		if Humanoid.Health > 0 then
			if Communications:FindFirstChild('Players Can Home Accessories'):Invoke(Players:GetPlayerFromCharacter(character)) then
				if PowerButton.BrickColor == BrickColor.new('Lime green') then
					print('Now weighing '..character.Name)
					setMaxActivationDistance(0,0)

					--Blinks the Weight Label
					for i = 1, Blinks.Value, 1 do
						
						setTextVisibilities(false, false)
						wait(.5)

						--Displays current weight of a Roblox character at the screen
						if i == Blinks.Value then 
							ScreenWeight.Text = getCharacterWeight(character)
							setTextVisibilities(true, true)
							print('Weighing complete!')
							wait(DisplayTime.Value)
						else
							setTextVisibilities(true, true)
							wait(.5)
						end
					end

					--Resets weight
					ScreenWeight.Text = '0.0'
					setMaxActivationDistance(20,20)
					print('Weight has reset')
				end
			else
				wait(1)
			end	
		end
	end
	
	debounce = false
end)