if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
local NAME = "MK2 Carbine"
local MDL = "models/weapons/w_morita_shotgun.mdl"
local HOLD = "ar2"
local DMG = 5
local FORCE = 3
local CLIP = 20
local FIRERATE = 0.8
local MUZZLE = 1
local SHELL = 2
local SND = {"stweapons/mk2_scatter.wav"}
local SNDRELOAD = {}
local SHOOTEXTRA = false
local EXTRATIME01 = 0.04
local EXTRATIME02 = 0.08
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= FIRERATE -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 0.001 -- How much time until the bullet/projectile is fired?
SWEP.MadeForNPCsOnly 			= true
SWEP.NPC_ReloadSound			= SNDRELOAD
SWEP.PrintName					= NAME
SWEP.ViewModel					= "models/error.mdl"
SWEP.WorldModel					= MDL
SWEP.HoldType 					= HOLD
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
SWEP.Author 					= "Cpt. Hazama"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "This weapon is made for NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
-- SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 4 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= DMG -- Damage
SWEP.Primary.Force				= FORCE -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= CLIP -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.3 -- Time until it can shoot again
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "SMG1" -- Ammo type
SWEP.Primary.Sound				= SND // Weapon_RPG.Single
SWEP.Primary.HasDistantSound	= false -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= SNDFAR // Weapon_RPG.NPC_Single
SWEP.Primary.NumberOfShots		= 7 -- How many shots per attack?
SWEP.Primary.Cone				= 12 -- How accurate is the bullet? (Players)
SWEP.PrimaryEffects_MuzzleAttachment = MUZZLE
SWEP.PrimaryEffects_ShellAttachment = SHELL
SWEP.PrimaryEffects_ShellType = "VJ_Weapon_RifleShell1"
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 1 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Reload_TimeUntilAmmoIsSet	= 1.8 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 2.2 -- How much time until the player can play idle animation, shoot, etc.
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnFireAnimationEvent(pos,ang,event,options)
	if event == 5001 then return true end 
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPC_ServerNextFire()
	if (CLIENT) then return end
	if !self:IsValid() && !IsValid(self.Owner) && !self.Owner:IsValid() && !self.Owner:IsNPC() then return end
	if self:IsValid() && IsValid(self.Owner) && self.Owner:IsValid() && self.Owner:IsNPC() && self.Owner:GetActivity() == nil then return end

	self:RunWorldModelThink()
	self:CustomOnThink()
	self:CustomOnNPC_ServerThink()

	if self.Owner.HasDoneReloadAnimation == false && self.AlreadyPlayedNPCReloadSound == false && (VJ_IsCurrentAnimation(self.Owner,self.CurrentAnim_WeaponReload) or VJ_IsCurrentAnimation(self.Owner,self.CurrentAnim_ReloadBehindCover) or VJ_IsCurrentAnimation(self.Owner,self.NPC_ReloadAnimationTbl) or VJ_IsCurrentAnimation(self.Owner,self.NPC_ReloadAnimationTbl_Custom)) then
		self.Owner.NextThrowGrenadeT = self.Owner.NextThrowGrenadeT + 2
		self.Owner.HasDoneReloadAnimation = true
		//self.Owner.IsReloadingWeapon = false
		self:CustomOnNPC_Reload()
		self.AlreadyPlayedNPCReloadSound = true
		if self.NPC_HasReloadSound == true then VJ_EmitSound(self.Owner,self.NPC_ReloadSound,self.NPC_ReloadSoundLevel) end
		timer.Simple(3,function() if IsValid(self) then self.AlreadyPlayedNPCReloadSound = false end end)
	end

	local function FireCode()
		timer.Simple(EXTRATIME01, function() if IsValid(self) then self:NPCShoot_PrimaryExtra(ShootPos,ShootDir) end end)
		timer.Simple(EXTRATIME02, function() if IsValid(self) then self:NPCShoot_PrimaryExtra(ShootPos,ShootDir) end end)
		timer.Simple(self.NPC_NextPrimaryFire, function() if IsValid(self) then self:NPCShoot_Primary(ShootPos,ShootDir) end end)
		hook.Remove("Think",self)
		timer.Simple(self.NPC_NextPrimaryFire +0.01, function() hook.Add("Think",self,self.NPC_ServerNextFire) end)
	end
	if self:NPCAbleToShoot() == true then FireCode() end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:NPCShoot_PrimaryExtra(ShootPos,ShootDir)
	if SHOOTEXTRA == false then return end
	if (!self:IsValid()) or (!self.Owner:IsValid()) then return end
	if (!self.Owner:GetEnemy()) then return end
	if self.Owner.IsVJBaseSNPC == true then
		self.Owner.Weapon_TimeSinceLastShot = 0
		self.Owner.NextWeaponAttackAimPoseParametersReset = CurTime() + 1
		self.Owner:WeaponAimPoseParameters()
	end
	self:PrimaryAttack()
end