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

ENT.HasRangeAttack = true
ENT.RangeDistance = 500
ENT.RangeToMeleeDistance = 120
ENT.DisableDefaultRangeAttackCode = true

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDamage = 18
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.MeleeAttackDistance = 50 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 180 -- How far the damage goes
ENT.TimeUntilMeleeAttackDamage = 0.4 -- This counted in seconds | This calculates the time until it hits something
ENT.UntilNextAttack_Melee = false -- How much time until it can use a attack again? | Counted in Seconds

ENT.Aerial_FlyingSpeed_Calm = 850 -- The speed it should fly with, when it's wandering, moving slowly, etc. | Basically walking campared to ground SNPCs
ENT.Aerial_FlyingSpeed_Alerted = 1000 -- The speed it should fly with, when it's chasing an enemy, moving away quickly, etc. | Basically running campared to ground SNPCs
ENT.Aerial_AnimTbl_Calm = {"glide_swing"} -- Animations it plays when it's wandering around while idle
ENT.Aerial_AnimTbl_Alerted = {"glide","glide_swing"} -- Animations it plays when it's moving while alerted
ENT.AA_ConstantlyMove = true -- Used for aerial and aquatic SNPCs, makes them constantly move

ENT.CollisionBounds = Vector(35,40,90)
ENT.Aerial_AnimTbl_Up = {"glide_swing"}
ENT.Aerial_AnimTbl_Down = {"glide"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(self.CollisionBounds.x,self.CollisionBounds.y,self.CollisionBounds.z),-(Vector(self.CollisionBounds.x,self.CollisionBounds.y,0)))
	self:SST_Initialize()
    self.Flame = ents.Create("info_particle_system")
	self.Flame:SetKeyValue("effect_name","tanker_flame")
	self.Flame:SetParent(self)
	self.Flame:Spawn()
	self.Flame:Activate()
	self.Flame:Fire("SetParentAttachment","forward",0)
	self.FlameLoop = CreateSound(self,"stbugs/tanker/sfx_tanker_fire.mp3")
	self.FlameLoop:SetSoundLevel(82)
	self.FlameActive = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartFlame()
	self.Flame:Fire("Start","",0)
	self.FlameLoop:Play()
	self.FlameActive = true
	timer.Simple(0.75,function()
		if IsValid(self) then
			self:EndFlame()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:EndFlame()
	self.Flame:Fire("Stop","",0)
	self.FlameLoop:Stop()
	self.FlameActive = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key,activator,caller,data)
	-- print(key)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRangeAttack_AfterStartTimer()
	timer.Simple(0.4,function() if IsValid(self) && self.RangeAttacking then self:StartFlame() end end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetFlyMode(fly)
	if fly then
		self:DoChangeMovementType(VJ_MOVETYPE_AERIAL)
		self.AnimTbl_IdleStand = {ACT_FLY}
		self.TurningUseAllAxis = true
		self.TurningSpeed = 12
		self.HasMeleeAttack = false
		self.HasRangeAttack = false
		self:EndFlame()
	else
		self:DoChangeMovementType(VJ_MOVETYPE_GROUND)
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self.TurningSpeed = 28
		self.HasMeleeAttack = true
		self.HasRangeAttack = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SST_Initialize() end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:VJ_TASK_IDLE_WANDER()
	if self.MovementType == VJ_MOVETYPE_AERIAL or self.MovementType == VJ_MOVETYPE_AQUATIC then self:AAMove_Wander(true) return end
	if self.MovementType == VJ_MOVETYPE_GROUND && math.random(1,5) == 1 then
		self:SetFlyMode(true)
		return
	end
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Walk))
	local vsched = ai_vj_schedule.New("vj_idle_wander")
	//self:SetLastPosition(self:GetPos() + self:GetForward() * 300)
	//vsched:EngTask("TASK_SET_ROUTE_SEARCH_TIME", 0)
	//vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	vsched:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 350)
	//vsched:EngTask("TASK_WALK_PATH", 0)
	vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
	vsched.ResetOnFail = true
	vsched.CanBeInterrupted = true
	vsched.IsMovingTask = true
	vsched.IsMovingTask_Walk = true
	self:StartSchedule(vsched)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self:CapabilitiesAdd(CAP_MOVE_JUMP)
	if !self.RangeAttacking then
		self:EndFlame()
	end
	if self.FlameActive then
		local entities = ents.FindInBox(self:LocalToWorld(Vector(50,-70,-8.5)),self:LocalToWorld(Vector(750,64,95)))
		for _,v in pairs(entities) do
			if ((((v:IsPlayer() && v:Alive()) || v:IsNPC()) && (self:Disposition(v) == 1 || self:Disposition(v) == 2))) then
				v:Ignite(4,0)
				v:TakeDamage(4,self,self)
			end
		end
	end
	local enemy = self:GetEnemy()
	if IsValid(enemy) && self.MovementType == VJ_MOVETYPE_AERIAL then
		if self:VJ_GetNearestPointToEntityDistance(enemy) <= 500 && self:Visible(enemy) then
			local tr = util.TraceHull({
				start = self:GetPos(),
				endpos = (self:GetPos() +self:GetForward() *50) +Vector(0,0,-32000),
				filter = self,
				mins = self:OBBMins(),
				maxs = self:OBBMaxs()
			})
			if tr.Hit && tr.HitWorld then
				self:AAMove_CorrectWayToDoThisShit(tr.HitPos,true)
				if self:GetPos():Distance(tr.HitPos) <= 200 then
					self:SetFlyMode(false)
				end
			end
		end
	end
	if IsValid(enemy) then
		if self.MovementType == VJ_MOVETYPE_GROUND then
			local height = self:GetPos().z
			local ene_height = enemy:GetPos().z
			if self:VJ_GetNearestPointToEntityDistance(enemy) > 1200 && ene_height > height && height <= 1 && self:Visible(enemy) then
				self:SetFlyMode(true)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.LastAAPosition = Vector(0,0,0)
function ENT:AAMove_Wander(ShouldPlayAnim,NoFace)
	local calmspeed = self.Aerial_FlyingSpeed_Calm
	local ForceDown = ForceDown or false
	local moveMin = 1000
	local moveMax = 2500
	if self.MovementType == VJ_MOVETYPE_AQUATIC then
		if self:WaterLevel() < 3 then self:AAMove_Stop() ForceDown = true end
		calmspeed = self.Aquatic_SwimmingSpeed_Calm
	end
	
	local Debug = self.AA_EnableDebug
	ShouldPlayAnim = ShouldPlayAnim or false
	NoFace = NoFace or false

	if ShouldPlayAnim == true then
		self.AA_CanPlayMoveAnimation = true
		self.AA_CurrentMoveAnimationType = "Calm"
	else
		self.AA_CanPlayMoveAnimation = false
	end
	//if NoFace == false then self:SetLocalAngularVelocity(Angle(0,math.random(0,360),0)) end
	local x_neg = 1
	local y_neg = 1
	local z_neg = 1
	if math.random(1,2) == 1 then x_neg = -1 end
	if math.random(1,2) == 1 then y_neg = -1 end
	if math.random(1,2) == 1 then z_neg = -1 end
	local tr_startpos = self:GetPos()
	local tr_endpos = tr_startpos + self:GetForward()*((self:OBBMaxs().x + math.random(moveMin,moveMax))*x_neg) + self:GetRight()*((self:OBBMaxs().y + math.random(moveMin,moveMax))*y_neg) + self:GetUp()*((self:OBBMaxs().z + math.random(moveMin,moveMax))*z_neg)
	if ForceDown == true then
		tr_endpos = tr_startpos + self:GetUp()*((self:OBBMaxs().z + math.random(moveMin,moveMax -50))*-1)
	end
	/*local tr_for = math.random(-300,300)
	local tr_up = math.random(-300,300)
	local tr_right = math.random(-300,300)
	local tr = util.TraceLine({start = tr_startpos, endpos = tr_startpos+self:GetForward()*tr_for+self:GetRight()*tr_up+self:GetUp()*tr_right, filter = self})*/
	local tr = util.TraceLine({start = tr_startpos, endpos = tr_endpos, filter = self})
	local finalpos = tr.HitPos
	if ForceDown == false && self.MovementType == VJ_MOVETYPE_AERIAL then -- Yete ches estibergor vor var yerta YEV loghatsough SNPC che, sharnage...
		local tr_check = util.TraceLine({start = finalpos, endpos = finalpos + Vector(0,0,-100), filter = self})
		if tr_check.HitWorld == true then -- Yete askharin zargav, ere vor shad var chishne
			finalpos = finalpos + self:GetUp()*(100 - tr_check.HitPos:Distance(finalpos))
		end
	end
	//self.AA_TargetPos = finalpos
	
	-- Angle time test (PHYSICS)
	/*local test1 = math.AngleDifference(tr.StartPos:Angle().y, self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle()).y)
	local test2 = (math.rad(test1) / math.rad(self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle()).y)) * 20
	self.yep = CurTime() + math.abs(test2)
	self.yep2 = self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle())*/
	
	if NoFace == false then self.CurrentTurningAngle = self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle()) end //self:SetLocalAngularVelocity(self:VJ_ReturnAngle((finalpos-tr.StartPos):Angle())) end
	if Debug == true then
		VJ_CreateTestObject(finalpos,self:GetAngles(),Color(0,255,255),5)
		util.ParticleTracerEx("Weapon_Combine_Ion_Cannon_Beam",tr.StartPos,finalpos,false,self:EntIndex(),0)
	end

	-- Set the velocity
	//local myvel = self:GetVelocity()
	local vel_set = (finalpos-self:GetPos()):GetNormal()*calmspeed
	local vel_len = CurTime() + (finalpos:Distance(tr_startpos) / vel_set:Length())
	self.AA_MoveLength_Chase = 0
	if vel_len == vel_len then -- Check for NaN
		self.AA_MoveLength_Wander = vel_len
		self.NextIdleTime = vel_len
	end
	self.LastAAPosition = finalpos
	self:SetLocalVelocity(vel_set)
	if Debug == true then ParticleEffect("vj_impact1_centaurspit", finalpos, Angle(0,0,0), self) end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_CorrectWayToDoThisShit(pos,ShouldPlayAnim,vAdditionalFeatures)
	vAd_AdditionalFeatures = vAdditionalFeatures or {}
	vAd_PosForward = vAd_AdditionalFeatures.PosForward or 1 -- This will add the given value to the set position's forward
	vAd_PosUp = vAd_AdditionalFeatures.PosUp or 1 -- This will add the given value to the set position's up
	vAd_PosRight = vAd_AdditionalFeatures.PosRight or 1 -- This will add the given value to the set position's right
	local MoveSpeed = self.Aerial_FlyingSpeed_Calm

	local Debug = self.AA_EnableDebug
	ShouldPlayAnim = ShouldPlayAnim or false
	NoFace = NoFace or false

	if ShouldPlayAnim == true then
		self.AA_CanPlayMoveAnimation = true
		self.AA_CurrentMoveAnimationType = "Calm"
	else
		self.AA_CanPlayMoveAnimation = false
	end

	-- Main Calculations
	local enepos = (pos)
	local startpos = self:GetPos()

	-- Z Calculations
	local vel_up = MoveSpeed

	-- Set the velocity
	if vel_stop == false then
		//local myvel = self:GetVelocity()
		//local enevel = Ent:GetVelocity()
		local vel_set = ((enepos) - (self:GetPos() + self:OBBCenter())):GetNormal()*MoveSpeed + self:GetUp()*vel_up + self:GetForward()*vel_for
		//local vel_set_yaw = vel_set:Angle().y
		self.CurrentTurningAngle = self:VJ_ReturnAngle(self:VJ_ReturnAngle((vel_set):Angle()))
		//self:SetAngles(self:VJ_ReturnAngle((vel_set):Angle()))
		self:SetLocalVelocity(vel_set)
		local vel_len = CurTime() + (tr.HitPos:Distance(startpos) / vel_set:Length())
		self.AA_MoveLength_Wander = 0
		if vel_len == vel_len then -- Check for NaN
			self.AA_MoveLength_Chase = vel_len
			self.NextIdleTime = vel_len
		end
		self.LastAAPosition = enepos
		if Debug == true then ParticleEffect("vj_impact1_centaurspit", enepos, Angle(0,0,0), self) end
	else
		self:AAMove_Stop()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AAMove_Animation()
	if self:GetSequence() != self.CurrentAnim_AAMovement && self:BusyWithActivity() == false /*&& self:GetActivity() == ACT_IDLE*/ && CurTime() > self.AA_NextMovementAnimation then
		local animtbl = {}
		if self.AA_CurrentMoveAnimationType == "Calm" then
			if self.MovementType == VJ_MOVETYPE_AQUATIC then
				animtbl = self.Aquatic_AnimTbl_Calm
			else
				animtbl = self.Aerial_AnimTbl_Calm
			end
		elseif self.AA_CurrentMoveAnimationType == "Alert" then
			if self.MovementType == VJ_MOVETYPE_AQUATIC then
				animtbl = self.Aquatic_AnimTbl_Alerted
			else
				animtbl = self.Aerial_AnimTbl_Alerted
			end
		end
		if self.LastAAPosition && self.LastAAPosition.z < self:GetPos().z then
			animtbl = self.Aerial_AnimTbl_Down
		else
			animtbl = self.Aerial_AnimTbl_Up
		end
		local pickedanim = VJ_PICK(animtbl)
		if type(pickedanim) == "number" then pickedanim = self:GetSequenceName(self:SelectWeightedSequence(pickedanim)) end
		local idleanimid = VJ_GetSequenceName(self,pickedanim)
		self.CurrentAnim_AAMovement = idleanimid
		//self:AddGestureSequence(idleanimid)
		self:VJ_ACT_PLAYACTIVITY(pickedanim,false,0,false,0,{AlwaysUseSequence=true,SequenceDuration=false,SequenceInterruptible=true})
		self.AA_NextMovementAnimation = CurTime() + VJ_GetSequenceDuration(self,self.CurrentAnim_AAMovement)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	self.FlameLoop:Stop()
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/