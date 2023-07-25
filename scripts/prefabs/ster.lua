local assets =
{
    Asset("ANIM", "anim/ster.zip"),
}

local function onremovelight(light)
    light._lantern._light = nil
end

local function stoptrackingowner(inst)
    if inst._owner ~= nil then
        inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
        inst._owner = nil
    end
end

local function starttrackingowner(inst, owner)
    if owner ~= inst._owner then
        stoptrackingowner(inst)
        if owner ~= nil and owner.components.inventory ~= nil then
            inst._owner = owner
            inst:ListenForEvent("equip", inst._onownerequip, owner)
        end
    end
end

local function TurnOn(inst)

    local owner = inst.components.inventoryitem.owner

    if inst._light == nil then
        inst._light = SpawnPrefab("lanternlight")
        inst._light._lantern = inst
        inst._light.Light:SetIntensity(Lerp(.15, .15, .33))
        inst._light.Light:SetRadius(Lerp(1, 3, .33))
        inst._light.Light:SetFalloff(1)
        inst:ListenForEvent("onremove", onremovelight, inst._light)
    end
    inst._light.entity:SetParent((owner or inst).entity)


    if owner ~= nil and inst.components.equippable:IsEquipped() then
        owner.AnimState:Show("LANTERN_OVERLAY")
    end

end

local function TurnOff(inst)
    stoptrackingowner(inst)


    if inst._light ~= nil then
        inst._light:Remove()
    end

    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
    end

end

local function OnFinished(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", inst.Remove)
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "ster", "swap_ster")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    TurnOn(inst)
end

local AutoCatchTask = nil

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.pushlandedevents = true
    inst:PushEvent("on_landed")
	if AutoCatchTask then 
		AutoCatchTask:Cancel()
		AutoCatchTask = nil
	end
    TurnOff(inst)
    TurnOn(inst)
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    TurnOff(inst)
end

local function OnThrown(inst, owner, target)
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.components.inventoryitem.pushlandedevents = false
    TurnOff(inst)
    TurnOn(inst)
end



local function OnHit(inst, owner, target)

    OnDropped(inst)

    if target ~= nil and target:IsValid() and target.components.combat then
        local impactfx = SpawnPrefab("impact")
        if impactfx ~= nil then
            local follower = impactfx.entity:AddFollower()
            follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
            impactfx:FacePoint(inst.Transform:GetWorldPosition())
        end
    end
end


local function lightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.OnEntityWake = OnLightWake
    inst.OnEntitySleep = OnLightSleep

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("ster")
    inst.AnimState:SetBuild("ster")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("thrown")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    local swap_data = {sym_build = "swap_ster"}
    MakeInventoryFloatable(inst, "small", 0.18, {0.8, 0.9, 0.8}, true, -6, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(22)
    inst.components.weapon:SetRange(20, 21)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnDropped)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    MakeHauntableLaunch(inst)

    inst.components.inventoryitem.onputininventoryfn = function(inst, player)
		if player.components.inventory then
			local gowner = inst.components.inventoryitem:GetGrandOwner()
			if gowner.components.inventory and not gowner:HasTag("gramyuke") then
				inst:DoTaskInTime(0.1, function()
					gowner.components.inventory:DropItem(inst)
					if gowner:HasTag("player") then
						gowner.components.talker:Say("I can't use this!")
					end
				end)
			end
		end
	end

    return inst
end

STRINGS.NAMES.STER = "Throwing Star"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STER = "A throwable star?"
STRINGS.CHARACTERS.GRAMYUKE.DESCRIBE.STER = "Looking sharp!"
return Prefab("ster", fn, assets),
    Prefab("sterlight", lightfn)