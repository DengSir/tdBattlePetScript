--[[
Conditions.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns     = select(2, ...)
local Addon  = ns.Addon
local Util   = ns.Util
local Round  = ns.BattleCacheManager:GetModule('Round')
local Played = ns.BattleCacheManager:GetModule('Played')


local function getOpponent(owner)
    return owner == Enum.BattlePetOwner.Ally and Enum.BattlePetOwner.Enemy or Enum.BattlePetOwner.Ally
end

local function getOpponentActivePet(owner)
    local opponent = getOpponent(owner)
    return opponent, C_PetBattles.GetActivePet(opponent)
end

local function GetAbilityAttackModifier(owner, pet, ability)
    if not pet or not ability then
        return
    end
    local abilityType, noStrongWeakHints = select(7, C_PetBattles.GetAbilityInfo(owner, pet, ability))
    if noStrongWeakHints then
        return
    end

    local opponentType = C_PetBattles.GetPetType(getOpponentActivePet(owner))

    return C_PetBattles.GetAttackModifier(abilityType, opponentType)
end

local infinite = tonumber('inf')
local function logical_max_health(owner, pet)
    return pet and C_PetBattles.GetMaxHealth(owner, pet) or infinite
end

Addon:RegisterCondition('dead', { type = 'boolean', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) == 0
end)


Addon:RegisterCondition('hp', { type = 'compare', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet)
end)


Addon:RegisterCondition('hp.full', { type = 'boolean', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) == logical_max_health(owner, pet)
end)


Addon:RegisterCondition('hp.can_explode', { type = 'boolean', arg = false }, function(owner, pet)
    return pet and C_PetBattles.GetHealth(owner, pet) < floor(logical_max_health(getOpponentActivePet(owner)) * 0.4)
end)


Addon:RegisterCondition('hp.low', { type = 'boolean', pet = false, arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) < C_PetBattles.GetHealth(getOpponentActivePet(owner))
end)


Addon:RegisterCondition('hp.high', { type = 'boolean', pet = false, arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) > C_PetBattles.GetHealth(getOpponentActivePet(owner))
end)


Addon:RegisterCondition('hpp', { type = 'compare', arg = false }, function(owner, pet)
    return C_PetBattles.GetHealth(owner, pet) / logical_max_health(owner, pet) * 100
end)


Addon:RegisterCondition('aura.exists', { type = 'boolean' }, function(owner, pet, aura)
    return aura and Util.FindAura(owner, pet, aura)
end)


Addon:RegisterCondition('aura.duration', { type = 'compare' }, function(owner, pet, aura)
    local owner, pet, index = Util.FindAura(owner, pet, aura)
    if aura and index then
        return (select(3, C_PetBattles.GetAuraInfo(owner, pet, index)))
    end
    return 0
end)


Addon:RegisterCondition('weather', { type = 'boolean', owner = false, pet = false }, function(_, _, weather)
    local id, name = 0, ''
    local aura = C_PetBattles.GetAuraInfo(Enum.BattlePetOwner.Weather, PET_BATTLE_PAD_INDEX, 1)
    if aura then
        id, name = C_PetBattles.GetAbilityInfoByID(aura)
    end
    return weather and (id == weather or name == weather)
end)


Addon:RegisterCondition('weather.duration', { type = 'compare', owner = false, pet = false }, function(_, _, weather)
    local id, _, duration = C_PetBattles.GetAuraInfo(Enum.BattlePetOwner.Weather, PET_BATTLE_PAD_INDEX, 1)
    if weather and id and (id == weather or select(2, C_PetBattles.GetAbilityInfoByID(id)) == weather) then
        return duration
    end
    return 0
end)


Addon:RegisterCondition('active', { type = 'boolean', arg = false }, function(owner, pet)
    return C_PetBattles.GetActivePet(owner) == pet
end)


Addon:RegisterCondition('ability.usable', { type = 'boolean', argParse = Util.ParseAbility }, function(owner, pet, ability)
    local isUsable, currentCooldown, currentLockdown = C_PetBattles.GetAbilityState(owner, pet, ability)
    return ability and isUsable
end)


Addon:RegisterCondition('ability.duration', { type = 'compare', argParse = Util.ParseAbility }, function(owner, pet, ability)
    local isUsable, currentCooldown, currentLockdown = C_PetBattles.GetAbilityState(owner, pet, ability)
    return ability and currentCooldown or infinite
end)


Addon:RegisterCondition('ability.strong', { type = 'boolean', argParse = Util.ParseAbility }, function(owner, pet, ability)
    local modifier = GetAbilityAttackModifier(owner, pet, ability)
    return modifier and modifier > 1
end)


Addon:RegisterCondition('ability.weak', { type = 'boolean', argParse = Util.ParseAbility }, function(owner, pet, ability)
    local modifier = GetAbilityAttackModifier(owner, pet, ability)
    return modifier and modifier < 1
end)


Addon:RegisterCondition('ability.type', { type = 'equality', argParse = Util.ParseAbility, valueParse = Util.ParsePetType }, function(owner, pet, ability)
    return (select(7, C_PetBattles.GetAbilityInfo(owner, pet, ability)))
end)


Addon:RegisterCondition('round', { type = 'compare', pet = false, arg = false }, function(owner)
    if owner then
        return Round:GetRoundByOwner(owner)
    else
        return Round:GetRound()
    end
end)

Addon:RegisterCondition('played', { type = 'boolean', arg = false }, function(owner, pet)
    return pet and Played:IsPetPlayed(owner, pet)
end)

Addon:RegisterCondition('speed', { type = 'compare', arg = false }, C_PetBattles.GetSpeed)
Addon:RegisterCondition('power', { type = 'compare', arg = false }, C_PetBattles.GetPower)
Addon:RegisterCondition('level', { type = 'compare', arg = false }, C_PetBattles.GetLevel)


Addon:RegisterCondition('level.max', { type = 'boolean', arg = false }, function(owner, pet)
    return pet and C_PetBattles.GetLevel(owner, pet) == 25
end)


Addon:RegisterCondition('speed.fast', { type = 'boolean', pet = false, arg = false }, function(owner)
    return C_PetBattles.GetSpeed(owner, C_PetBattles.GetActivePet(owner)) > C_PetBattles.GetSpeed(getOpponentActivePet(owner))
end)


Addon:RegisterCondition('speed.slow', { type = 'boolean', pet = false, arg = false }, function(owner)
    return C_PetBattles.GetSpeed(owner, C_PetBattles.GetActivePet(owner)) < C_PetBattles.GetSpeed(getOpponentActivePet(owner))
end)


Addon:RegisterCondition('type', { type = 'equality', arg = false, valueParse = Util.ParsePetType }, function(owner, pet)
    return C_PetBattles.GetPetType(owner, pet)
end)


Addon:RegisterCondition('quality', { type = 'compare', arg = false, valueParse = Util.ParseQuality }, function(owner, pet)
    return pet and C_PetBattles.GetBreedQuality(owner, pet)
end)


Addon:RegisterCondition('exists', { type = 'boolean', pet = 1, arg = false }, function(owner, pet)
    return not not pet
end)


Addon:RegisterCondition('is', { type = 'boolean', pet = 1 }, function(owner, pet, other)
    return pet and Util.ComparePet(owner, pet, Util.ParseID(other) or other)
end)


Addon:RegisterCondition('id', { type = 'equality', pet = 1, arg = false }, function(owner, pet)
    return pet and C_PetBattles.GetPetSpeciesID(owner, pet) or 0
end)

Addon:RegisterCondition('collected', { type = 'boolean', arg = false }, function(owner, pet)
    local name = select(2, C_PetBattles.GetName(owner, pet))
    return select(2, C_PetJournal.FindPetIDByName(name)) ~= nil
end)

Addon:RegisterCondition('trap', { type = 'boolean', owner = false , pet = false, arg = false }, function()
    local usable, err = C_PetBattles.IsTrapAvailable()
    return usable or (not usable and err == 4)
end)
