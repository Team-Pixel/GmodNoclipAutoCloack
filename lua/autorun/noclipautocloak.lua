function cloak(e)
  e:SetNoDraw(true)
end
function uncloak(e)
  e:SetNoDraw(false)
end
function wpcloak(e)
	if IsValid(e:GetActiveWeapon()) then
		cloak(e:GetActiveWeapon())
	end
	for a,b in ipairs(ents.FindByClass("physgun_beam")) do
		if b:GetParent() == e then
			b:SetNoDraw(true)
		end
	end
end
function wpuncloak(e)
	if IsValid(e:GetActiveWeapon()) then
		uncloak(e:GetActiveWeapon())
	end
	for a,b in ipairs(ents.FindByClass("physgun_beam")) do
		if b:GetParent() == e then
			b:SetNoDraw(false)
		end
	end
end
function callCloak(ply, desiredNoClipState)
	if not ply:IsValid() then return end
	if ( desiredNoClipState ) then
		cloak(ply)			
		wpcloak(ply)
	else
		uncloak(ply)			
		wpuncloak(ply)
	end
end
hook.Add("PlayerNoClip", "isInNoClip", callCloak)
-- ULX COMPATIBILITY --
if ulx != nil then
	------------------------------ Noclip from ULX ------------------------------
	function ulx.noclip(calling_ply, target_plys)
		if not target_plys[ 1 ]:IsValid() then
			Msg( "You are god, you are not constrained by walls built by mere mortals.\n" )
			return
		end

		local affected_plys = {}
		for i=1, #target_plys do
			local v = target_plys[ i ]

			if v.NoNoclip then
				ULib.tsayError( calling_ply, v:Nick() .. " can't be noclipped right now.", true )
			else
				if v:GetMoveType() == MOVETYPE_WALK then
					v:SetMoveType( MOVETYPE_NOCLIP )
					cloak(v) -- Added cloak target
					wpcloak(v) -- Added cloak weapon's target
					table.insert( affected_plys, v )
				elseif v:GetMoveType() == MOVETYPE_NOCLIP then
					v:SetMoveType( MOVETYPE_WALK )
					uncloak(v) -- Added uncloak target
					wpuncloak(v) -- Added uncloak weapon's target
					table.insert( affected_plys, v )
				else -- Ignore if they're an observer
					ULib.tsayError( calling_ply, v:Nick() .. " can't be noclipped right now.", true )
				end
			end
		end
	end
	local noclip = ulx.command( CATEGORY_NAME, "ulx noclip", ulx.noclip, "!noclip" )
	noclip:addParam{ type=ULib.cmds.PlayersArg, ULib.cmds.optional }
	noclip:defaultAccess( ULib.ACCESS_ADMIN )
	noclip:help( "Toggles noclip on target(s)." )
	------------------------------ Noclip from ULX ------------------------------
end
-- NOT WORKING ANYMORE
hook.Add("PlayerSwitchWeapon", "SwitchWeapon", function(ply)
local weapon = ply:GetActiveWeapon()
   if(ply:GetNoDraw()) then
    if IsValid(weapon) then
      weapon:SetNoDraw(true)
      if weapon:GetClass() == "weapon_physgun" then
        for a,b in ipairs(ents.FindByClass("physgun_beam")) do
          if b:GetParent() == ply then
            b:SetNoDraw(true)
          end
        end
      end
    end
  end
end)
