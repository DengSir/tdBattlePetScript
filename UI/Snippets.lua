--[[
Snippets.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns = select(2, ...)
local Addon = ns.Addon
local Snippets = setmetatable({}, {__index = function(t) return t.__default end })

ns.Snippets = Snippets

local SnippetList = Addon:NewClass('SnippetList')

function SnippetList:Constructor()
    self.levels = {}
    self.orders = {}
    self.list   = {}
end

function SnippetList:AllocOrder(level)
    self.levels[level] = (self.levels[level] or 0) + 1
    return level * 10000 + self.levels[level]
end

function SnippetList:Add(level, v)
    self.orders[v] = self:AllocOrder(level)
    tinsert(self.list, v)
end

function SnippetList:Fill(id, name, index, opts)
    opts = opts or {
        name  = 1,
        index = 2,
        id    = 3,
    }

    self:Add(opts.name, {
        text = name,
        value = format('(%s)', name),
    })

    if index then
        self:Add(opts.index, {
            text = '#' .. index,
            value = format('(#%d)', index),
        })
    end

    self:Add(opts.id, {
        text = format('%d (%s)', id, name),
        value = format('(%d)', id),
    })
end

function SnippetList:ToList()
    if #self.list == 0 then
        return
    end

    sort(self.list, function(a, b)
        return self.orders[a] < self.orders[b]
    end)
    return self.list
end

local words = {
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
    'ally',

    -- condition
    'dead',
    'hp',
    'full',
    'hpp',
    'aura',
    'exists',
    'duration',
    'weather',
    'active',
    'usable',
    'strong',
    'weak',
    'type',
    'round',
    'played',
    'speed',
    'power',
    'level',
    'max',
    'fast',
    'slow',
    'quality',
}

Snippets.__default = function(list, trigger)
    if not trigger then
        return
    end
    local len  = #trigger

    for i, v in ipairs(words) do
        if v ~= trigger and v:sub(1, len) == trigger then
            list:Add(0, {
                text = v,
                value = v:sub(len + 1),
            })
        end
    end
end

Snippets.use = function(list)
    local pet  = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)

    for i = 1, NUM_BATTLE_PET_ABILITIES do
        local id, name = C_PetBattles.GetAbilityInfo(LE_BATTLE_PET_ALLY, pet, i)
        list:Fill(id, name, i)
    end
end

Snippets.change = function(list)
    for i = 1, C_PetBattles.GetNumPets(LE_BATTLE_PET_ALLY) do
        local name = C_PetBattles.GetName(LE_BATTLE_PET_ALLY, i)
        local id = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ALLY, i)
        list:Fill(id, name, i)
    end

    list:Add(0, {
        text = 'next',
        value = '(next)',
    })
end

for k, owner in pairs({ ally = LE_BATTLE_PET_ALLY, enemy = LE_BATTLE_PET_ENEMY }) do
    Snippets[k] = function(list)
        for i = 1, C_PetBattles.GetNumPets(owner) do
            local name = C_PetBattles.GetName(owner, i)
            local id = C_PetBattles.GetPetSpeciesID(owner, i)

            list:Fill(id, name, i)
        end
    end
end

Snippets['self'] = Snippets['ally']

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
        local id, name = C_PetBattles.GetAbilityInfoByID(id)
        list:Fill(id, name)
    end
end

Snippets.aura = function(list)
    for _, owner in ipairs({LE_BATTLE_PET_ALLY, LE_BATTLE_PET_ENEMY}) do
        for pet = 0, C_PetBattles.GetNumPets(owner) do
            for i = 1, C_PetBattles.GetNumAuras(owner, pet) do
                local id, name = C_PetBattles.GetAbilityInfoByID(C_PetBattles.GetAuraInfo(owner, pet, i))
                list:Fill(id, name)
            end
        end
    end
end
