local assets =
{
    Asset("ANIM", "anim/ster.zip"),
}

local function OnFinished(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", inst.Remove)
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "ster", "swap_ster")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
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
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function OnThrown(inst, owner, target)
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.components.inventoryitem.pushlandedevents = false
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
    inst.components.weapon:SetDamage(18)
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

    return inst
end

return Prefab("ster", fn, assets)