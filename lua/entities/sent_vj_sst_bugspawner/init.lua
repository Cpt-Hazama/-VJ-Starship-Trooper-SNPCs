AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/props_junk/popcan01a.mdl"} -- The models it should spawn with | Picks a random one from the table
local bugtbl = {
	"npc_vj_sst_federal",
	"npc_vj_sst_federal",
	"npc_vj_sst_federal",
	"npc_vj_sst_federal",
	"npc_vj_sst_heavy",
	"npc_vj_sst_runner",
	"npc_vj_sst_runner",
	"npc_vj_sst_runner",
	"npc_vj_sst_runner",
	"npc_vj_sst_runner",
	"npc_vj_sst_runner",
	"npc_vj_sst_runner",
	"npc_vj_sst_invasion",
	"npc_vj_sst_invasion",
	"npc_vj_sst_invasion",
	"npc_vj_sst_tiger",
	"npc_vj_sst_tiger",
	"npc_vj_sst_tiger",
	"npc_vj_sst_tiger",
	"npc_vj_sst_tiger",
	"npc_vj_sst_elite",
	"npc_vj_sst_spitter",
	"npc_vj_sst_spitter",
	"npc_vj_sst_spitter",
	"npc_vj_sst_spitter",
	"npc_vj_sst_warrior",
	"npc_vj_sst_warriorinv",
	"npc_vj_sst_worker",
	"npc_vj_sst_warrior",
	"npc_vj_sst_warriorinv",
	"npc_vj_sst_worker",
	"npc_vj_sst_warrior",
	"npc_vj_sst_warriorinv",
	"npc_vj_sst_worker",
	"npc_vj_sst_worker",
	"npc_vj_sst_worker",
	"npc_vj_sst_worker",
	"npc_vj_sst_worker",
	"npc_vj_sst_worker",
	"npc_vj_sst_boss"
}
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=100,vRight=0,vUp=0},Entities = bugtbl},
	{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=150,vUp=0},Entities = bugtbl},
	{EntityName = "NPC3",SpawnPosition = {vForward=150,vRight=150,vUp=0},Entities = bugtbl},
	{EntityName = "NPC4",SpawnPosition = {vForward=150,vRight=-150,vUp=0},Entities = bugtbl},
	{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-150,vUp=0},Entities = bugtbl}
}


/*-----------------------------------------------
	*** Copyright (c) 2012-2016 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/