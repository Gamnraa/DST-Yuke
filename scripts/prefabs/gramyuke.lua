local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.GRAMYUKE_HEALTH = 150
TUNING.GRAMYUKE_HUNGER = 150
TUNING.GRAMYUKE_SANITY = 200

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.GRAMYUKE = {
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.GRAMYUKE
end
local prefabs = FlattenTree(start_inv, true)

local function ontemperaturechange(inst, data)
	inst.components.combat.damagemultiplier = 1
	inst.components.sanity.dapperness = 0
	
	local sanitydelta = TUNING.STARTING_TEMP - data.new
	if not (sanitydelta > -4 and sanitydelta < 4) then
		local combatmod = sanitydelta / -10
		
		print("sanitydelta", sanitydelta / 100, "combatmod", combatmod)
		inst.components.combat.damagemultiplier = combatmod ~= 0 and combatmod or 1
		inst.components.sanity.dapperness = sanitydelta / 250
	end
end

local function setcustomrate(inst)
	local delta = 0
	ontemperaturechange(inst, {new = inst.components.temperature.current})
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.5)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.5)
	
	if inst.components.freezable:IsFrozen() then delta = .1 
	elseif inst.components.burnable:IsBurning() then
		delta = -.1
		inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier + 1
		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.5)
		inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.5)
	end
	return delta
end	

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "gramyuke_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "gramyuke_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "gramyuke.tex" )
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = "gramyuke"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.GRAMYUKE_HEALTH)
	inst.components.hunger:SetMax(TUNING.GRAMYUKE_HUNGER)
	inst.components.sanity:SetMax(TUNING.GRAMYUKE_SANITY)
	inst.components.sanity.custom_rate_fn = setcustomrate
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("gramyuke", prefabs, assets, common_postinit, master_postinit, prefabs)
