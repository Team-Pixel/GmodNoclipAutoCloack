-- Convars
CreateConVar('nac_adminonly','1', {FVCAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY},'Admin only get auto cloaked ?');
-- Functions
function NaC.cloak(e)
	if (GetConVar('nac_adminonly'):GetBool()) then
		if not ply:IsAdmin() || ply:IsSuperAdmin() then return end
	end
	e:SetNoDraw(true)
end
function NaC.uncloak(e)
	e:SetNoDraw(false)
end
function NaC.wpcloak(e)
	if (GetConVar('nac_adminonly'):GetBool()) then
		if not ply:IsAdmin() || ply:IsSuperAdmin() then return end
	end
	if IsValid(e:GetActiveWeapon()) then
		NaC.cloak(e:GetActiveWeapon())
	end
	for a,b in ipairs(ents.FindByClass("physgun_beam")) do
		if b:GetParent() == e then
			b:SetNoDraw(true)
		end
	end
end
function NaC.wpuncloak(e)
	if IsValid(e:GetActiveWeapon()) then
		NaC.uncloak(e:GetActiveWeapon())
	end
	for a,b in ipairs(ents.FindByClass("physgun_beam")) do
		if b:GetParent() == e then
			b:SetNoDraw(false)
		end
	end
end
function NaC.callCloak(ply, desiredNoClipState)
	if not ply:IsValid() then return end
	if ( desiredNoClipState ) then
		NaC.cloak(ply)			
		NaC.wpcloak(ply)
	else
		NaC.uncloak(ply)			
		NaC.wpuncloak(ply)
	end
end
hook.Add("PlayerNoClip", "isInNoClip", NaC.callCloak)
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
					NaC.cloak(v) -- Added cloak target
					NaC.wpcloak(v) -- Added cloak weapon's target
					table.insert( affected_plys, v )
				elseif v:GetMoveType() == MOVETYPE_NOCLIP then
					v:SetMoveType( MOVETYPE_WALK )
					NaC.uncloak(v) -- Added uncloak target
					NaC.wpuncloak(v) -- Added uncloak weapon's target
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
