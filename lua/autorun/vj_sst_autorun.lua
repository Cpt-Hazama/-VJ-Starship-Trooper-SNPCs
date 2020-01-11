/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Starship Troopers SNPCs"
local AddonName = "Starship Troopers"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_sst_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	// WEAPONS
	VJ.AddNPCWeapon("VJ_SST_MK2-Carbine","weapon_vj_sst_mk2")
	VJ.AddNPCWeapon("VJ_SST_MK2-Shotgun","weapon_vj_sst_mk2shotgun")
	VJ.AddNPCWeapon("VJ_SST_MK2-Grenade","weapon_vj_sst_mk2grenade")
	VJ.AddNPCWeapon("VJ_SST_MK4","weapon_vj_sst_mk4")
	VJ.AddNPCWeapon("VJ_SST_MK1","weapon_vj_sst_mk1")
	VJ.AddNPCWeapon("VJ_SST_MK2-Sniper","weapon_vj_sst_mk2sniper")
	VJ.AddNPCWeapon("VJ_SST_RailGun","weapon_vj_sst_railgun")
	VJ.AddNPCWeapon("VJ_SST_RocketLauncher","weapon_vj_sst_rocketlauncher")
	VJ.AddNPCWeapon("VJ_SST_QuadRocketLauncher","weapon_vj_sst_quadrocketlauncher")

	local weapontbl = {
		"weapon_vj_sst_mk2",
		"weapon_vj_sst_mk2",
		"weapon_vj_sst_mk2",
		"weapon_vj_sst_mk2",
		"weapon_vj_sst_mk2",
		"weapon_vj_sst_mk2shotgun",
		"weapon_vj_sst_mk2shotgun",
		"weapon_vj_sst_mk2grenade",
		"weapon_vj_sst_mk2grenade",
		"weapon_vj_sst_mk2grenade",
		-- "weapon_vj_sst_mk4",
		-- "weapon_vj_sst_mk1",
		-- "weapon_vj_sst_mk2sniper",
		-- "weapon_vj_sst_railgun",
		"weapon_vj_sst_rocketlauncher",
		"weapon_vj_sst_rocketlauncher",
		"weapon_vj_sst_quadrocketlauncher"
	}

	local vCat = "Starship Troopers"
	// NEW STUFF
	VJ.AddNPC_HUMAN("Mobile Infantry (Male)","npc_vj_sst_mi_male",weapontbl,vCat)
	-- VJ.AddNPC_HUMAN("Mobile Infantry (Female)","npc_vj_sst_mi_female",weapontbl,vCat)

	// ORIGINAL BUGS
	VJ.AddNPC("Blaster","npc_vj_sst_blaster",vCat) // Fires blue projectiles, Blue
	VJ.AddNPC("Chariot","npc_vj_sst_chariot",vCat) // Runs around, Yellow
	VJ.AddNPC("Cliffmite","npc_vj_sst_cliffmite",vCat) // Stationary, fires red projectiles, Orange
	VJ.AddNPC("Federal Bug","npc_vj_sst_federal",vCat) // Standard, Green
	VJ.AddNPC("Heavy Bug","npc_vj_sst_heavy",vCat) // Standard, Green
	VJ.AddNPC("Royal","npc_vj_sst_royal",vCat) // Sonic Attack, Standard, Synth
	VJ.AddNPC("Runner","npc_vj_sst_runner",vCat) // Standard, Green
	VJ.AddNPC("Sentinel","npc_vj_sst_sentinel",vCat) // Creates bright lights, Orange
	VJ.AddNPC("Spitter Invasion","npc_vj_sst_invasion",vCat) // Spits, Standard, Green
	VJ.AddNPC("Tanker","npc_vj_sst_tanker",vCat) // Spits Fire, Headbutt, Orange
	VJ.AddNPC("Tiger","npc_vj_sst_tiger",vCat) // Standard, Green
	VJ.AddNPC("Tiger Elite","npc_vj_sst_elite",vCat) // Fires light blue projectiles, Standard, Blue Special
	VJ.AddNPC("Tiger Spitter","npc_vj_sst_spitter",vCat) // Spits, Standard, Green
	VJ.AddNPC("Warrior","npc_vj_sst_warrior",vCat) // Standard, Green
	VJ.AddNPC("Warrior Invasion","npc_vj_sst_warriorinv",vCat) // Standard, Green
	VJ.AddNPC("Worker","npc_vj_sst_worker",vCat) // Standard, Green
	VJ.AddNPC("X Bug","npc_vj_sst_xbug",vCat) // Summons 3 bugs, Standard, Synth
	VJ.AddNPC("Boss","npc_vj_sst_boss",vCat) // Standard, Green
	VJ.AddNPC("Plasma","npc_vj_sst_plasma",vCat) // Fires Plasma, Standard, Blue
	VJ.AddNPC("Plasma (Young)","npc_vj_sst_plasma_young",vCat) // Fires Plasma, Standard, Blue
	VJ.AddNPC("Hopper","npc_vj_sst_hopper",vCat) // Flys, Standard, Orange

	// Need fixed up/animations
	VJ.AddNPC("Brain Bug","npc_vj_sst_brainbug",vCat)
	VJ.AddNPC("Rhino","npc_vj_sst_rhino",vCat)
	VJ.AddNPC("Tanker (Young)","npc_vj_sst_tanker_young",vCat)

	// EXTRA BUGS
	VJ.AddNPC("Random Bug Spawner","sent_vj_sst_bugspawner",vCat) // Spawns All Smaller Bugs
	-- VJ.AddNPC("Random (Big) Bug Spawner","sent_vj_sst_bigbugspawner",vCat) // Spawns All Big Bugs
	VJ.AddNPC("Random Warrior Spawner","sent_vj_sst_warriorspawner",vCat) // Spawns All Warrior-Type Bugs

	game.AddParticles("particles/stb_impacts.pcf")
	game.AddParticles("particles/stb_plasma.pcf")
	game.AddParticles("particles/flame_tanker.pcf")
	local stb_impacts = {
		"blood_impact_stb_blue",
		"blood_impact_stb_blue_glowing",
		"blood_impact_stb_green",
		"blood_impact_stb_red",
		"blood_impact_stb_red_glowing",
		"blood_impact_stb_yellow",
		"stb_dupydupy",
		"stb_plasma_explosion",
		"stb_plasma_explosion_glow",
		"stb_plasma_explosion_ref_ring",
		"stb_plasma_explosion_sparks",
		"stb_plasma_spit",
		"stb_plasma_warp2",
		"stb_plasma_warp_trail",
		"stb_royal_roar",
		"tanker_flame"
	}

	for _,v in ipairs(stb_impacts) do
		PrecacheParticleSystem(v)
	end

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end