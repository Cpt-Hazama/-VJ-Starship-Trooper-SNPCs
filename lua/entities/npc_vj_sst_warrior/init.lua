AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/predatorcz/stbugs/uropygi.pmd/model.mdl" -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 300
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.VJ_NPC_Class = {"CLASS_SSTBUG"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.CustomBlood_Particle = {"blood_impact_stb_green"} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {"VJ_Blood_Green"} -- Decals to spawn when it's damaged

ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.45 -- Next foot step sound when it is walking
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.GeneralSoundPitch1 = 100
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 188 -- How far the damage goes
ENT.UntilNextAttack_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.DisableFootStepSoundTimer = true

ENT.MeleeAttackBleedEnemy = true -- Should the enemy bleed when attacked by melee?
ENT.MeleeAttackBleedEnemyChance = 2 -- How much chance there is that the enemy will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 2 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 50 -- How many reps?

ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 50 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 75 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 15 -- How much time until player's Speed resets
-- Custom -----------------------------------------------------------------------------------------------------------------------------------
ENT.CollisionBounds = Vector(40,40,108)
ENT.SST_HasGibs = true
ENT.SoundTbl_FootStep = {"npc/antlion/shell_impact1.wav","npc/antlion/shell_impact2.wav","npc/antlion/shell_impact3.wav","npc/antlion/shell_impact4.wav"}
ENT.SoundTbl_Alert = {"stbugs/warrior/sfx_warrior_alert_01.mp3","stbugs/warrior/sfx_warrior_alert_02mp3","stbugs/warrior/sfx_warrior_alert_03.mp3"}
ENT.SoundTbl_Idle = {"stbugs/warrior/sfx_warrior_idle_01.mp3","stbugs/warrior/sfx_warrior_idle_02.mp3","stbugs/warrior/sfx_warrior_idle_03.mp3","stbugs/warrior/sfx_warrior_idle_04.mp3"}
ENT.SoundTbl_Pain = {"stbugs/warrior/sfx_warrior_screech_normal1.mp3","stbugs/warrior/sfx_warrior_screech_normal2.mp3","stbugs/warrior/sfx_warrior_screech_normal3.mp3","stbugs/warrior/sfx_warrior_screech_shot1.mp3","stbugs/warrior/sfx_warrior_screech_shot2.mp3"}
ENT.SoundTbl_Death = {"stbugs/warrior/sfx_warrior_die_05.mp3","stbugs/warrior/sfx_warrior_die_06.mp3","stbugs/warrior/sfx_warrior_die_07.mp3","stbugs/warrior/sfx_warrior_die_08.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(self.CollisionBounds.x,self.CollisionBounds.y,self.CollisionBounds.z),-(Vector(self.CollisionBounds.x,self.CollisionBounds.y,0)))
	self:SST_Initialize()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	if key == "PMEvent sound step" then
		self:FootStepSoundCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Think() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,3)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
		self.MeleeAttackDamage = 28
		self.MeleeAttackDamageType = DMG_SLASH
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {}
	elseif randattack == 2 then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
		self.MeleeAttackDamage = 31
		self.MeleeAttackDamageType = DMG_DIRECT
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {0.66}
	elseif randattack == 3 then
		self.AnimTbl_MeleeAttack = {ACT_SPECIAL_ATTACK1}
		self.MeleeAttackDamage = 22
		self.MeleeAttackDamageType = DMG_SLASH
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackExtraTimers = {0.64}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if self.SST_HasGibs == false then return end
	local explodegib = dmginfo:GetDamageType()
	if explodegib == DMG_BLAST or explodegib == DMG_DIRECT or explodegib == DMG_DISSOLVE or explodegib == DMG_AIRBOAT or explodegib == DMG_SLOWBURN or explodegib == DMG_PHYSGUN or explodegib == DMG_PLASMA or explodegib == DMG_SHOCK or explodegib == DMG_SONIC or explodegib == DMG_VEHICLE or explodegib == DMG_CRUSH then
		self.HasDeathRagdoll = false
		self.HasDeathAnimation = false
	
		if GetConVarNumber("vj_npc_sd_gibbing") == 0 then
			self:EmitSound( "vj_gib/default_gib_splat.wav",90,math.random(80,100))
			self:EmitSound( "vj_gib/gibbing1.wav",90,math.random(80,100))
			self:EmitSound( "vj_gib/gibbing2.wav",90,math.random(80,100))
			self:EmitSound( "vj_gib/gibbing3.wav",90,math.random(80,100))
		end
	
		if GetConVarNumber("vj_npc_nogibdeathparticles") == 0 then
			local bloodeffect = ents.Create( "info_particle_system" )
			bloodeffect:SetKeyValue( "effect_name",VJ_PICKRANDOMTABLE(self.CustomBlood_Particle) )
			bloodeffect:SetPos( self:GetPos() + Vector(0,0,50) ) -- Right -- Back -- Up
			bloodeffect:Spawn()
			bloodeffect:Activate() 
			bloodeffect:Fire( "Start", "", 0 )
			bloodeffect:Fire( "Kill", "", 0.1 )
			
			local bloodeffect1 = ents.Create( "info_particle_system" )
			bloodeffect1:SetKeyValue( "effect_name",VJ_PICKRANDOMTABLE(self.CustomBlood_Particle) )
			bloodeffect1:SetPos( self:GetPos() + Vector(10,0,50) ) -- Right -- Back -- Up
			bloodeffect1:Spawn()
			bloodeffect1:Activate() 
			bloodeffect1:Fire( "Start", "", 0 )
			bloodeffect1:Fire( "Kill", "", 0.1 )
			
			local bloodeffect2 = ents.Create( "info_particle_system" )
			bloodeffect2:SetKeyValue( "effect_name",VJ_PICKRANDOMTABLE(self.CustomBlood_Particle) )
			bloodeffect2:SetPos( self:GetPos() + Vector(-10,0,50) ) -- Right -- Back -- Up
			bloodeffect2:Spawn()
			bloodeffect2:Activate() 
			bloodeffect2:Fire( "Start", "", 0 )
			bloodeffect2:Fire( "Kill", "", 0.1 )
			
			local bloodeffect3 = ents.Create( "info_particle_system" )
			bloodeffect3:SetKeyValue( "effect_name",VJ_PICKRANDOMTABLE(self.CustomBlood_Particle) )
			bloodeffect3:SetPos( self:GetPos() + Vector(0,0,20) ) -- Right -- Back -- Up
			bloodeffect3:Spawn()
			bloodeffect3:Activate() 
			bloodeffect3:Fire( "Start", "", 0 )
			bloodeffect3:Fire( "Kill", "", 0.1 )
			
			local bloodeffect4 = ents.Create( "info_particle_system" )
			bloodeffect4:SetKeyValue( "effect_name",VJ_PICKRANDOMTABLE(self.CustomBlood_Particle) )
			bloodeffect4:SetPos( self:GetPos() + Vector(0,0,70) ) -- Right -- Back -- Up
			bloodeffect4:Spawn()
			bloodeffect4:Activate() 
			bloodeffect4:Fire( "Start", "", 0 )
			bloodeffect4:Fire( "Kill", "", 0.1 )
			
			local bloodeffect5 = ents.Create( "info_particle_system" )
			bloodeffect5:SetKeyValue( "effect_name",VJ_PICKRANDOMTABLE(self.CustomBlood_Particle) )
			bloodeffect5:SetPos( self:GetPos() + Vector(0,0,25) ) -- Right -- Back -- Up
			bloodeffect5:Spawn()
			bloodeffect5:Activate() 
			bloodeffect5:Fire( "Start", "", 0 )
			bloodeffect5:Fire( "Kill", "", 0.1 )
		end

		//															| forward/back | left/right | up/down |
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_head.mdl",Vector(18,0,72)) // Upper Jaw
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_jaw.mdl",Vector(20,0,64)) // Lower Jaw
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_body.mdl",Vector(0,0,70)) // Main Body

		//Left Side
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_claw1.mdl",Vector(4,15,75)) // Start Claw
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_claw2.mdl",Vector(20,15,76)) // Joint Claw
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_claw3.mdl",Vector(-2,15,90)) // End Claw
		
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_fl1.mdl",Vector(6,14,62)) // Start Front Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_fl2.mdl",Vector(22,20,38)) // Joint Front Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_fl3.mdl",Vector(38,23,60)) // End Front Leg

		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_bl1.mdl",Vector(-6,14,62)) // Start Back Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_bl2.mdl",Vector(-22,20,38)) // Joint Back Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_bl3.mdl",Vector(-38,23,60)) // End Back Leg

		//Right Side
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_claw1.mdl",Vector(4,-15,75)) // Start Claw
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_claw2.mdl",Vector(20,-15,76)) // Joint Claw
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_claw3.mdl",Vector(-2,-15,90)) // End Claw

		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_fl1.mdl",Vector(6,-14,62)) // Start Front Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_fl2.mdl",Vector(22,-20,38)) // Joint Front Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_fl3.mdl",Vector(38,-23,60)) // End Front Leg

		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_bl1.mdl",Vector(-6,-14,62)) // Start Back Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_bl2.mdl",Vector(-22,-20,38)) // Joint Back Leg
		self:CreateVJGib("models/predatorcz/stbugs/uropygi.pmd/g_bl3.mdl",Vector(-38,-23,60)) // End Back Leg
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CreateVJGib(mdl,pos)
	local gib = ents.Create("prop_physics")
	gib:SetModel(mdl)
	gib:SetPos(self:LocalToWorld(pos)) -- forward/back, left/right, up/down
	gib:SetAngles(self:GetAngles())
	gib:Spawn()
	gib:SetModelScale(self:GetModelScale())
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then
		gib:SetCollisionGroup(1)
	end
	gib:GetPhysicsObject():AddVelocity(self:GetRight() *math.random(math.random(-700,700),math.random(-800,800)) +self:GetForward() *math.random(-300,300))
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
function ENT:CustomOnThink_AIEnabled()
	self:SST_Think()
	self.NextMeleeAttackTime = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation)
	self.NextAnyAttackTime_Melee = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation)end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	self:SetBodygroup(0,1)
	self:SetBodygroup(3,2)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/