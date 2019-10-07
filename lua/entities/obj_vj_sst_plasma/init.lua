if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Projectile Base ===============
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make projectiles.
--------------------------------------------------*/
	-- General ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/props_junk/TrashDumpster02.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 300 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 1000 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_DISSOLVE -- Damage type
ENT.ShakeWorldOnDeath = true -- Should the world shake when the projectile hits something?
ENT.ShakeWorldOnDeathAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.ShakeWorldOnDeathRadius = 2000 -- How far the screen shake goes, in world units
ENT.ShakeWorldOnDeathtDuration = 5 -- How long the screen shake will last, in seconds
ENT.ShakeWorldOnDeathFrequency = 200 -- The frequency
ENT.DecalTbl_DeathDecals = {"VJ_Blood_Blue"}
ENT.SoundTbl_Idle = {"weapons/physcannon/energy_sing_loop4.wav"}
ENT.IdleSoundLevel = 120
ENT.IdleSoundPitch1 = 80
ENT.IdleSoundPitch2 = 80
ENT.SoundTbl_OnCollide = {"weapons/physcannon/energy_disintegrate4.wav"}
ENT.OnCollideSoundLevel = 130
ENT.OnCollideSoundPitch1 = 50
ENT.OnCollideSoundPitch2 = 70
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	self:SetNoDraw(true)
	self:DrawShadow(false)
	phys:Wake()
	phys:SetBuoyancyRatio(0)
	phys:EnableDrag(false)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDoDamage(data,phys,hitent)
	for _,v in ipairs(hitent) do
		if v:IsValid() && v:IsNPC() && v.Tank_Status != nil then
			v:TakeDamage(self.RadiusDamage,self:GetOwner())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	ParticleEffectAttach("plasma_glow_2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	for i =1,math.random(1,3) do
		ParticleEffectAttach("stb_plasma_spit", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	-- ParticleEffectAttach("plasma_main", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	-- ParticleEffectAttach("stb_plasma_spit", PATTACH_ABSORIGIN_FOLLOW, self, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data,phys)
	//self.Dead = true
	self:CustomOnPhysicsCollide(data,phys)
	if self.RemoveOnHit == true then
		if self.Dead == false then
			self.Dead = true
			self:DoDamageCode(data,phys)
			if self.PaintDecalOnDeath == true && VJ_PICKRANDOMTABLE(self.DecalTbl_DeathDecals) != false && self.AlreadyPaintedDeathDecal == false then 
				self.AlreadyPaintedDeathDecal = true 
				util.Decal(VJ_PICKRANDOMTABLE(self.DecalTbl_DeathDecals), data.HitPos +data.HitNormal, data.HitPos -data.HitNormal)
			end
			if self.ShakeWorldOnDeath == true then util.ScreenShake(data.HitPos, self.ShakeWorldOnDeathAmplitude, self.ShakeWorldOnDeathFrequency, self.ShakeWorldOnDeathtDuration, self.ShakeWorldOnDeathRadius) end
			self:OnCollideSoundCode()
		end
		self:SetDeathVariablesTrue(data,phys,true)
		ParticleEffect("stb_plasma_explosion", data.HitPos, Angle(0,0,0), nil)
		self:Remove()
	end
	
	if self.Dead == false && self.CollideCodeWithoutRemoving == true && CurTime() > self.NextCollideCodeWithoutRemovingT then
		self:DoDamageCode(data,phys)
		self:OnCollideSoundCode()
		if self.PaintDecalOnCollide == true && VJ_PICKRANDOMTABLE(self.DecalTbl_OnCollideDecals) != false && self.AlreadyPaintedDeathDecal == false then
			util.Decal(VJ_PICKRANDOMTABLE(self.DecalTbl_OnCollideDecals), data.HitPos +data.HitNormal, data.HitPos -data.HitNormal)
		end
		self:CustomOnCollideWithoutRemove(data,phys)
		self.NextCollideCodeWithoutRemovingT = CurTime() + math.Rand(self.NextCollideCodeWithoutRemovingTime1,self.NextCollideCodeWithoutRemovingTime2)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoDeath_SST()
	if self.Dead == false then
		self.Dead = true
		ParticleEffect("stb_plasma_explosion", self:GetPos(), Angle(0,0,0), nil)
		self:DoDamageCode(data,phys)
		self:OnCollideSoundCode()
		self:Remove()
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/