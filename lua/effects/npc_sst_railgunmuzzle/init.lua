

function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	if !self.WeaponEnt:IsValid() or !self.WeaponEnt:GetOwner():IsValid() then return end
	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter = ParticleEmitter(self.Position)
		
		local particle = emitter:Add("sprites/heatwave", self.Position - self.Forward*4)
		particle:SetVelocity(80*self.Forward + 20*VectorRand() + 1.05*AddVel)
		particle:SetDieTime(math.Rand(0.18,0.25))
		particle:SetStartSize(math.random(10,20))
		particle:SetEndSize(6)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetGravity(Vector(0,0,100))
		particle:SetAirResistance(160)
		
		local particle = emitter:Add("effects/tiramisu/combinemuzzle2", self.Position + self.Forward*4)
		particle:SetVelocity(20*self.Forward + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.1,0.2))
		particle:SetStartAlpha(math.Rand(240,255))
		particle:SetEndAlpha(particle:GetStartAlpha())
		particle:SetStartSize(math.random(1,2))
		particle:SetEndSize(math.Rand(12,24))
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(150,220,245)
		particle:SetAirResistance(80)

		
	for i=-1,1,2 do 
		local particle = emitter:Add("effects/tiramisu/combinemuzzle2", self.Position + self.Forward*4)
		particle:SetVelocity(20*i*self.Right + 1.1*AddVel)
		particle:SetDieTime(math.Rand(0.1,0.2))
		particle:SetStartAlpha(math.Rand(240,255))
		particle:SetEndAlpha(particle:GetStartAlpha())
		particle:SetStartSize(math.random(2,4))
		particle:SetEndSize(math.Rand(10,14))
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(150,220,245)
		particle:SetAirResistance(160)
	end
		
			for j=1,2 do
				for i=-1,1,2 do 
					local particle = emitter:Add("effects/tiramisu/combinemuzzle1", self.Position - self.Forward + 2*j*i*self.Right)
					particle:SetVelocity(20*j*i*self.Right + AddVel)
					particle:SetGravity(AddVel)
					particle:SetDieTime(0.03)
					particle:SetStartAlpha(250)
					particle:SetEndAlpha(particle:GetStartAlpha())
					particle:SetStartSize(j)
					particle:SetEndSize(4*j)
					particle:SetRoll(math.Rand(180,480))
					particle:SetRollDelta(math.Rand(-1,1))
					particle:SetColor(150,220,255)	
				end
			end

	emitter:Finish()

end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()

	
end