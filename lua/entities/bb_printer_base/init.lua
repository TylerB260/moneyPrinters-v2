AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props_c17/consolebox03a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self:SetTrigger(true)
	
	self.PrinterStats = {}
end

function ENT:FindNearby()
	local nearby = {}
	
	for k, v in pairs(player.GetAll()) do
		if v:GetPos():Distance(self:GetPos()) <= 512 then
			table.insert(nearby, v)
		end
	end
	
	return nearby
end

-- HEALTH --

function ENT:OnTakeDamage(dmg)
	self:SetStat("health", self:GetStat("health") - (dmg:GetDamage() or 0))
	
	if self:GetStat("health") <= 0 then
		self:Remove()
	end
end

-- STATS AND STUFF --

function ENT:SetStat(name, value) -- paper ink money heat fan etc
	if self:GetStatMax(name) > 0 then
		self.PrinterStats[name] = math.max(math.min(self:GetStatMax(name), value), 0)
	else
		self.PrinterStats[name] = value
	end
	
	net.Start("bb_printer_update")
		net.WriteEntity(self)
		net.WriteString(name)
		net.WriteDouble(value)
	net.Send(self:FindNearby())
end

function ENT:BroadcastUpdate()
	for k, v in pairs(self.PrinterStats) do
		net.Start("bb_printer_update")
			net.WriteEntity(self)
			net.WriteString(k)
			net.WriteDouble(v)
		net.Send(self:FindNearby())
	end
end

function ENT:Think() -- increase stuff based on tickrate!!
	local hcol = (self:GetStat("health") / self:GetStatMax("health")) * 255
	
	self:SetColor(Color(255, hcol, hcol))
end

timer.Create("bb_printer_think", 0.1, 0, function()
	for _, e in pairs(ents.GetAll()) do
		if e.PrinterStats then 
			e:Think()
		end
	end
end)

timer.Create("bb_printer_network", 5, 0, function()
	for _, e in pairs(ents.GetAll()) do
		if e.PrinterStats then 
			e:BroadcastUpdate() 
		end
	end
end)