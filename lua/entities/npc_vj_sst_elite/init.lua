AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/predatorcz/stbugs/uropygi_tigris_elitus.pmd/model.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 650
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CustomBlood_Particle = {"blood_impact_stb_blue_glowing"} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {"VJ_Blood_Blue"} -- Decals to spawn when it's damaged
-- Custom -----------------------------------------------------------------------------------------------------------------------------------
ENT.CollisionBounds = Vector(50,40,110)

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {"vjseq_range_attack1"}
ENT.RangeAttackEntityToSpawn = "obj_vj_sst_tigershard" -- The entity that is spawned when range attacking
ENT.TimeUntilRangeAttackProjectileRelease = 0.55
ENT.RangeAttackExtraTimers = {0.6}
ENT.RangeDistance = 1000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 350 -- How close does it have to be until it uses melee?
ENT.RangeUseAttachmentForPos = true -- Should the projectile spawn on a attachment?
ENT.RangeUseAttachmentForPosID = "mouth"
ENT.NextRangeAttackTime = 1 -- How much time until it can use a range attack?
ENT.NextRangeAttackTime_DoRand = 2 -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.NextAnyAttackTime_Range = 0.83 -- How much time until it can use any attack again? | Counted in Seconds

ENT.SoundTbl_FootStep = {"npc/antlion/shell_impact1.wav","npc/antlion/shell_impact2.wav","npc/antlion/shell_impact3.wav","npc/antlion/shell_impact4.wav"}
ENT.SoundTbl_Alert = {"stbugs/warrior/sfx_warrior_alert_01.mp3","stbugs/warrior/sfx_warrior_alert_02mp3","stbugs/warrior/sfx_warrior_alert_03.mp3"}
ENT.SoundTbl_Idle = {"stbugs/warrior/sfx_warrior_idle_01.mp3","stbugs/warrior/sfx_warrior_idle_02.mp3","stbugs/warrior/sfx_warrior_idle_03.mp3","stbugs/warrior/sfx_warrior_idle_04.mp3"}
ENT.SoundTbl_Pain = {"stbugs/warrior/sfx_warrior_screech_normal1.mp3","stbugs/warrior/sfx_warrior_screech_normal2.mp3","stbugs/warrior/sfx_warrior_screech_normal3.mp3","stbugs/warrior/sfx_warrior_screech_shot1.mp3","stbugs/warrior/sfx_warrior_screech_shot2.mp3"}
ENT.SoundTbl_Death = {"stbugs/warrior/sfx_warrior_die_05.mp3","stbugs/warrior/sfx_warrior_die_06.mp3","stbugs/warrior/sfx_warrior_die_07.mp3","stbugs/warrior/sfx_warrior_die_08.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:RangeAttackCode_GetShootPos(TheProjectile) return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0,0,0)))*5 + self:GetUp()*-100 end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,3)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.MeleeAttackDamage = 54
		self.MeleeAttackDamageType = DMG_SLASH
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {}
	elseif randattack == 2 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
		self.MeleeAttackDamage = 86
		self.MeleeAttackDamageType = DMG_DIRECT
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {0.66}
	elseif randattack == 3 then
		self.AnimTbl_MeleeAttack = {ACT_SPECIAL_ATTACK1}
		self.MeleeAttackDamage = 43
		self.MeleeAttackDamageType = DMG_SLASH
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {0.64}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self:SetSkin(1)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/