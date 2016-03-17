AddCSLuaFile()

--Console Commands
CreateConVar("_kyle_builderNoclip", "1", 8192, "Toggle whether Builders are can Noclip. (0-1)")
CreateConVar("_kyle_builderHighlight", "0", 8192, "Toggle whether Builders are outlined. (0-1)")
CreateConVar("_kyle_builderHighlightR", "0", 8192, "Change the RED hue of the Builder outline. (0-255)")
CreateConVar("_kyle_builderHighlightG", "128", 8192, "Change the GREEN hue of the Builder outline. (0-255)")
CreateConVar("_kyle_builderHighlightB", "255", 8192, "Change the BLUE hue of the Builder outline. (0-255)")
CreateConVar("_kyle_builderExHighlight", "0", 8192, "Toggle whether Non-Builders are outlined. (0-1)")
CreateConVar("_kyle_builderExHighlightR", "255", 8192, "Change the RED hue of the Non-Builder outline. (0-255)")
CreateConVar("_kyle_builderExHighlightG", "0", 8192, "Change the GREEN hue of the Non-Builder outline. (0-255)")
CreateConVar("_kyle_builderExHighlightB", "128", 8192, "Change the BLUE hue of the Non-Builder outline. (0-255)")
CreateConVar("_kyle_builderCommand", "!buildmode", 8192, "Change the command to toggle Buildmode for all clients.")
CreateConVar("_kyle_builderOnSpawn", "0", 8192, "Toggle whether Buildmode is enabled by default. (0-1)")
CreateConVar("_kyle_builderAbuseKick", "0", 8192, "Toggle whether Builders are kicked for abusing Buildmode. (0-1)")

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

--Disable Buildmode if enabled and vice versa
function _kyle_buildmodeToggle(ply)
	if (ply:GetNWInt("_kyle_buildmode") == 1) then  
		ply:SetNWInt("_kyle_buildmode", 0) 
		ply:SendLua("GAMEMODE:AddNotify(\"Build Mode disabled.\",NOTIFY_GENERIC, 5)")
		PrintMessage( HUD_PRINTTALK, ply:GetName( ) .." has disabled Build Mode.")
	elseif (ply:GetNWInt("_kyle_buildmode") == 0) then
		_kyle_buildweapons(ply)
		ply:SetNWInt("_kyle_buildmode", 1)
		ply:SendLua("GAMEMODE:AddNotify(\"Build Mode enabled.\",NOTIFY_GENERIC, 5)")PrintMessage( HUD_PRINTTALK, ply:GetName( ) .." has enabled Build Mode.")
	end
end
--Reset the weapons of the Player to what is in _kyle_builderWeapons
function _kyle_buildweapons(ply)
	ply:StripWeapons()
	for i=1,#_kyle_builderWeapons doply:Give(_kyle_builderWeapons[i])
    end
end

--Called when the Player Spawns
hook.Add("PlayerSpawn", "OnSpawn", function( ply )
    if GetConVar("_kyle_builderOnSpawn"):GetInt() ==1 then _kyle_builderOnSpawn=true end
    if GetConVar("_kyle_builderOnSpawn"):GetInt() ==0 then _kyle_builderOnSpawn=false end
    if GetConVar("_kyle_builderAbuseKick"):GetInt() ==1 then _kyle_builderAbuseKick=true end
    if GetConVar("_kyle_builderAbuseKick"):GetInt() ==0 then _kyle_builderAbuseKick=false end
    if _kyle_builderOnSpawn then
    	_kyle_buildweapons(ply)
        ply:SetNWInt("_kyle_buildmode", 1)
        ply:SetNWInt("_kyle_buildNotify", 1)
        ply:SendLua("GAMEMODE:AddNotify(\"You will be invincible until you say " .._kyle_builderCommand..".\",NOTIFY_GENERIC, 5)")
        PrintMessage( HUD_PRINTTALK, ply:GetName( ) .." has spawned with Build Mode.")
        else
	    ply:SetNWInt("_kyle_buildmode", 0) 
	end
end )
--Called when the Player Dies
hook.Add("PlayerDeath", "OnDeath", function(victim, inflictor, killer)
    if killer:GetNWInt("_kyle_buildmode")==1 and killer != victim and _kyle_builderAbuseKick then
        PrintMessage( HUD_PRINTTALK, killer:GetName( ) .." has been kicked for killing " .. victim:GetName( ) .. "while in Buildmode." )
        killer:Kick("You have killed someone while in Buildmode.")
    end
end)
--Called when the Player speaks in text
hook.Add("PlayerSay", "OnSay", function(ply, say)
	_kyle_builderCommand = GetConVar("_kyle_builderCommand"):GetString()
	local text = say:lower()
	if (text == _kyle_builderCommand) then
        	_kyle_buildmodeToggle(ply)
	end
end)
--Called when the player Tages Damage
hook.Add("EntityTakeDamage", "GodMode",  function(ply, dmginfo)
    if(ply:GetNWInt("_kyle_buildmode") == 1 and ply:IsPlayer()) then
        dmginfo:ScaleDamage( 0 )
    end
end )
--Called when the player stands on a Weapon
hook.Add("PlayerCanPickupWeapon", "TryWepPickup",  function(ply, wep)
    if (ply:GetNWInt("_kyle_buildmode") == 1) then
        local weapon = string.Explode( "[", tostring(wep))
        weapon = string.Explode("]", table.GetLastValue(weapon))
        table.remove(weapon, 2)
        if(!table.HasValue(_kyle_builderSpawnableWeapons,table.GetLastValue(weapon))) then
            if(ply:GetNWInt("_kyle_buildNotify") == 1)then
                ply:SetNWInt("_kyle_buildNotify", 0)
                ply:SendLua("GAMEMODE:AddNotify(\"You cannot get weapons while in Build Mode.\",NOTIFY_GENERIC, 5)") 
            end
            timer.Create( "_kyle_NotifyBuildmode", 1, 1, function()
                ply:SetNWInt("_kyle_buildNotify", 1)
            end)
            return false
        end
    end
end)
--Called when the player tries to Spawns a weapon
hook.Add("PlayerSpawnSWEP", "TryWepSpawn",  function(ply)
    if (ply:GetNWInt("_kyle_buildmode") == 1) then
        ply:SendLua("GAMEMODE:AddNotify(\"You cannot get weapons while in Build Mode.\",NOTIFY_GENERIC, 5)")
        return false
    end
end)
--Called when the player trys to toggle Noclip
hook.Add("PlayerNoClip", "OnNoclip", function( ply )
	if ((GetConVar("_kyle_builderNoclip"):GetInt() == 1) and (ply:GetNWInt("_kyle_buildmode") == 1)) or (ply:IsAdmin()) then
		return true;
	end
end)
--Called to draw Halos
hook.Add("PreDrawHalos", "AddHalos", function()
    _kyle_builderHighlight = GetConVar("_kyle_builderHighlight"):GetInt() == 1
    _kyle_builderExHighlight = GetConVar("_kyle_builderExHighlight"):GetInt() == 1
    if _kyle_builderHighlight or _kyle_builderExHighlight then
        _kyle_Builders={}
        _kyle_BuildersEx={}
        for i=1,#player.GetAll() do
            if(player.GetAll()[i]:GetNWInt("_kyle_buildmode")==1 and player.GetAll()[i]:Alive() and _kyle_builderHighlight) then 
                table.insert(_kyle_Builders, player.GetAll()[i])
            elseif(player.GetAll()[i]:GetNWInt("_kyle_buildmode")==0 and player.GetAll()[i]:Alive() and _kyle_builderExHighlight)then
                table.insert(_kyle_BuildersEx, player.GetAll()[i])
            end
        end
    end
    --Get the colors for the Builders and add a halo to them
    if _kyle_builderHighlight then
        _kyle_builderHighlightR = math.Clamp(GetConVar("_kyle_builderHighlightR"):GetInt(), 0, 255)
        _kyle_builderHighlightG = math.Clamp(GetConVar("_kyle_builderHighlightG"):GetInt(), 0, 255)
        _kyle_builderHighlightB = math.Clamp(GetConVar("_kyle_builderHighlightB"):GetInt(), 0, 255)
        halo.Add(_kyle_Builders, Color(_kyle_builderHighlightR, _kyle_builderHighlightG, _kyle_builderHighlightB), 4, 4, 1, true)
    end
    --Get the colors for the non-builders and add a halo to them
    if _kyle_builderExHighlight then
        _kyle_builderExHighlightR = math.Clamp(GetConVar("_kyle_builderExHighlightR"):GetInt(), 0, 255)
        _kyle_builderExHighlightG = math.Clamp(GetConVar("_kyle_builderExHighlightG"):GetInt(), 0, 255)
        _kyle_builderExHighlightB = math.Clamp(GetConVar("_kyle_builderExHighlightB"):GetInt(), 0, 255)
        halo.Add(_kyle_BuildersEx, Color(_kyle_builderExHighlightR, _kyle_builderExHighlightG, _kyle_builderExHighlightB), 4, 4, 1, true)
    end
end)
