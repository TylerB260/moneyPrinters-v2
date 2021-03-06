include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	
	local pos = self:LocalToWorld(Vector(-3, -5, 4.5));
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	cam.Start3D2D(pos, ang, 0.25)
		if self:GetDistance() < 256 then
			-- paper --
			self:drawRect(2, 2, 48, 69)
			self:drawBar(4, 4, 44, 66, (self:GetStat("paper") / self:GetStatMax("paper")) * 100)
			
			draw.DrawText("Paper", "TargetIDSmall", 25, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("paper")), "TargetID", 25, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("pages", "TargetIDSmall", 25, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/page_copy.png", 26, 31, 16, 16)
		end
	cam.End3D2D()
end