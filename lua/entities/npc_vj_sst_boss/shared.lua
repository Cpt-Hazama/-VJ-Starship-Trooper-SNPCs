ENT.Base 			= "npc_vj_sst_warrior"
ENT.Type 			= "ai"
ENT.PrintName 		= "Boss"
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "SST"

if (CLIENT) then
local Name = "Boss"
local LangName = "npc_vj_sst_boss"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end