--[[
Api.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns   = select(2, ...)
local Util = {} ns.Util = Util

function Util.ParseID(value)
    return type(value) == 'string' and tonumber(value:match(':(%d+)$')) or nil
end

function Util.ComparePet(owner, index, pet)
    return pet == C_PetBattles.GetName(owner, index) or tonumber(pet) == C_PetBattles.GetPetSpeciesID(owner, index)
end

function Util.ParseQuote(str)
    local major, quote = str:match('^([^()]+)%((.+)%)$')
    if major then
        return major, Util.ParseID(quote) or quote
    end
    return str, nil
end

function Util.ParseIndex(value)
    return type(value) == 'string' and tonumber(value:match('^#(%d+)$')) or nil
end

function Util.ParsePetOwner(owner)
    return  owner == 'self'  and LE_BATTLE_PET_ALLY  or
            owner == 'ally'  and LE_BATTLE_PET_ALLY  or
            owner == 'enemy' and LE_BATTLE_PET_ENEMY or nil
end

function Util.ParsePetIndex(owner, pet)
    if not owner then
        return
    end
    if not pet then
        return C_PetBattles.GetActivePet(owner)
    end
    local index = Util.ParseIndex(pet)
    if index then
        if index >= 1 and index <= C_PetBattles.GetNumPets(owner) then
            return index
        end
    else
        local active = C_PetBattles.GetActivePet(owner)
        if Util.ComparePet(owner, active, pet) then
            return active
        end
        for i = 1, C_PetBattles.GetNumPets(owner) do
            if Util.ComparePet(owner, i, pet) then
                return i
            end
        end
    end
end

function Util.ParseAbility(owner, pet, ability)
    local index = Util.ParseIndex(ability)
    if index then
        if index and index >= 1 and index <= NUM_BATTLE_PET_ABILITIES then
            return index
        end
    else
        local best, bestDuration
        for i = 1, NUM_BATTLE_PET_ABILITIES do
            local id, name = C_PetBattles.GetAbilityInfo(owner, pet, i)
            if id == tonumber(ability) or name == ability then
                local usable, duration = C_PetBattles.GetAbilityState(owner, pet, i)
                if usable then
                    return i
                end
                if not bestDuration or bestDuration > duration then
                    bestDuration = duration
                    best = i
                end
            end
        end
        return best
    end
end

local function FindAura(owner, pet, aura)
    for i = 1, C_PetBattles.GetNumAuras(owner, pet) do
        local id, name = C_PetBattles.GetAbilityInfoByID(C_PetBattles.GetAuraInfo(owner, pet, i))
        if id == aura or name == aura then
            return owner, pet, i
        end
    end
end

function Util.FindAura(owner, pet, aura)
    for i, pet in ipairs({pet, PET_BATTLE_PAD_INDEX}) do
        local owner, pet, i = FindAura(owner, pet, aura)
        if owner then
            return owner, pet, i
        end
    end
end

function Util.assert(flag, formatter, ...)
    if not flag then
        error(format(formatter, ...), 0)
    end
    return flag
end

local function lower(value)
    if type(value) == 'string' then
        return value:lower()
    end
    return value
end

local PET_TYPES = {} do
    for id = 1, C_PetJournal.GetNumPetTypes() do
        local name      = _G['BATTLE_PET_NAME_' .. id]:lower()
        PET_TYPES[name] = id
        PET_TYPES[id]   = id
    end
end

function Util.ParsePetType(value)
    return value and PET_TYPES[lower(value)] or nil
end

local PET_QUALITIES = {} do
    for id = 1, 6 do
        local name          = _G['BATTLE_PET_BREED_QUALITY' .. id]:lower()
        PET_QUALITIES[name] = id
        PET_QUALITIES[id]   = id
    end
end

function Util.ParseQuality(value)
    return value and PET_QUALITIES[lower(value)] or nil
end
