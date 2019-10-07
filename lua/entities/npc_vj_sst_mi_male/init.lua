AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/mobileinfantry/mi_07.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 60
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
ENT.FollowPlayer = true
ENT.HullSizeNormal = false -- set to false to cancel out the self:SetHullSizeNormal()
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_SST_FEDERATION"} -- NPCs with the same class will be friendly to each other | Combine: CLASS_COMBINE, Zombie: CLASS_ZOMBIE, Antlions = CLASS_ANTLION
ENT.PlayerFriendly = true -- Makes the SNPC friendly to the player and HL2 Resistance
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.BloodColor = "Red"
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.DisableFootStepSoundTimer = true
ENT.SquadName = "vj_sst_federation" -- Squad name, console error will happen if two groups that are enemy and try to squad!
ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
ENT.GeneralSoundPitch1 = 90
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	-- if self.IsMale == true then
		self.SoundTbl_Idle = {"vo/npc/male01/busy02.wav","vo/npc/male01/evenodds.wav","vo/npc/male01/doingsomething.wav","vo/npc/male01/docfreeman01.wav","vo/npc/male01/docfreeman02.wav","vo/npc/male01/excuseme01.wav","vo/npc/male01/excuseme02.wav","vo/npc/male01/fantastic01.wav","vo/npc/male01/finally.wav","vo/npc/male01/freeman.wav","vo/npc/male01/getgoingsoon.wav","vo/npc/male01/hacks01.wav","vo/npc/male01/herecomehacks01.wav","vo/npc/male01/heydoc01.wav","vo/npc/male01/holddownspot01.wav","vo/npc/male01/holddownspot02.wav","vo/npc/male01/illstayhere01.wav","vo/npc/male01/nice.wav","vo/npc/male01/pardonme01.wav","vo/npc/male01/question01.wav","vo/npc/male01/question02.wav","vo/npc/male01/question03.wav","vo/npc/male01/question04.wav","vo/npc/male01/question05.wav","vo/npc/male01/question06.wav","vo/npc/male01/question07.wav","vo/npc/male01/question08.wav","vo/npc/male01/question09.wav","vo/npc/male01/question10.wav","vo/npc/male01/whoops01.wav","vo/npc/male01/yeah02.wav","vo/npc/male01/yeah02.wav","vo/npc/male01/yeah02.wav","vo/npc/male01/yeah02.wav","vo/npc/male01/yeah02.wav","vo/npc/male01/yeah02.wav","vo/npc/male01/yeah02.wav"}
		self.SoundTbl_Alert = {"vo/npc/male01/ohno.wav","vo/npc/male01/runforyourlife01.wav","vo/npc/male01/runforyourlife02.wav","vo/npc/male01/watchout.wav"}
		self.SoundTbl_CombatIdle = {"vo/npc/male01/no01.wav","vo/npc/male01/no02.wav","vo/npc/male01/overhere01.wav","vo/npc/male01/uhoh.wav"}
		self.SoundTbl_Pain = {"vo/npc/male01/ow01.wav","vo/npc/male01/ow02.wav"}
		self.SoundTbl_Death = {"vo/npc/male01/pain01.wav","vo/npc/male01/pain02.wav","vo/npc/male01/pain03.wav","vo/npc/male01/pain04.wav","vo/npc/male01/pain05.wav"}
	-- else
		-- self.SoundTbl_Idle = {"vo/npc/female01/busy02.wav","vo/npc/female01/evenodds.wav","vo/npc/female01/doingsomething.wav","vo/npc/female01/docfreeman01.wav","vo/npc/female01/docfreeman02.wav","vo/npc/female01/excuseme01.wav","vo/npc/female01/excuseme02.wav","vo/npc/female01/fantastic01.wav","vo/npc/female01/finally.wav","vo/npc/female01/freeman.wav","vo/npc/female01/getgoingsoon.wav","vo/npc/female01/hacks01.wav","vo/npc/female01/herecomehacks01.wav","vo/npc/female01/heydoc01.wav","vo/npc/female01/holddownspot01.wav","vo/npc/female01/holddownspot02.wav","vo/npc/female01/illstayhere01.wav","vo/npc/female01/nice.wav","vo/npc/female01/pardonme01.wav","vo/npc/female01/question01.wav","vo/npc/female01/question02.wav","vo/npc/female01/question03.wav","vo/npc/female01/question04.wav","vo/npc/female01/question05.wav","vo/npc/female01/question06.wav","vo/npc/female01/question07.wav","vo/npc/female01/question08.wav","vo/npc/female01/question09.wav","vo/npc/female01/question10.wav","vo/npc/female01/whoops01.wav","vo/npc/female01/yeah02.wav","vo/npc/female01/yeah02.wav","vo/npc/female01/yeah02.wav","vo/npc/female01/yeah02.wav","vo/npc/female01/yeah02.wav","vo/npc/female01/yeah02.wav","vo/npc/female01/yeah02.wav"}
		-- self.SoundTbl_Alert = {"vo/npc/female01/ohno.wav","vo/npc/female01/runforyourlife01.wav","vo/npc/female01/runforyourlife02.wav","vo/npc/female01/watchout.wav"}
		-- self.SoundTbl_CombatIdle = {"vo/npc/female01/no01.wav","vo/npc/female01/no02.wav","vo/npc/female01/overhere01.wav","vo/npc/female01/uhoh.wav"}
		-- self.SoundTbl_Pain = {"vo/npc/female01/ow01.wav","vo/npc/female01/ow02.wav"}
		-- self.SoundTbl_Death = {"vo/npc/female01/pain01.wav","vo/npc/female01/pain02.wav","vo/npc/female01/pain03.wav","vo/npc/female01/pain04.wav","vo/npc/female01/pain05.wav"}
	-- end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/