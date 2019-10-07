AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/predatorcz/stbugs/opilionei.pmd/model.mdl" -- Leave empty if using more than one model
ENT.StartHealth = 200
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.VJ_NPC_Class = {"CLASS_SSTBUG"}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CustomBlood_Particle = {"blood_impact_stb_yellow"} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {"VJ_Blood_Yellow"} -- Decals to spawn when it's damaged

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {"vjseq_range_attack1"}
ENT.RangeAttackEntityToSpawn = "obj_vj_sst_acid" -- The entity that is spawned when range attacking
ENT.TimeUntilRangeAttackProjectileRelease = 0.55
ENT.RangeDistance = 6500 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 800 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = true -- Should the projectile spawn on a attachment?
ENT.RangeUseAttachmentForPosID = "mouth"
ENT.NextRangeAttackTime = 1 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 2 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Range = 0.83 -- How much time until it can use any attack again? | Counted in Seconds

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDamage = 21
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 180 -- How far the damage goes
ENT.TimeUntilMeleeAttackDamage = 0.4 -- This counted in seconds | This calculates the time until it hits something
ENT.UntilNextAttack_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds

-- ENT.MovementType = VJ_MOVETYPE_AERIAL -- How does the SNPC move?
-- Custom -----------------------------------------------------------------------------------------------------------------------------------
ENT.CollisionBounds = Vector(35,40,90)
ENT.Aerial_FlyingSpeed_Calm = 600 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 600 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.Aerial_AnimTbl_Alerted = {"glide","glide_swing"} -- Animations it plays when it's moving while alerted
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(self.CollisionBounds.x,self.CollisionBounds.y,self.CollisionBounds.z),-(Vector(self.CollisionBounds.x,self.CollisionBounds.y,0)))
	self:SST_Initialize()
	self.IsFlying = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if self:GetEnemy() != nil && self.MovementType != VJ_MOVETYPE_AERIAL && self.IsFlying == false && self:GetEnemy():GetPos():Distance(self:GetPos()) >= 1500 then
		self:VJ_ACT_PLAYACTIVITY(ACT_HOP,false,0,true)
		self.IsFlying = true
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:DoChangeMovementType(VJ_MOVETYPE_AERIAL)
				self.HasMeleeAttack = false
				self.HasRangeAttack = true
			end
		end)
	elseif self:GetEnemy() == nil && self.MovementType == VJ_MOVETYPE_AERIAL then
		self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
		self.IsFlying = false
		self.HasMeleeAttack = true
		self.HasRangeAttack = false
		self:VJ_ACT_PLAYACTIVITY(ACT_LAND,false,0,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	self.NextMeleeAttackTime = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation)
	self.NextAnyAttackTime_Melee = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation)
	local ent = NULL
	if self.VJ_IsBeingControlled == true then ent = self.VJ_TheController else ent = self:GetEnemy() end
	local x_enemy = 0
	local y_enemy = 0
	if IsValid(ent) then
		local self_pos = self:GetPos() + self:OBBCenter()
		local enemy_pos = Vector(0,0,0)
		if self.VJ_IsBeingControlled == true then enemy_pos = self.VJ_TheController:GetEyeTrace().HitPos else enemy_pos = ent:GetPos() + ent:OBBCenter() end
		local self_ang = self:GetAngles()
		local enemy_ang = (enemy_pos - self_pos):Angle()
		x_enemy = math.AngleDifference(enemy_ang.p,self_ang.p)
		y_enemy = math.AngleDifference(enemy_ang.y,self_ang.y)
	end
	self:SetPoseParameter("aim_yaw",math.ApproachAngle(self:GetPoseParameter("aim_yaw"),y_enemy,10))
	self:SetPoseParameter("aim_pitch",math.ApproachAngle(self:GetPoseParameter("aim_pitch"),x_enemy,10))
\end
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/