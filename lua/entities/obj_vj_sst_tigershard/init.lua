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
ENT.Model = {"models/predatorcz/stbugs/uropygi_tigris_elitus.pmd/projectile.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 10 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 25 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageType = DMG_DIRECT -- Damage type
ENT.PaintDecalOnDeath = false -- Should it paint a decal when it hits something?
	-- Sounds ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasIdleSounds = false -- Does it have idle sounds?
ENT.HasOnCollideSounds = true -- Should it play a sound when it collides something?
ENT.SoundTbl_OnCollide = {"stbugs/shared/sfx_bullet_impact_bug.mp3"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.CurrentGlow = ents.Create( "env_sprite" )
	self.CurrentGlow:SetKeyValue( "rendercolor","0 208 255 112" )
	self.CurrentGlow:SetKeyValue( "GlowProxySize","2.0" )
	self.CurrentGlow:SetKeyValue( "HDRColorScale","1.0" )
	self.CurrentGlow:SetKeyValue( "renderfx","14" )
	self.CurrentGlow:SetKeyValue( "rendermode","3" )
	self.CurrentGlow:SetKeyValue( "renderamt","255" )
	self.CurrentGlow:SetKeyValue( "disablereceiveshadows","0" )
	self.CurrentGlow:SetKeyValue( "mindxlevel","0" )
	self.CurrentGlow:SetKeyValue( "maxdxlevel","0" )
	self.CurrentGlow:SetKeyValue( "framerate","10.0" )
	self.CurrentGlow:SetKeyValue( "model","sprites/blueflare1.spr" )
	self.CurrentGlow:SetKeyValue( "spawnflags","0" )
	self.CurrentGlow:SetKeyValue( "scale","0.1" )
	self.CurrentGlow:SetPos(self:GetPos())
	self.CurrentGlow:SetParent(self)
	self.CurrentGlow:Spawn()
	self:DeleteOnRemove(self.CurrentGlow)
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/