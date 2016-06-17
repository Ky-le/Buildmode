local CATEGORY_NAME = "_Kyle_1"

------------------------------ Buildmode ------------------------------
--Weapons the player can spawn while in Buildmode
 _kyle_builderSpawnableWeapons={
 	"weapon_physgun",
	"gmod_tool",
	"gmod_camera"
}
--Weapons the player gets reset to when switched to Buildmode
 _kyle_builderWeapons={
 	"weapon_physgun",
 	"gmod_tool",
 	"gmod_camera"
}
function _kyle_buildweapons(ply)
	ply:StripWeapons()
	for i=1,#_kyle_builderWeapons do 
        ply:Give(_kyle_builderWeapons[i])
    end
end
hook.Add("PlayerGiveSWEP", "_kyle_Buildmode_TrySWEPGive", function(v, wep)
     if v.buildmode and !table.HasValue(_kyle_builderSpawnableWeapons,wep) then
        v:SendLua("GAMEMODE:AddNotify(\"You cannot give yourself weapons while in Buildmode.\",NOTIFY_GENERIC, 5)")
        return false
    end
end)
hook.Add("PlayerSpawnSWEP", "_kyle_Buildmode_TrySWEPSpawn", function(v, wep)
    if v.buildmode and !table.HasValue(_kyle_builderSpawnableWeapons,wep) then
        v:SendLua("GAMEMODE:AddNotify(\"You cannot spawn weapons while in Buildmode.\",NOTIFY_GENERIC, 5)")
        return false
    end
end)
hook.Add("PlayerCanPickupWeapon", "_kyle_Buildmode_TrySWEPPickup", function(v, wep)
    local weapon = string.Explode("]", table.GetLastValue(string.Explode( "[", tostring(wep))))
    table.remove(weapon, 2)
    if v.buildmode and !table.HasValue(_kyle_builderSpawnableWeapons,table.GetLastValue(weapon)) then
        if v:GetNWInt("_kyle_buildNotify") == 1 then
            v:SetNWInt("_kyle_buildNotify", 0)
            v:SendLua("GAMEMODE:AddNotify(\"You cannot pick up weapons while in Buildmode.\",NOTIFY_GENERIC, 5)") 
            timer.Simple( 5, function()
                v:SetNWInt("_kyle_buildNotify", 1)
            end)
        end
        return false   
    end
end)
hook.Add("PlayerShouldTakeDamage", "_kyle_Buildmode_TryTakeDamage", function(ply, v)
	if v.buildmode then
		return false
	end
end)
function ulx.buildmode( calling_ply, target_plys, should_revoke )
    local affected_plys = {}
	for i=1, #target_plys do
        local v = target_plys[ i ]
        if v.buildmode == nil && not should_revoke then
            ULib.getSpawnInfo( v )
            v:StripWeapons()
            _kyle_buildweapons(v)
            v:GodEnable()
            v.ULXHasGod = true
            v.buildmode = true
        elseif v.buildmode != nil && should_revoke then
            v:GodDisable()
            v.ULXHasGod = nil
            v.buildmode = nil
            local pos = v:GetPos()
            ULib.spawn( v, true )
            v:SetPos( pos )
        end
        table.insert( affected_plys, v )
	end

	if should_revoke then
		ulx.fancyLogAdmin( calling_ply, "#A revoked Buildmode mode from #T", affected_plys )
	else
		ulx.fancyLogAdmin( calling_ply, "#A granted Buildmode mode upon #T", affected_plys )
	end
end
local buildmode = ulx.command( CATEGORY_NAME, "ulx buildmode", ulx.buildmode, "!buildmode" )
buildmode:addParam{ type=ULib.cmds.PlayersArg }
buildmode:defaultAccess( ULib.ACCESS_ALL )
buildmode:addParam{ type=ULib.cmds.BoolArg, invisible=true }
buildmode:help( "Grants Buildmode mode to target(s)." )
buildmode:setOpposite( "ulx unbuildmode", {_, _, true}, "!unbuildmode" )
