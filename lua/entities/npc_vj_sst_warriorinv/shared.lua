ENT.Base 			= "npc_vj_sst_warrior"
ENT.Type 			= "ai"
ENT.PrintName 		= "Warrior Invasion"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "SST"

if (CLIENT) then
local Name = "Warrior Invasion"
local LangName = "npc_vj_sst_warriorinv"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end