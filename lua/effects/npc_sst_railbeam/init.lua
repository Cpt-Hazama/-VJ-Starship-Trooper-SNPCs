

EFFECT.Mat = Material( "effects/bluelaser1" )

--[[---------------------------------------------------------
Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )
	self.texcoord = math.Rand( 25, 20 )/3
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	

	self.Entity:SetCollisionBounds( self.StartPos -  self.EndPos, Vector( 110, 110, 110 ) )
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos, Vector()*8 )
	
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.Alpha = 255
	self.FlashA = 255
end

function EFFECT:Think( )

	self.FlashA = self.FlashA - 2050 * FrameTime()
	if (self.FlashA < 0) then self.FlashA = 0 end

	self.Alpha = self.Alpha - 1650 * FrameTime()
	if (self.Alpha < 0) then return false end
	
	return true

end


function EFFECT:Render( )
	
	self.Length = (self.StartPos - self.EndPos):Length()
	
	local texcoord = self.texcoord
		render.SetMaterial( Material( "effects/bluelaser2" ) )
		render.DrawBeam( self.StartPos, 										// Start
					 self.EndPos,											// End
					 20,													// Width
					 texcoord,														// Start tex coord
					 texcoord + self.Length / 1500,									// End tex coord
					 Color( 150, 220, 255, 175) )			// Color (optional)
					 
		render.SetMaterial( self.Mat )
		render.DrawBeam( self.StartPos, 										// Start
					 self.EndPos,											// End
					 20,													// Width
					 texcoord,														// Start tex coord
					 texcoord + self.Length / 1500,									// End tex coord
					 Color( 150, 220, 255, 175) )		// Color (optional)
					 

end		