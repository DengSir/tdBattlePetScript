--[[
Conditions.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local Util  = ns.Util
local Round = ns.Round

Addon:RegisterCondition('dead', { type = 'boolean', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) == 0
end)


Addon:RegisterCondition('hp', { type = 'compare', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet)
end)


Addon:RegisterCondition('hp.full', { type = 'boolean', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) == C_PetBattles.GetMaxHealth(owner, pet)
end)


Addon:RegisterCondition('hpp', { type = 'compare', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) / C_PetBattles.GetMaxHealth(owner, pet) * 100
end)


Addon:RegisterCondition('aura.exists', { type = 'boolean' }, function(owner, pet, aura)
    return Util.FindAura(owner, pet, aura)
end)


Addon:RegisterCondition('aura.duration', { type = 'compare' }, function(owner, pet, aura)
    local i = Util.FindAura(owner, pet, aura)
    if i then
        return (select(3, C_PetBattles.GetAuraInfo(owner, pet, i)))
    end
    return 0
end)


Addon:RegisterCondition('weather', { type = 'boolean', owner = false }, function(_, _, weather)
    local id, name = 0, ''
    local aura = C_PetBattles.GetAuraInfo(LE_BATTLE_PET_WEATHER, PET_BATTLE_PAD_INDEX, 1)
    if aura then
        id, name = C_PetBattles.GetAbilityInfoByID(aura)
    end
    return id == weather or name == weather
end)


Addon:RegisterCondition('weather.duration', { type = 'compare', owner = false }, function(_, _, weather)
    local id, _, duration = C_PetBattles.GetAuraInfo(LE_BATTLE_PET_WEATHER, PET_BATTLE_PAD_INDEX, 1)
    if id and (id == weather or select(2, C_PetBattles.GetAbilityInfoByID(id)) == weather) then
        return duration
    end
    return 0
end)


Addon:RegisterCondition('active', { type = 'boolean', arg = false }, function(owner, pet)
    return C_PetBattles.GetActivePet(owner) == pet
end)


Addon:RegisterCondition('ability.usable', { type = 'boolean' }, function(owner, pet, ability)
    local ability = Util.ParseAbility(owner, pet, ability)
    return ability and C_PetBattles.GetAbilityState(owner, pet, ability)
end)


Addon:RegisterCondition('ability.duration', { type = 'compare' }, function(owner, pet, ability)
    local ability = Util.ParseAbility(owner, pet, ability)
    return ability and select(2, C_PetBattles.GetAbilityState(owner, pet, ability)) or 0
end)


Addon:RegisterCondition('round', { type = 'compare', pet = false, arg = false }, function(owner)
    if owner then
        return Round:GetRoundByOwner(owner)
    else
        return Round:GetRound()
    end
end)
