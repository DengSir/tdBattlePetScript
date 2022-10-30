--[[
Snippets.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]


local ns        = select(2, ...)
local Addon     = ns.Addon
local Util      = ns.Util
local Condition = ns.Condition

local Snippets = {} ns.Snippets = Snippets

do
    local function factory(opts)
        local words  = opts.words or {}
        local filter = opts.filter

        if opts.extend then
            local set = {}
            local function add(k)
                if set[k] then return end
                set[k] = true
                tinsert(words, k)
            end

            for k in pairs(opts.extend) do
                add(strsplit('.', k))
                add(k)
            end
        end

        sort(words)

        local function callback(item)
            return tinsert(words, 1, table.remove(words, item.index))
        end

        local function default(list, word, ...)
            if not word then
                return
            end

            local front, tail
            local len = #word
            for i, v in ipairs(words) do
                if v ~= word then
                    front = v:sub(1, len)

                    if front == word and (not filter or filter(v, word, ...)) then
                        tail = v:sub(len + 1)

                        tinsert(list, {
                            text     = format('|cff00ff00%s|r%s', front, tail),
                            value    = tail,
                            callback = callback,
                            index    = i,
                        })
                    end
                end
            end
            return 1
        end

        return {
            __default = default,
        }
    end

    Snippets.Condition = factory({
        extend = Condition.apis,
        filter = function(v, word, owner, pet, arg, non, petInputed, argInputed)
            if not Condition.apis[v] then
                return true
            end

            local opts = Condition.opts[v]
            if not opts.owner ~= not owner and v ~= 'round' then
                return false
            end
            if opts.pet and not pet then
                return false
            end
            if not opts.pet and petInputed then
                return false
            end
            if non and opts.type ~= 'boolean' then
                return false
            end
            if not opts.arg and argInputed then
                return false
            end

            local len = #word
            local pos = v:find('.', nil, true)
            if opts.arg and not argInputed and pos and len >= pos then
                return false
            end

            if pos and pos > len then
                return false
            end
            return true
        end
    })

    Snippets.Action = factory({
        words = { 'if', 'endif' },
        extend = ns.Action.apis,
    })

    Snippets.Target = factory({
        words = { 'self', 'enemy', 'ally' }
    })
end

function Snippets:Check(line)
    local list, column = {}
    local condition = line:match('[[&]%s*([^&[]+)$')

    if condition then
        local owner, pet, word, arg, non, petInputed, argInputed = self:ParseCondition(condition)
        word = word or line:match('(%w+)$')
        if not word then
            return
        end

        if not owner then
            self.Target.__default(list, word)
        end

        if arg or not self.Condition[word] then
            column = self.Condition.__default(list, word, owner, pet, arg, non, petInputed, argInputed)
        else
            column = self.Condition[word](list, word, owner, pet)
        end
    else
        word = line:match('^%s*(%w+)$')
        if not word then
            return
        end

        if not self.Action[word] then
            column = self.Action.__default(list, word)
        else
            column = self.Action[word](list, word)
        end
    end

    if not column or #list == 0 then
        return
    end
    return list, column
end

function Snippets:ParseCondition(condition)
    if not condition then
        return
    end

    local non do
        local _cond
        non, _cond = condition:match('^(!?)%s*(.+)$')
        non = non == '!'

        if non then
            condition = _cond
        end
    end

    local owner, pet, cmd, arg, petInputed, argInputed = Condition:ParseApi(condition)

    return owner, pet, cmd, arg, non, petInputed, argInputed
end

local empty = {}
local function tfillrow(t, column)
    for i = 1, column - #t % column do
        tinsert(t, empty)
    end
end

local function makeNameSnippet(name, id)
    return {
        text  = name,
        value = format('(%s:%d)', name, id),
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

local function fillAbility(list, owner, pet)
    for i = 1, NUM_BATTLE_PET_ABILITIES do
        local id, name, icon = C_PetBattles.GetAbilityInfo(owner, pet, i)
        if id then
            tinsert(list, makeIconSnippet(icon))
            tinsert(list, makeNameSnippet(name, id))
            tinsert(list, makeIndexSnippet(i))
        end
    end
    return 3
end

local function fillPet(list, owner)
    for i = 1, C_PetBattles.GetNumPets(owner) do
        local name = C_PetBattles.GetName(owner, i)
        local icon = C_PetBattles.GetIcon(owner, i)
        local id   = C_PetBattles.GetPetSpeciesID(owner, i)

        tinsert(list, makeIconSnippet(icon))
        tinsert(list, makeNameSnippet(name, id))
        tinsert(list, makeIndexSnippet(i))
    end
    return 3
end

Snippets.Action.use = function(list)
    return fillAbility(list, Enum.BattlePetOwner.Ally, C_PetBattles.GetActivePet(Enum.BattlePetOwner.Ally))
end

Snippets.Action.ability = Snippets.Action.use

local function fillNext(list, column)
    tinsert(list, empty)
    tinsert(list, {
        text = 'next',
        value = '(next)',
    })
    tfillrow(list, column)
    return column
end

Snippets.Action.change = function(list)
    return fillNext(list, fillPet(list, Enum.BattlePetOwner.Ally))
end

Snippets.Condition.enemy = function(list)
    return fillPet(list, Enum.BattlePetOwner.Enemy)
end

Snippets.Condition.ally = function(list)
    return fillPet(list, Enum.BattlePetOwner.Ally)
end

Snippets.Condition.self = Snippets.Condition.ally

Snippets.Condition.weather = function(list)
    local weathers = {
        171,  -- Weather_BurntEarth
        590,  -- Weather_ArcaneStorm
        596,  -- Weather_Moonlight
        257,  -- Weather_Darkness
        454,  -- Weather_Sandstorm
        205,  -- Weather_Blizzard
        718,  -- Weather_Mud
        229,  -- Weather_Rain
        403,  -- Weather_Sunlight
        203,  -- Weather_LightningStorm
        2320, -- Weather_LightningStorm
        ---,  -- Weather_Windy
        2350, -- Weather_Toxic_Gas
    }

    for i, id in ipairs(weathers) do
        local id, name, icon = C_PetBattles.GetAbilityInfoByID(id)

        tinsert(list, makeIconSnippet(icon))
        tinsert(list, makeNameSnippet(name, id))
    end
    return 2
end

Snippets.Condition.aura = function(list, word, owner, pet)
    if not owner or not pet then
        return
    end

    for _, pet in ipairs({pet, PET_BATTLE_PAD_INDEX}) do
        for i = 1, C_PetBattles.GetNumAuras(owner, pet) do
            local id, name, icon = C_PetBattles.GetAbilityInfoByID(C_PetBattles.GetAuraInfo(owner, pet, i))

            tinsert(list, makeIconSnippet(icon))
            tinsert(list, makeNameSnippet(name, id))
        end
    end
    return 2
end

Snippets.Condition.ability = function(list, word, owner, pet)
    return fillAbility(list, owner, pet)
end

Snippets.Condition.is = function(list, word, owner, pet)
    return fillPet(list, owner)
end
