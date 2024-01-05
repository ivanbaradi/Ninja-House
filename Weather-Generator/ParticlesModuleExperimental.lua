--[[
This Module is Open Source. You can edit it however you like.
You don't need to credit me when you use it (But i would be happy if you would :3)
If you any ideas or you know how I can Optimize it, you can reply to my Post on Roblox DevForum.
If you don't know how this thing works, you can check my Post on DevForum. It is hard to use because i made it badly.

!!!REMEMBER!!!
You shouldn't replace Roblox Particles with this module because it is not optimized and it can cause lag.
]]
-- VERSION: 3.2


local module = {}

local function BoxPointIntersection(cframe, size, point)
	local rel = cframe:pointToObjectSpace(point)
	local sx, sy, sz = size.x, size.y, size.z
	local rx, ry, rz = rel.x, rel.y, rel.z

	-- constrain to within the box
	local cx = math.clamp(rx, -sx/2, sx/2)
	local cy = math.clamp(ry, -sy/2, sy/2)
	local cz = math.clamp(rz, -sz/2, sz/2)

	if not (cx == rx and cy == ry and cz == rz) then
		local closestPoint = cframe*Vector3.new(cx, cy, cz)
		local normal = (point - closestPoint).unit
		return false, closestPoint, normal
	end

	-- else, they are intersecting, find the surface the point is closest to

	local posX = rx - sx/2 
	local posY = ry - sy/2 
	local posZ = rz - sz/2 
	local negX = -rx - sx/2 
	local negY = -ry - sy/2 
	local negZ = -rz - sz/2

	local max = math.max(posX, posY, posZ, negX, negY, negZ)
	if max == posX then
		local closestPoint = cframe*Vector3.new(sx/2, ry, rz)
		return true, closestPoint, cframe.XVector
	elseif max == posY then
		local closestPoint = cframe*Vector3.new(rx, sy/2, rz)
		return true, closestPoint, cframe.YVector
	elseif max == posZ then
		local closestPoint = cframe*Vector3.new(rx, ry, sz/2)
		return true, closestPoint, cframe.ZVector
	elseif max == negX then
		local closestPoint = cframe*Vector3.new(-sx/2, ry, rz)
		return true, closestPoint, -cframe.XVector
	elseif max == negY then
		local closestPoint = cframe*Vector3.new(rx, -sy/2, rz)
		return true, closestPoint, -cframe.YVector
	elseif max == negZ then
		local closestPoint = cframe*Vector3.new(rx, ry, -sz/2)
		return true, closestPoint, -cframe.ZVector
	end
end

local mat = math
local function VecAbs(Vec : Vector3) : Vector3
	return Vector3.new(mat.abs(Vec.x), mat.abs(Vec.y), mat.abs(Vec.Z))
end

local function Reflect(dir : Vector3, normal : Vector3)
	return (dir - (2 * dir:Dot(normal) * normal))
end

local function GetGridPosition(Vec : Vector3, Size : number)
	return Vector3.new(mat.floor(Vec.X / Size), mat.floor(Vec.Y / Size), mat.floor(Vec.Z / Size))
end

local GridSearch = {
	Vector3.xAxis,
	-Vector3.xAxis,
	Vector3.yAxis,
	-Vector3.yAxis,
	Vector3.zAxis,
	-Vector3.zAxis,
	Vector3.zero,
	Vector3.new(1, -1, -1),
	Vector3.new(1, -1, 0),
	Vector3.new(1, -1, 1),
	Vector3.new(0, -1, -1),
	Vector3.new(0, -1, 1),
	Vector3.new(-1, -1, -1),
	Vector3.new(-1, -1, 0),
	Vector3.new(-1, -1, 1),
	Vector3.new(1, 1, -1),
	Vector3.new(1, 1, 0),
	Vector3.new(1, 1, 1),
	Vector3.new(0, 1, -1),
	Vector3.new(0, 1, 1),
	Vector3.new(-1, 1, -1),
	Vector3.new(-1, 1, 0),
	Vector3.new(-1, 1, 1),
	Vector3.new(1, 0, 1),
	Vector3.new(-1, 0, 1),
	Vector3.new(1, 0, -1),
	Vector3.new(-1, 0, -1)
	
}

module.SelfCollType = {
	Default = "Default",
	Realistic = "Realistic",
	Fluid = "Fluid"
}

module.TypeForce = {
	Repel = "Repel",
	RepelConstant = "RepelConstant",
	Turbulence = "Turbulence"
}

function module:NewForce(Type)
	if Type == module.TypeForce.Repel then
		return {["Type"] = Type, ["Position"] = Vector3.zero, ["Range"] = 12, ["Power"] = 15}
	end
	if Type == module.TypeForce.RepelConstant then
		return {["Type"] = Type, ["Position"] = Vector3.zero, ["Range"] = math.huge, ["Power"] = 15}
	end
	if Type == module.TypeForce.Turbulence then
		return {["Type"] = Type, ["Position"] = Vector3.zero, ["Power"] = 15, ["Scale"] = 0.25}
	end
end

local AlghoritmForces = {
	["Repel"] = function(Forc, Pos, Vel) 
		if (Pos - Forc.Position).Magnitude < Forc.Range then
			return (Forc.Range - (Pos - Forc.Position).Magnitude) / Forc.Range * Forc.Power * (Pos - Forc.Position).Unit
		else
			return Vector3.zero
		end
	end,
	["RepelConstant"] = function(Forc, Pos, Vel) 
		if (Pos - Forc.Position).Magnitude < Forc.Range then
			return Forc.Power * (Pos - Forc.Position).Unit
		else
			return Vector3.zero
		end
	end,
	["Turbulence"] = function(Forc, Pos, Vel) 
		local ScaledForce = Forc.Position * Forc.Scale
		local ScaledPos = Pos* Forc.Scale
		return Vector3.new(mat.noise( ScaledForce.X + ScaledPos.X, ScaledForce.Y, ScaledForce.Z), mat.noise( ScaledForce.X, ScaledForce.Y + ScaledPos.Y, ScaledForce.Z), mat.noise( ScaledForce.X, ScaledForce.Y, ScaledForce.Z + ScaledPos.Z)) * Forc.Power
	end
}

function module.new()
	--You shouldn't change these Values. You need to change them in your script, not in Module.
	local self = {}
	self.EmmiterObject = nil --Object that will Emit Particles
	self.Folder = nil --Folder where particles will be Parented to when created.
	self.Enabled = false --Determines whenever Emitter is Emitting Particles on it's own.
	
	self.SelfCollType = "Default"
	self.SelfCollisions = false --Performance Hungry!
	self.Mass = 50
	self.Iterations = 2
	self.SelfSize = 1
	self.FluidForce = 1
	self.SimulateTurbulence = false
	self.CollisionComplexity = true --When it is on, Collisions will use Sphere, when it’s off, Collisions will use Box. Low Performance Impact.
	self.ColliderSize = 1 --Size of the collider.
	self.Part = nil --Object that the emmiter will emmit.
	self.FaceCamera = false --Toggles whenever particles face the camera.
	self.CameraCulling = true --Toggles whenever particles position update when they are not visible to camera.

	--You can find explanation of these functions on DevForum Post.
	self.EveryFrame = nil
	self.OnCollision = nil
	self.OnSpawn = nil
	self.BeforePhysics = nil

	self.MinimumCachce = 20 --Makes it so that amount of cachced particles cannot be smaller than this number. Useful when creating explosions using Emit Function.
	self.Friction = 0.1
	self.Bounce = 1 --How strongly Particles Bounce. If 1, it bounces with the same velocity. If 0, it doesn't bounce at all. If 0.5, it decreases velocity by half when bouncing.
	self.Speed = NumberRange.new(1) --The starting speed of Particles when they are created.
	self.InheritSpeed = 0 --Determines how much Emitter Velocity affects Particles Velocity
	self.Spread = Vector2.new(0, 0) --The spread of Particles. If 0 they will all go in one direction.
	self.Rate = 5 --How many Particles are created per second.
	self.LifeTime = NumberRange.new(1) --How long Particles will last.
	self.Drag = 0 --How much air slows down the particles. 0.6 seems realistic.
	self.Acceleration = Vector3.zero --Force applied on Particles. Can be used to create Gravity.

	self.Wind = false --If true, Particles will be affected by wind.
	self.WindSpeed = 0.8 --How fast wind changes position.
	self.WindScale = 0.3 --It is hard to explain. Basically wind is made by perlin noise. So it changes how Frequently there are changes in Noise based on Particle position.
	self.WindStrenght = 50 --How strong wind is.
	self.WindDirection = Vector3.xAxis --Direction of wind.

	self.DistanceFPS = 30 --At which Distance Particles will update with lower FPS
	
	local Forces = {}
	local Particles = {}
	local Cachce = {}
	local Frame = 0
	local Index = 0
	
	function self:AddForce(Force)
		table.insert(Forces, Force)
	end
	
	--This is a function that you can use to emit particles by yourself. Useful for explosions.
	local function Emit(Rate)
		local Tabel = {}
		for i = 1, Rate do
			Index += 1
			local New = {}
			if #Cachce > 0 then
				New.Part = table.remove(Cachce, 1)
			else
				New.Part = self.Part:Clone()
			end
			New.Part.CFrame = self.EmmiterObject.CFrame
			New.Part.CanCollide = false
			New.Part.Anchored = true
			New.Part.Locked = true
			New.Part.Parent = self.Folder

			New.LifeTime = mat.random(self.LifeTime.Min * 1000, self.LifeTime.Max * 1000) / 1000
			New.Velocity = Vector3.zero
			local SpreadX = self.Spread.X * 10
			local SpreadY = self.Spread.Y * 10
			New.Velocity = ((self.EmmiterObject.CFrame * CFrame.Angles(math.rad(math.random(-SpreadX, SpreadX)/10), math.rad(math.random(-SpreadY, SpreadY)/10), 0)).LookVector * mat.random(self.Speed.Min * 1000, self.Speed.Max * 1000) / 1000) + (self.EmmiterObject.AssemblyLinearVelocity * self.InheritSpeed)

			local EmiCFrame = self.EmmiterObject.CFrame
			local Size = self.EmmiterObject.Size
			New.Pos = EmiCFrame.Position + EmiCFrame.RightVector * math.random(-10000, 10000) / 20000 * Size.X + EmiCFrame.UpVector * math.random(-10000, 10000) / 20000 * Size.Y + EmiCFrame.LookVector * math.random(-10000, 10000) / 20000 * Size.Z
			New.Part.Position = New.Pos
			New.CamLastTime = true

			New.Delta = 0
			table.insert(Particles, 1, New)
			Index %= 12
			if self.OnSpawn then
				Tabel[New.Part] = self:OnSpawn(New.Pos, New.Velocity, 1)
			end
		end
		return Tabel	

	end

	function self:Emit(Ammount)
		local Properties = {}
		local Sav = Emit(Ammount)
		for i, v in pairs(Sav) do
			Properties[i] = v
		end
		for part, pops in pairs(Properties) do
			for name, val in pairs(pops) do
				part[name] = val
			end
		end
	end

	local Last = tick()
	local Now = tick()
	game:GetService("RunService").Heartbeat:Connect(function(dt)
		Frame %= 36
		Frame += 1
		local Properties = {}
		if self.Enabled and self.EmmiterObject then
			Now = tick()
			local Rate = 1 / self.Rate
			local This = (Now - Last)
			if Now > Last + Rate then
				local Sav = Emit(math.floor( This / Rate ))
				for i, v in pairs(Sav) do
					Properties[i] = v
				end
				Last += math.floor( This / Rate ) * Rate
			end
		else
			Last = tick()
		end
		if Frame % 36 == 0 then
			if #Cachce > self.MinimumCachce then
				for i = 1, math.ceil((#Cachce - self.MinimumCachce) * 0.5) do
					Cachce[i]:Destroy()
					table.remove(Cachce, i)
				end
			end
		end
		local ColParams = OverlapParams.new()
		ColParams.FilterType = Enum.RaycastFilterType.Blacklist
		ColParams.FilterDescendantsInstances = {self.EmmiterObject, self.Folder}
		local RayParams = RaycastParams.new()
		RayParams.FilterType = Enum.RaycastFilterType.Blacklist
		RayParams.FilterDescendantsInstances = {self.EmmiterObject, self.Folder}
		if self.BeforePhysics then
			self:BeforePhysics()
		end
		task.desynchronize()
		local CollCheck
		if self.CollisionComplexity then
			CollCheck = function(Pos)
				return workspace:GetPartBoundsInRadius(Pos, self.ColliderSize, ColParams)
			end
		else
			CollCheck = function(Pos)
				return workspace:GetPartBoundsInBox(CFrame.new(Pos), Vector3.one * self.ColliderSize, ColParams)
			end
		end
		local Grid = {}
		local Parts = {}
		local CFrames = {}
		local Cam = workspace.CurrentCamera
		if Cam then
			local CamPos = nil
			if self.FaceCamera then
				CamPos = workspace.CurrentCamera.CFrame.Position
			end
			local Fov = mat.rad(Cam.FieldOfView)
			debug.profilebegin("Particles")
			local Drag = self.Drag
			local ColliderSize = self.ColliderSize
			local Bounce = self.Bounce
			local Friction = self.Friction
			local SelfSize = self.SelfSize
			local DistanceFPS = self.DistanceFPS
			local Acceleration = self.Acceleration
			
			for ind, this in ipairs(Particles) do
				this.Delta += dt
				for i, Forc in pairs(Forces) do
					this.Velocity += AlghoritmForces[Forc.Type](Forc, this.Pos, this.Velocity)
				end
				if Frame % math.ceil((workspace.CurrentCamera.CFrame.Position - this.Pos).Magnitude / DistanceFPS) == 0 then
					local LastGrid = GetGridPosition(this.Pos, SelfSize)
					if self.SimulateTurbulence then
						--Fakes Objects Interacting with Wind which affects Particles
						local Colliders = workspace:GetPartBoundsInRadius(this.Pos, 5, ColParams)
						local Moving = 0
						for i, v : BasePart in pairs(Colliders) do
							if v.AssemblyLinearVelocity.Magnitude > 0.1 then
								Moving += 1
							end
						end
						for i, v : BasePart in pairs(Colliders) do
							if v.AssemblyLinearVelocity.Magnitude > 0.1 then
								--this.Velocity += (v.Position - this.Pos).Unit:Cross(v.AssemblyLinearVelocity.Unit) * v.AssemblyLinearVelocity.Magnitude * this.Delta * 1
								local angle = math.acos(v.AssemblyLinearVelocity.Unit:Dot((this.Pos-v.Position).Unit))
								if angle < mat.rad(80) then
									--This is Repel
									this.Velocity += (this.Pos - ((CFrame.lookAt(v.Position, v.Position + v.AssemblyLinearVelocity) * CFrame.Angles(mat.rad(25), 0, 0)).LookVector * (this.Pos - v.Position).Magnitude + v.Position)) * this.Delta * v.AssemblyLinearVelocity.Magnitude * 0.3 * (1 / Moving)
									
								else
									--This is Attract
									this.Velocity -= (this.Pos - ((CFrame.lookAt(v.Position, v.Position + v.AssemblyLinearVelocity) * CFrame.Angles(mat.rad(-5), 0, 0)).LookVector * (this.Pos - v.Position).Magnitude + v.Position)) * this.Delta * v.AssemblyLinearVelocity.Magnitude * 0.09 * (1 / Moving)
									
								end
								
							end
						end
					end
					
					local Collided = false
					this.Velocity += Acceleration * this.Delta --Calculate Acceleration
					if self.Wind then
						this.Velocity += (math.noise(this.Pos.X * self.WindScale, this.Pos.Y * self.WindScale + workspace.DistributedGameTime * self.WindSpeed, this.Pos.Z * self.WindScale) + 0.5) * self.WindDirection.Unit * self.WindStrenght * this.Delta
					end
					this.Velocity += (Drag*this.Velocity.Magnitude*2*(-this.Velocity.Unit)) * this.Delta -- Simulate Air Drag
					local Col : {BasePart} = CollCheck(this.Pos) --Get Colliding Parts
					if #Col > 0 then
						Collided = true
						
						local CalculatedVel = Vector3.zero
						for i, v in ipairs(Col) do
							--Pushes the particle out of Colliders
							--local Inside, Push, Normal = BoxPointIntersection(v.CFrame, v.Size, this.Pos)
							--CalculatedPos += (Push + (Normal * (ColliderSize / 2 + 0.01))) - this.Pos
							CalculatedVel += v.AssemblyLinearVelocity + v.AssemblyAngularVelocity:Cross(this.Pos - v.Position)
						end
						CalculatedVel /= #Col
						local Inside, Push, Normal = BoxPointIntersection(Col[1].CFrame, Col[1].Size, this.Pos)
						--local AngVel = Col[1].AssemblyLinearVelocity + Col[1].AssemblyAngularVelocity:Cross(this.Pos - Col[1].Position)
						--this.Velocity += CalculatedVel - this.Velocity + this.Velocity * Bounce
						local relativeVelocity = CalculatedVel - this.Velocity

						-- Calculate velocity components along normal and tangent directions
						local velocityAlongNormal = relativeVelocity:Dot(Normal)
						local tangentVelocity = relativeVelocity - (Normal * velocityAlongNormal)

						-- Calculate friction force
						local frictionMagnitude = -Friction * tangentVelocity.Magnitude
						local frictionForce = -tangentVelocity.Unit * frictionMagnitude

						-- Calculate bounce vector
						local bounceVector = Normal * (velocityAlongNormal * (Bounce + 1))

						-- Calculate final velocity
						local finalVelocity = bounceVector + (frictionForce * this.Delta)

						-- Apply final velocity
						this.Velocity = this.Velocity + finalVelocity
						--this.Pos = CalculatedPos
						this.Pos = (Push + (Normal * (ColliderSize / 2 + 0.02))) + this.Velocity * 1.1 * this.Delta
					end
					this.Pos += this.Velocity * this.Delta --Move the Particle
					local Col : {BasePart} = CollCheck(this.Pos) --Get Colliding Parts
					if #Col > 0 then
						Collided = true
						
						local CalculatedVel = Vector3.zero
						for i, v in ipairs(Col) do
							--Pushes the particle out of Colliders
							--local Inside, Push, Normal = BoxPointIntersection(v.CFrame, v.Size, this.Pos)
							--CalculatedPos += (Push + (Normal * (ColliderSize / 2 + 0.01))) - this.Pos
							CalculatedVel += v.AssemblyLinearVelocity + v.AssemblyAngularVelocity:Cross(this.Pos - v.Position)
						end
						CalculatedVel /= #Col
						local Inside, Push, Normal = BoxPointIntersection(Col[1].CFrame, Col[1].Size, this.Pos)
						--local AngVel = Col[1].AssemblyLinearVelocity + Col[1].AssemblyAngularVelocity:Cross(this.Pos - Col[1].Position)
						--this.Velocity += CalculatedVel - this.Velocity + this.Velocity * Bounce
						local relativeVelocity = CalculatedVel - this.Velocity 

						-- Calculate velocity components along normal and tangent directions
						local velocityAlongNormal = relativeVelocity:Dot(Normal)
						local tangentVelocity = relativeVelocity - Normal * velocityAlongNormal

						-- Calculate friction force
						local frictionMagnitude = -Friction * tangentVelocity.Magnitude
						local frictionForce = -tangentVelocity.Unit * frictionMagnitude

						-- Calculate bounce vector
						local bounceVector = Normal * (velocityAlongNormal * (Bounce + 1))

						-- Calculate final velocity
						local finalVelocity = bounceVector + frictionForce

						-- Apply final velocity
						this.Velocity = this.Velocity + finalVelocity
						--this.Pos = CalculatedPos
						this.Pos = (Push + (Normal * (ColliderSize / 2 + 0.02))) + this.Velocity * this.Delta
					end
					this.LifeTime -= this.Delta
					if this.LifeTime <= 0 then
						table.insert(Parts, this.Part)
						table.insert(CFrames, CFrame.new(0, -100, 0))
						table.insert(Cachce, this.Part)
						table.remove(Particles, ind)
					else
						if self.CameraCulling then
							local angle = math.acos(Cam.CFrame.LookVector:Dot((this.Pos-Cam.CFrame.Position).Unit))
							--local ben, onScreen = Cam:WorldToScreenPoint(this.Part.Position)
							if angle < Fov then
								this.CamLastTime = true
								table.insert(Parts, this.Part)
								table.insert(CFrames, CFrame.lookAt(this.Pos, CamPos or (this.Pos + this.Velocity)))
								if self.EveryFrame and (not Properties[this.Part]) then
									Properties[this.Part] = self:EveryFrame(this.Pos, this.Velocity, this.LifeTime / self.LifeTime.Max)
								end
							else
								if this.CamLastTime then
									table.insert(Parts, this.Part)
									table.insert(CFrames, CFrame.new(0, -100, 0))
									this.CamLastTime = false
								end
							end
							if Collided and self.OnCollision then
								Properties[this.Part] = self:OnCollision(this.Pos, this.Velocity, this.LifeTime / self.LifeTime.Max)
							end
						else 
							table.insert(Parts, this.Part)
							table.insert(CFrames, CFrame.lookAt(this.Pos, CamPos or (this.Pos + this.Velocity)))
							if Collided and self.OnCollision then
								Properties[this.Part] = self:OnCollision(this.Pos, this.Velocity, this.LifeTime / self.LifeTime.Max)
							elseif self.EveryFrame and (not Properties[this.Part]) then
								Properties[this.Part] = self:EveryFrame(this.Pos, this.Velocity, this.LifeTime / self.LifeTime.Max)
							end
						end

					end
					this.Delta = 0
				end

			end
			if self.SelfCollisions then
				local gridPositions = {} -- Temporary table to store grid positions

				for i, this in ipairs(Particles) do
					local that = GetGridPosition(this.Pos, self.SelfSize)
					if that == that then -- Use math.isnan to avoid unnecessary comparisons
						if Grid[that] then
							Grid[that][i] = true
						else
							Grid[that] = { [i] = true } -- Use integer keys for arrays and compound assignment operator
						end
					end
					gridPositions[i] = that -- Store grid position in temporary table
				end

				local Iterations = self.Iterations
				local SelfSize = self.SelfSize
				local Bounce = self.Bounce
				local Mass = self.Mass
				local FluidForce = self.FluidForce
				
				for iteration = 1, Iterations do
					for ind, this in ipairs(Particles) do
						
						local NowGrid = gridPositions[ind]
						local CollsionsTable = {}
						for i, Search in pairs(GridSearch) do
							if Grid[NowGrid + Search] then
								for ii, other in pairs(Grid[NowGrid + Search]) do
									if other then
										CollsionsTable[ii] = other
									end
								end
							end
						end
						
						if self.SelfCollType == "Realistic" then
							for i, otrhe in pairs(CollsionsTable) do
								if i ~= ind then
									local other = Particles[i]
									local Dist = (other.Pos - this.Pos).Magnitude
									local Look = (this.Pos - other.Pos).Unit
									local Relative = (this.Velocity - other.Velocity)
									if Dist < SelfSize then
										if i < ind then
											this.Pos += ((SelfSize - Dist) * Look) / Iterations
											this.Velocity -= (((1 + Bounce) * (Relative:Dot(Look)) / Mass) * Look) / Iterations
											other.Velocity += (((1 + Bounce) * (Relative:Dot(Look)) / Mass) * Look) / Iterations
										else
											this.Pos += ((SelfSize - Dist) * Look) / Iterations
											this.Velocity -= (((1 + Bounce) * (Relative:Dot(Look)) / Mass) * Look) /Iterations
											other.Velocity += (((1 + Bounce) * (Relative:Dot(Look)) / Mass) * Look) / Iterations

										end
										
									end
								end
							end
						elseif self.SelfCollType == "Default" then
							for i, otrhe in pairs(CollsionsTable) do
								if i ~= ind then
									local other = Particles[i]
									local Dist = (other.Pos - this.Pos).Magnitude
									local Look = (this.Pos - other.Pos).Unit
									if Dist < SelfSize then
										if i < ind then
											this.Pos += ((SelfSize - Dist) * Look) / Iterations
											this.Velocity += ((SelfSize - Dist) * Look)  / Iterations
											this.Velocity += (other.Velocity * dt)  / Iterations
										else
											this.Pos += ((SelfSize - Dist) * Look * 0.5)  / Iterations
											this.Velocity += ((SelfSize - Dist) * Look * 0.5)  / Iterations
											this.Velocity += (other.Velocity * dt)  / Iterations
										end
										
									end
								end
							end
						elseif self.SelfCollType == "Fluid" then
							for i, otrhe in pairs(CollsionsTable) do
								if i ~= ind then
									local other = Particles[i]
									local Dist = (other.Pos - this.Pos).Magnitude
									local Look = (this.Pos - other.Pos).Unit
									if Dist < self.SelfSize then
										if i < ind then
											local Pow = (FluidForce * (SelfSize - Dist) * Look) / Iterations
											this.Velocity += Pow
											other.Velocity -= Pow
											--this.Pos +=Pow
										else
											local Pow = (FluidForce * (SelfSize - Dist) * Look * 0.5) / Iterations
											this.Velocity += Pow
											other.Velocity -= Pow
											--this.Pos += Pow
										end
										
									end
								end
							end
						end
						
						local LastGrid = NowGrid
						local JustGrid = GetGridPosition(this.Pos, self.SelfSize)
						if not (JustGrid ~= JustGrid) then
							if LastGrid ~= NowGrid then
								if Grid[LastGrid] then
									Grid[LastGrid][ind] = nil
								end
								if Grid[JustGrid] then
									Grid[JustGrid][ind] = this
								else
									Grid[JustGrid] = {[ind] = this}
								end
								gridPositions[ind] = JustGrid
							end
						end
						
					end
				end
			end
			
			debug.profileend()
		end
		Forces = {}
		task.synchronize()
		workspace:BulkMoveTo(Parts, CFrames, Enum.BulkMoveMode.FireCFrameChanged)
		for part, pops in pairs(Properties) do
			for name, val in pairs(pops) do
				part[name] = val
			end
		end

	end)

	return self
end

return module