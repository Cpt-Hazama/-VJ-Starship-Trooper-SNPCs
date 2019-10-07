include('shared.lua')

language.Add("obj_vj_sst_tigershard", "Tiger Shard")
killicon.Add("obj_vj_sst_tigershard","HUD/killicons/default",Color(255,80,0,255))

language.Add("#obj_vj_sst_tigershard", "Tiger Shard")
killicon.Add("#obj_vj_sst_tigershard","HUD/killicons/default",Color(255,80,0,255))

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:OnRemove()
end
