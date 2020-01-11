AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/predatorcz/stbugs/amblypygi.pmd/model.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 2500
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.TurningSpeed = 8
ENT.VJ_IsHugeMonster = true
ENT.VJ_NPC_Class = {"CLASS_SSTBUG"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.BloodColor = "Orange"
ENT.CustomBlood_Decal = {"VJ_Blood_Orange"} -- Decals to spawn when it's damaged
ENT.Immune_AcidPoisonRadiation = true
ENT.Immune_Dissolve = true
ENT.Immune_Electricity = true
ENT.Immune_Fire = true
ENT.Immune_Physics = true
ENT.AllowIgnition = false

ENT.MeleeAttackDistance = 20
ENT.MeleeAttackDamageDistance = 250
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDamage = 200
ENT.MeleeAttackDamageType = DMG_ALWAYSGIB
ENT.TimeUntilMeleeAttackDamage = false

ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 1000 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 1250 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 100 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 150 -- How far it will push you up | Second in math.random

ENT.HasRangeAttack = true
ENT.RangeDistance = 635
ENT.RangeToMeleeDistance = 120
ENT.DisableDefaultRangeAttackCode = true

ENT.GeneralSoundPitch1 = 100
ENT.FootStepTimeRun = 0.7
ENT.FootStepTimeWalk = 0.7
ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.7 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 0.7 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveAmplitude = 16 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 3000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.9 -- How long the screen shake will last, in seconds
ENT.FootStepSoundLevel = 120
ENT.IdleSoundLevel = 95
ENT.AlertSoundLevel = 100
ENT.DeathSoundLevel = 100

ENT.HasDeathAnimation = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
-- Custom -----------------------------------------------------------------------------------------------------------------------------------
ENT.CollisionBounds = Vector(150,150,200)
ENT.SoundTbl_FootStep = {"stbugs/tanker/sfx_tanker_walk_footstep.mp3"}
ENT.SoundTbl_Alert = {"stbugs/tanker/sfx_tanker_roar.mp3"}
ENT.SoundTbl_Idle = {"stbugs/tanker/sfx_tanker_roar.mp3"}
ENT.SoundTbl_Death = {"stbugs/tanker/sfx_tanker_death_roar.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(self.CollisionBounds.x,self.CollisionBounds.y,self.CollisionBounds.z),-(Vector(self.CollisionBounds.x,self.CollisionBounds.y,0)))
	self:SST_Initialize()
    self.Flame = ents.Create("info_particle_system")
	self.Flame:SetKeyValue("effect_name","tanker_flame")
	self.Flame:SetParent(self)
	self.Flame:Spawn()
	self.Flame:Activate()
	self.Flame:Fire("SetParentAttachment","flame",0)
	self.FlameLoop = CreateSound(self,"stbugs/tanker/sfx_tanker_fire.mp3")
	self.FlameLoop:SetSoundLevel(82)
	self.ElecLoop = CreateSound(self,"ambient/energy/electric_loop.wav")
	self.ElecLoop:SetSoundLevel(75)
	self.FlameActive = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartFlame()
	self.Flame:Fire("Start","",0)
	self.FlameLoop:Play()
	self.FlameActive = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EndFlame()
	self.Flame:Fire("Stop","",0)
	self.FlameLoop:Stop()
	self.FlameActive = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "PMEvent sound step" then
		self:FootStepSoundCode()
	end
	if key == "PMEvent spark_start" then
		self.ElecLoop:Play()
		ParticleEffectAttach("electrical_arc_01_system",PATTACH_POINT_FOLLOW,self,2)
	end
	if key == "PMEvent spark_end" then
		self.ElecLoop:Stop()
	end
	if key == "PMEvent attack flame_start" then
		self:StartFlame()
	end
	if key == "PMEvent attack flame_stop" then
		self:EndFlame()
	end
	if key == "PMEvent attack melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Think()
	if self.FlameActive then
		local entities = ents.FindInBox(self:LocalToWorld(Vector(50,-70,-8.5)),self:LocalToWorld(Vector(750,64,95)))
		for _,v in pairs(entities) do
			if ((((v:IsPlayer() && v:Alive()) || v:IsNPC()) && (self:Disposition(v) == 1 || self:Disposition(v) == 2))) then
				v:Ignite(6,0)
				v:TakeDamage(8,self,self)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self:SST_Think()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SpawnBloodParticles(dmginfo,hitgroup)
	local p_name = VJ_PICK(self.CurrentChoosenBlood_Particle)
	if p_name == false then return end
	
	local dmg_pos = dmginfo:GetDamagePosition()
	if dmg_pos == Vector(0,0,0) then dmg_pos = self:GetPos() + self:OBBCenter() end
	
	if hitgroup == 0 then
		p_name = "vj_impact1_orange"
		self.HasBloodDecal = true
	else
		p_name = "blood_spurt_synth_01"
		self.HasBloodDecal = true
	end
	local spawnparticle = ents.Create("info_particle_system")
	spawnparticle:SetKeyValue("effect_name",p_name)
	spawnparticle:SetPos(dmg_pos)
	spawnparticle:Spawn()
	spawnparticle:Activate()
	spawnparticle:Fire("Start","",0)
	spawnparticle:Fire("Kill","",0.1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo,hitgroup)
	if hitgroup == 0 then
		dmginfo:ScaleDamage(2)
	else
		dmginfo:ScaleDamage(0.01)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.FlameLoop:Stop()
	self.ElecLoop:Stop()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/