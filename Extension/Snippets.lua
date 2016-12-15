--[[
Snippets.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]


local ns    = select(2, ...)
local Addon = ns.Addon

local Words = {
    'if',
    'endif',

    -- actions
    'use',
    'ability',
    'test',
    'change',
    'quit',
    'standby',
    'catch',

    -- target
    'self',
    'enemy',

    -- condition
    'dead',
    'hp',
    'hpp',
    'aura',
    'weather',
    'round',
    'speed',
    'power',
    'level',
    'type',
    'quality',

    'active',
    'duration',
    'exists',
    'usable',
    'played',
    'full',
    'strong',
    'weak',
    'fast',
    'slow',
    'max',

    -- target
    'ally',
}

local Snippets = setmetatable({}, {__index = function(t) return t.__default end })

local empty = {}
local function tfillrow(t, column)
    for i = 1, column - #t % column do
        tinsert(t, empty)
    end
end

local function makeNameSnippet(name)
    return {
        text  = name,
        value = format('(%s)', name),
    }
end

local function makeIndexSnippet(index)
    return {
        text  = format('#%d', index),
        value = format('(#%d)', index),
    }
end

local function makeIconSnippet(icon)
    return {
        icon = icon
    }
end

local function battleSelector(inBattle, outBattle)
    return function(...)
        if C_PetBattles.IsInBattle() then
            return inBattle and inBattle(...)
        else
            return outBattle and outBattle(...)
        end
    end
end

Snippets.__default = function(list, trigger)
    if not trigger then
        return
    end
    local len  = #trigger
    for i, v in ipairs(Words) do
        if v ~= trigger and v:sub(1, len) == trigger then
            tinsert(list, {
                text  = v,
                value = v:sub(len + 1),
            })
        end
    end
end

local function fillAbilityInBattle(list, owner, pet)
    for i = 1, NUM_BATTLE_PET_ABILITIES do
        local id, name, icon = C_PetBattles.GetAbilityInfo(owner, pet, i)
        if id then
            tinsert(list, makeIconSnippet(icon))
            tinsert(list, makeNameSnippet(name))
            tinsert(list, makeIndexSnippet(i))
        end
    end
    return 3
end

local function fillAbilityOutBattle(list, owner, pet)
    if owner == LE_BATTLE_PET_ENEMY then
        for i = 1, 3 do
            tinsert(list, makeIndexSnippet(i))
        end
        return 1
    else
        for i = 1, 3 do
            local petId, ability1, ability2, ability3 = C_PetJournal.GetPetLoadOutInfo(i)
            local abilities = {ability1, ability2, ability3}

            for i = 1, 3 do
                local id, name, icon = C_PetBattles.GetAbilityInfoByID(abilities[i])
                if id then
                    tinsert(list, makeIconSnippet(icon))
                    tinsert(list, makeNameSnippet(name))
                    tinsert(list, makeIndexSnippet(i))
                end
            end
        end
        return 3
    end
end

local function fillTargetInBattle(list, owner)
    for i = 1, C_PetBattles.GetNumPets(owner) do
        local name = C_PetBattles.GetName(owner, i)
        local icon = C_PetBattles.GetIcon(owner, i)

        tinsert(list, makeIconSnippet(icon))
        tinsert(list, makeNameSnippet(name))
        tinsert(list, makeIndexSnippet(i))
    end
    return 3
end

local function fillTargetOutBattle(list, owner, pet)
    if owner == LE_BATTLE_PET_ENEMY then
        for i = 1, 3 do
            tinsert(list, makeIndexSnippet(i))
        end
        return 1
    else
        for i = 1, 3 do
            local petId = C_PetJournal.GetPetLoadOutInfo(i)
            if petId then
                local name, icon = select(8, C_PetJournal.GetPetInfoByPetID(petId))

                tinsert(list, makeIconSnippet(icon))
                tinsert(list, makeNameSnippet(name))
                tinsert(list, makeIndexSnippet(i))
            end
        end
        return 3
    end
end

Snippets.use = battleSelector(
    function(list)
        return fillAbilityInBattle(list, LE_BATTLE_PET_ALLY, C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY))
    end,
    function(list)
        return fillAbilityOutBattle(list, LE_BATTLE_PET_ALLY, 0)
    end
)

local function fillNext(list, column)
    tinsert(list, empty)
    tinsert(list, {
        text = 'next',
        value = '(next)',
    })
    tfillrow(list, column)
    return column
end

Snippets.change = battleSelector(
    function(list)
        return fillNext(list, fillTargetInBattle(list, LE_BATTLE_PET_ALLY))
    end,
    function(list)
        return fillNext(list, fillTargetOutBattle(list, LE_BATTLE_PET_ALLY))
    end
)

Snippets.enemy = battleSelector(
    function(list)
        return fillTargetInBattle(list, LE_BATTLE_PET_ENEMY)
    end,
    function(list)
        return fillTargetOutBattle(list, LE_BATTLE_PET_ENEMY)
    end
)

Snippets.ally = battleSelector(
    function(list)
        return fillTargetInBattle(list, LE_BATTLE_PET_ALLY)
    end,
    function(list)
        return fillTargetOutBattle(list, LE_BATTLE_PET_ALLY)
    end
)

Snippets.self = Snippets.ally

Snippets.weather = function(list)
    local weathers = { 596, 590, 229, 403, 171, 205, 718, 257, 454 }

    -- 596 月光
    -- 590 奥术之风
    -- 229 净化之雨
    -- 403 晴天
    -- 171 灼燃大地
    -- 205 暴风雪
    -- 718 泥石流
    -- 257 黑暗
    -- 454 沙尘暴

    for i, id in ipairs(weathers) do
        local id, name, icon = C_PetBattles.GetAbilityInfoByID(id)

        tinsert(list, makeIconSnippet(icon))
        tinsert(list, makeNameSnippet(name))
    end
    return 2
end

Snippets.aura = battleSelector(
    function(list, word, _, owner, pet)
        if not owner or not pet then
            return
        end

        for _, pet in ipairs({pet, PET_BATTLE_PAD_INDEX}) do
            for i = 1, C_PetBattles.GetNumAuras(owner, pet) do
                local id, name, icon = C_PetBattles.GetAbilityInfoByID(C_PetBattles.GetAuraInfo(owner, pet, i))

                tinsert(list, makeIconSnippet(icon))
                tinsert(list, makeNameSnippet(name))
            end
        end
        return 2
    end
)

Snippets.ability = battleSelector(
    function(list, word, isCondition, owner, pet)
        if isCondition then
            return fillAbilityInBattle(list, owner, pet)
        else
            return fillAbilityInBattle(list, LE_BATTLE_PET_ALLY, C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY))
        end
    end,
    function(list, word, isCondition, owner, pet)
        if isCondition then
            return fillAbilityOutBattle(list, owner, pet)
        else
            return fillAbilityOutBattle(list, LE_BATTLE_PET_ALLY, 0)
        end
    end
)

function Addon:MakeSnippets(word, condition, owner, pet)
    local list   = {}
    local column = Snippets[word](list, word, condition, owner, pet) or 1
    if #list == 0 then
        return
    end
    return list, column
end
