function cloak(e)
  e:SetNoDraw(true)
end
function uncloak(e)
  e:SetNoDraw(false)
end
function callCloak(ply, desiredNoClipState)
  if not ply:IsValid() then return end
  if ( desiredNoClipState ) then
    cloak(ply)			
    if IsValid( ply:GetActiveWeapon() ) then
      cloak(ply:GetActiveWeapon())
    end
    for a,b in ipairs(ents.FindByClass("physgun_beam")) do
      if b:GetParent() == ply then
        b:SetNoDraw(true)
      end
    end
  else
    uncloak(ply)			
    if IsValid( ply:GetActiveWeapon() ) then
      uncloak(ply:GetActiveWeapon())
    end
    for a,b in ipairs(ents.FindByClass("physgun_beam")) do
      if b:GetParent() == ply then
        b:SetNoDraw(false)
      end
    end
  end
end

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
