AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/predatorcz/stbugs/uropygi_psidium.pmd/model.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 310
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CustomBlood_Particle = {"blood_impact_stb_green"} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {"VJ_Blood_Green"} -- Decals to spawn when it's damaged
-- Custom -----------------------------------------------------------------------------------------------------------------------------------
ENT.CollisionBounds = Vector(50,50,120)
ENT.SoundTbl_FootStep = {"npc/antlion/shell_impact1.wav","npc/antlion/shell_impact2.wav","npc/antlion/shell_impact3.wav","npc/antlion/shell_impact4.wav"}
ENT.SoundTbl_Alert = {"stbugs/warrior/sfx_warrior_alert_01.mp3","stbugs/warrior/sfx_warrior_alert_02mp3","stbugs/warrior/sfx_warrior_alert_03.mp3"}
ENT.SoundTbl_Idle = {"stbugs/warrior/sfx_warrior_idle_01.mp3","stbugs/warrior/sfx_warrior_idle_02.mp3","stbugs/warrior/sfx_warrior_idle_03.mp3","stbugs/warrior/sfx_warrior_idle_04.mp3"}
ENT.SoundTbl_Pain = {"stbugs/warrior/sfx_warrior_screech_normal1.mp3","stbugs/warrior/sfx_warrior_screech_normal2.mp3","stbugs/warrior/sfx_warrior_screech_normal3.mp3","stbugs/warrior/sfx_warrior_screech_shot1.mp3","stbugs/warrior/sfx_warrior_screech_shot2.mp3"}
ENT.SoundTbl_Death = {"stbugs/warrior/sfx_warrior_die_05.mp3","stbugs/warrior/sfx_warrior_die_06.mp3","stbugs/warrior/sfx_warrior_die_07.mp3","stbugs/warrior/sfx_warrior_die_08.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize()
	self:SetSkin(0)
	self:SetModelScale(1.05)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,3)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.MeleeAttackDamage = 36
		self.MeleeAttackDamageType = DMG_DIRECT
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {}
	elseif randattack == 3 then
		self.AnimTbl_MeleeAttack = {ACT_SPECIAL_ATTACK1}
		self.MeleeAttackDamage = 28
		self.MeleeAttackDamageType = DMG_SLASH
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {0.64}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/