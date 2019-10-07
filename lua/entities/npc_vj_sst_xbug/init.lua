AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/model.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 10000
ENT.VJ_IsHugeMonster = true -- Is this a huge monster?
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CustomBlood_Particle = {"blood_impact_stb_red_glowing"} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {"VJ_Blood_Red"} -- Decals to spawn when it's damaged
-- Custom -----------------------------------------------------------------------------------------------------------------------------------
ENT.CollisionBounds = Vector(200,200,200)
ENT.SST_HasGibs = false
ENT.HasMeleeAttackKnockBack = true -- If true, it will cause a knockback to its enemy
ENT.MeleeAttackKnockBack_Forward1 = 700 -- How far it will push you forward | First in math.random
ENT.MeleeAttackKnockBack_Forward2 = 730 -- How far it will push you forward | Second in math.random
ENT.MeleeAttackKnockBack_Up1 = 500 -- How far it will push you up | First in math.random
ENT.MeleeAttackKnockBack_Up2 = 530 -- How far it will push you up | Second in math.random
ENT.FootStepSoundLevel = 90
ENT.MeleeAttackDistance = 80 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 350 -- How far the damage goes
ENT.SoundTbl_FootStep = {"npc/antlion/shell_impact1.wav","npc/antlion/shell_impact2.wav","npc/antlion/shell_impact3.wav","npc/antlion/shell_impact4.wav"}
ENT.SoundTbl_CombatIdle = {"stbugs/royal/sfx_royal_combat_01.mp3","stbugs/royal/sfx_royal_combat_02.mp3","stbugs/royal/sfx_royal_combat_03.mp3"}
ENT.SoundTbl_Idle = {"stbugs/royal/sfx_royal_idle_01.mp3","stbugs/royal/sfx_royal_idle_02.mp3","stbugs/royal/sfx_royal_idle_03.mp3"}
ENT.SoundTbl_Pain = {"stbugs/royal/sfx_royal_hurt_01.mp3","stbugs/royal/sfx_royal_hurt_02.mp3"}
ENT.SoundTbl_Death = {"stbugs/royal/sfx_royal_die.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize()
	self.bodyparts = {
		["6"] = {Hitgroup = {6}, Health = 300, Bodygroup = 10, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_fl.mdl", IsDead = false}, // Right Front Leg
		["16"] = {Hitgroup = {16}, Health = 150, Bodygroup = 11, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_rf2.mdl", IsDead = false}, // Right Front Joint
		["26"] = {Hitgroup = {26}, Health = 100, Bodygroup = 12, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_rf3.mdl", IsDead = false}, // Right Inner Leg
		["7"] = {Hitgroup = {7}, Health = 300, Bodygroup = 7, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_fl.mdl", IsDead = false}, // Left Front Leg
		["17"] = {Hitgroup = {17}, Health = 150, Bodygroup = 8, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_lf2.mdl", IsDead = false}, // Left Front Joint
		["27"] = {Hitgroup = {27}, Health = 100, Bodygroup = 9, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_lf3.mdl", IsDead = false}, // Left Inner Leg
		["3"] = {Hitgroup = {3}, Health = 250, Bodygroup = 4, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_bl.mdl", IsDead = false}, // Left Back Leg
		["13"] = {Hitgroup = {13}, Health = 150, Bodygroup = 5, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_lb2.mdl", IsDead = false}, // Left Back Joint
		["23"] = {Hitgroup = {23}, Health = 100, Bodygroup = 6, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_lb3.mdl", IsDead = false}, // Left Inner Leg
		["2"] = {Hitgroup = {2}, Health = 250, Bodygroup = 1, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_bl.mdl", IsDead = false}, // Right Back Leg
		["12"] = {Hitgroup = {12}, Health = 150, Bodygroup = 2, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_rb2.mdl", IsDead = false}, // Right Back Joint
		["22"] = {Hitgroup = {22}, Health = 100, Bodygroup = 3, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_rb3.mdl", IsDead = false}, // Right Inner Leg
		["4"] = {Hitgroup = {4}, Health = 150, Bodygroup = 14, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_claw2.mdl", IsDead = false}, // Left Claw
		["5"] = {Hitgroup = {5}, Health = 150, Bodygroup = 13, Gib = "models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_claw2.mdl", IsDead = false} // Right Claw
	}
	self.DivisionRateTotal = 14
	self.NextScreamT = 0
	self.UsingScreamAttack = false
	self.AttackTimersCustom = {"timer_scream_bug","timer_scream_bug_dmg"}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "PMEvent sound step" then
		self:FootStepSoundCode()
		util.ScreenShake(self:GetPos(),14,100,0.6,2300)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Think()
	if self:GetEnemy() != nil then
		if CurTime() > self.NextScreamT then
			if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 3000) && math.random(1,2) == 1 && (self:GetEnemy():GetPos():Distance(self:GetPos()) > 200) && self:GetEnemy():Visible(self) /*&& self.RangeAttacking == false*/ && self.vACT_StopAttacks == false && self.Flinching == false && self.VJ_IsBeingControlled == false then
				if self.MeleeAttacking == false && self.UsingScreamAttack == false && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.SightAngle))) then
					self.NextChaseTime = CurTime() +1.5
					self:VJ_ACT_PLAYACTIVITY(ACT_RANGE_ATTACK1,true,VJ_GetSequenceDuration(self,ACT_RANGE_ATTACK1),true)
					self:EmitSound("stbugs/royal/sfx_royal_roar_normal.mp3",110,100)
					self.UsingScreamAttack = true
					self:StopMoving()
					timer.Simple(1.5,function()
						if IsValid(self) then
							if self:GetEnemy() != nil then
								self:SST_ScreamAttack()
							end
						end
					end)
					timer.Create("timer_scream_bug" .. self.Entity:EntIndex(), VJ_GetSequenceDuration(self,ACT_RANGE_ATTACK1), 1, function()
						self.UsingScreamAttack = false
						self:StopParticles()
						if self.sonic != nil then
							self.sonic:Stop()
						end
					end)
				end
			end
			self.NextScreamT = CurTime() +math.random(5,10)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CheckScreamTrace()
	local tracedata = {}
	tracedata.start = self:GetAttachment(self:LookupAttachment("mouth")).Pos
	tracedata.endpos = self:GetEnemy():GetPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)

	return tr.HitPos
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_ScreamAttack()
	if self:Health() < 0 then return end
	if self.vACT_StopAttacks == true then return end
	if self.Flinching == true then return end
	if self.MeleeAttacking == true then return end
	if self:GetEnemy() != nil && self:GetEnemy():Visible(self) then
		local GetZePos = self:CheckScreamTrace()
		local radiustohit = 200
		self:StopMoving()
		ParticleEffectAttach("stb_royal_roar",PATTACH_POINT_FOLLOW,self,3)
		timer.Create("timer_scream_bug_dmg" .. self.Entity:EntIndex(), 0.2, 10, function()
			for k,v in ipairs(ents.FindInSphere(GetZePos,radiustohit)) do
				if (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(50))) then
					if IsValid(self) && (v != nil) && (v:IsNPC()) then
						local doactualdmg = DamageInfo()
						if self.SelectedDifficulty == 0 then doactualdmg:SetDamage(8/2) end -- Easy
						if self.SelectedDifficulty == 1 then doactualdmg:SetDamage(8) end -- Normal
						if self.SelectedDifficulty == 2 then doactualdmg:SetDamage(8*1.5) end -- Hard
						if self.SelectedDifficulty == 3 then doactualdmg:SetDamage(8*2.5) end -- Hell On Earth
						doactualdmg:SetInflictor(self)
						doactualdmg:SetDamageType(DMG_DIRECT)
						doactualdmg:SetAttacker(self)
						v:TakeDamageInfo(doactualdmg,self)
						VJ_DestroyCombineTurret(self,v)
						self.sonic = CreateSound(v,"player/general/sonic_damage.wav")
						self.sonic:SetSoundLevel(70)
						self.sonic:Play()
					end
					if IsValid(self) && (v != nil) && (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0) then
						local doactualdmg = DamageInfo()
						if self.SelectedDifficulty == 0 then doactualdmg:SetDamage(8/2) end -- Easy
						if self.SelectedDifficulty == 1 then doactualdmg:SetDamage(8) end -- Normal
						if self.SelectedDifficulty == 2 then doactualdmg:SetDamage(8*1.5) end -- Hard
						if self.SelectedDifficulty == 3 then doactualdmg:SetDamage(8*2.5) end -- Hell On Earth
						doactualdmg:SetInflictor(self)
						doactualdmg:SetDamageType(DMG_DIRECT)
						doactualdmg:SetAttacker(self)
						v:TakeDamageInfo(doactualdmg,self)
						self.sonic = CreateSound(v,"player/general/sonic_damage.wav")
						self.sonic:SetSoundLevel(50)
						self.sonic:Play()
					end
				end
			end
		end)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	if self.DivisionRateTotal > 7 then
		dmginfo:ScaleDamage(0.25)
	else
		dmginfo:ScaleDamage(0.11)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_OnBleed(dmginfo,hitgroup)
print(hitgroup)
	-- print(self.DivisionRateTotal)
	for k,ourvalues in pairs(self.bodyparts) do
		for _,v in pairs(ourvalues) do
			if table.HasValue(ourvalues.Hitgroup,hitgroup) then
				self:SelectHitgroupBehavior(ourvalues,v,dmginfo,hitgroup)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SelectHitgroupBehavior(ourvalues,v,dmginfo,hitgroup)
	ourvalues.Health = (ourvalues.Health -dmginfo:GetDamage())
	if ourvalues.Health <= 0 && ourvalues.IsDead == false then
		self:SetBodygroup(ourvalues.Bodygroup,1)
		self:CreateVJHitboxGib(ourvalues.Gib,dmginfo:GetDamagePosition())
		if hitgroup == 4 || hitgroup == 5 then
			self:CreateVJHitboxGib("models/predatorcz/stbugs/uropygi_basilicus_dispositus.pmd/g_claw3.mdl",dmginfo:GetDamagePosition() +Vector(0,0,30))
		end
		ourvalues.IsDead = true
		self.DivisionRateTotal = self.DivisionRateTotal -1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateVJHitboxGib(mdl,pos)
	local gib = ents.Create("prop_physics")
	gib:SetModel(mdl)
	gib:SetPos(pos)
	gib:SetAngles(self:GetAngles())
	gib:Spawn()
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then
		gib:SetCollisionGroup(1)
	end
	cleanup.ReplaceEntity(gib)
	if GetConVarNumber("vj_npc_fadegibs") == 1 then
		gib:Fire("FadeAndRemove","",GetConVarNumber("vj_npc_fadegibstime"))
	end
	local bloodeffect = ents.Create("info_particle_system")
	bloodeffect:SetKeyValue("effect_name",VJ_PICKRANDOMTABLE(self.CustomBlood_Particle))
	bloodeffect:SetPos(self:LocalToWorld(pos))
	bloodeffect:Spawn()
	bloodeffect:Activate() 
	bloodeffect:Fire( "Start", "", 0 )
	bloodeffect:Fire( "Kill", "", 0.1 )
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,1)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.MeleeAttackDamage = 95
		self.MeleeAttackDamageType = DMG_CRUSH
		self.TimeUntilMeleeAttackDamage = 0.5
		self.MeleeAttackExtraTimers = {}
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/