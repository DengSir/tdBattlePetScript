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
            return inBattle(...)
        else
            return outBattle(...)
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

Snippets.use = battleSelector(
    function(list)
        local pet  = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
        for i = 1, NUM_BATTLE_PET_ABILITIES do
            local id, name, icon = C_PetBattles.GetAbilityInfo(LE_BATTLE_PET_ALLY, pet, i)
            if id then
                tinsert(list, makeIconSnippet(icon))
                tinsert(list, makeNameSnippet(name))
                tinsert(list, makeIndexSnippet(i))
            end
        end
        return 3
    end,
    function(list)
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
)

local fillSelfInBattle, fillEnemyInBattle do
    local function factory(owner)
        return function(list)
            for i = 1, C_PetBattles.GetNumPets(owner) do
                local name = C_PetBattles.GetName(owner, i)
                local icon = C_PetBattles.GetIcon(owner, i)

                tinsert(list, makeIconSnippet(icon))
                tinsert(list, makeNameSnippet(name))
                tinsert(list, makeIndexSnippet(i))
            end
            return 3
        end
    end

    fillSelfInBattle = factory(LE_BATTLE_PET_ALLY)
    fillEnemyInBattle = factory(LE_BATTLE_PET_ENEMY)
end

local function fillSelfOutBattle(list)
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
        return fillNext(list, fillSelfInBattle(list))
    end,
    function(list)
        return fillNext(list, fillSelfOutBattle(list))
    end
)

Snippets.enemy = fillEnemyInBattle
Snippets.ally = battleSelector(fillSelfInBattle, fillSelfOutBattle)
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

Snippets.aura = function(list)
    for _, owner in ipairs({LE_BATTLE_PET_ALLY, LE_BATTLE_PET_ENEMY}) do
        for pet = 0, C_PetBattles.GetNumPets(owner) do
            for i = 1, C_PetBattles.GetNumAuras(owner, pet) do
                local id, name, icon = C_PetBattles.GetAbilityInfoByID(C_PetBattles.GetAuraInfo(owner, pet, i))

                tinsert(list, makeIconSnippet(icon))
                tinsert(list, makeNameSnippet(name))
            end
        end
    end
    return 2
end

Snippets.ability = function(list)
    -- body...
end

function Addon:MakeSnippets(word)
    local list   = {}
    local column = Snippets[word](list, word) or 1
    if #list == 0 then
        return
    end
    return list, column
end
