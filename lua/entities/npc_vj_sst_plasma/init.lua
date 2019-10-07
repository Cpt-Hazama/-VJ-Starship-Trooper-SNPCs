AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/predatorcz/stbugs/solifugre.pmd/model.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 3000
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CustomBlood_Particle = {"blood_impact_stb_blue"} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {"VJ_Blood_Blue"} -- Decals to spawn when it's damaged
-- Custom -----------------------------------------------------------------------------------------------------------------------------------
ENT.CollisionBounds = Vector(150,190,270)
ENT.SST_HasGibs = false

ENT.FindEnemy_CanSeeThroughWalls = true

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {ACT_IDLE_ANGRY}
ENT.RangeAttackEntityToSpawn = "obj_vj_sst_plasma" -- The entity that is spawned when range attacking
ENT.TimeUntilRangeAttackProjectileRelease = 2.4
ENT.RangeDistance = 15000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = false -- Should the projectile spawn on a attachment?
ENT.NextRangeAttackTime = 10 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Range = 10 -- How much time until it can use any attack again? | Counted in Seconds

ENT.FootStepSoundLevel = 90

ENT.SoundTbl_FootStep = {"stbugs/tanker/sfx_tanker_walk_footstep.mp3"}
ENT.SoundTbl_Pain = {"stbugs/tanker/sfx_tanker_roar.mp3"}
ENT.SoundTbl_Death = {"stbugs/tanker/sfx_tanker_death_roar.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "PMEvent sound step" then
		self:FootStepSoundCode()
		util.ScreenShake(self:GetPos(),14,100,0.6,2300)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Think()
	if self.RangeAttacking == true then
		-- self:SetAngles(Angle(0,(self:GetEnemy():GetPos()-self:GetPos()):Angle().y,0))
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_OverrideProjectilePos(TheProjectile)
	return self:GetPos() +self:GetUp() *500 +self:GetForward() *-500
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	if self.VJ_IsBeingControlled == false then
		return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0,0,0)))*0.25 + self:GetUp()*1350
	else
		return (self.VJ_TheControllerBullseye:GetPos() - self:LocalToWorld(Vector(0,0,0)))*0.25 + self:GetUp()*1350
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0,0,0)))*0.25 + self:GetUp()*1350
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,3)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.MeleeAttackDamage = 44
		self.MeleeAttackDamageType = DMG_SLASH
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {}
	elseif randattack == 2 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
		self.MeleeAttackDamage = 58
		self.MeleeAttackDamageType = DMG_DIRECT
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {0.66}
	elseif randattack == 3 then
		self.AnimTbl_MeleeAttack = {ACT_SPECIAL_ATTACK1}
		self.MeleeAttackDamage = 32
		self.MeleeAttackDamageType = DMG_SLASH
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {0.64}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self:SetSkin(1)
	local bomb = ents.Create("obj_vj_sst_plasma")
	bomb:SetPos(self:GetPos() +self:GetUp() *200)
	bomb:Spawn()
	bomb:Activate()
	bomb:DoDeath_SST()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/