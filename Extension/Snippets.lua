--[[
Snippets.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]


local ns    = select(2, ...)
local Addon = ns.Addon
local Util  = ns.Util

local Snippets = {} ns.Snippets = Snippets

do
    local function sinppet(v, l)
        local f, t = v:sub(1, l), v:sub(l + 1)
        return {
            text = format('|cff00ff00%s|r%s', f, t),
            value = t,
        }
    end

    local function checkdot(v, l)
        local p = v:find('.', nil, true)
        return not p or p <= l + 0
    end

    local function checkowner(v, owner)
        return not owner or ns.Condition.opts[v].owner
    end

    local function factory(opts)
        local words = opts.words or {}

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

        local default = opts.default or function(list, word, owner)
            if not word then
                return
            end
            local l = #word
            for i, v in ipairs(words) do
                if v ~= word and v:sub(1, l) == word and checkowner(v, owner) and checkdot(v, l) then
                    tinsert(list, sinppet(v, l))
                end
            end
            return 1
        end

        return setmetatable({
            __default = default,
            __words   = words,
        }, {__index = function(t) return default end})
    end

    Snippets.Condition = factory({
        extend = ns.Condition.apis
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
        local owner, pet, word, arg = self:ParseCondition(condition)
        word = word or line:match('(%w+)$')
        if not word then
            return
        end

        if not owner and not arg then
            self.Target.__default(list, word)
        end
        if arg then
            column = self.Condition.__default(list, word, owner, pet, arg)
        else
            column = self.Condition[word](list, word, owner, pet, arg)
        end
    else
        word = line:match('(%w+)$')
        if not word then
            return
        end

        column = self.Action[word](list, word)
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

    local args = {strsplit('.', condition)}
    if #args == 0 then
        return
    end

    local owner, pet = args[1]:match('^([^()]+)%(?([^()]*)%)?$')
    owner = Util.ParsePetOwner(owner)

    local cmd, arg do
        local major, minor = unpack(args, owner and 2 or 1)
        if major then
            cmd, arg = major:match('(.+)%(%s*(.+)%s*%)$')
            cmd = cmd or major
            cmd = minor and format('%s.%s', cmd, minor) or cmd
        end
    end

    if C_PetBattles.IsInBattle() then
        pet = pet ~= '' and pet or nil
        pet = Util.ParsePetIndex(owner, pet)
    end
    return owner, pet, cmd, arg
end

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

Snippets.Action.use = battleSelector(
    function(list)
        return fillAbilityInBattle(list, LE_BATTLE_PET_ALLY, C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY))
    end,
    function(list)
        return fillAbilityOutBattle(list, LE_BATTLE_PET_ALLY, 0)
    end
)

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

Snippets.Action.change = battleSelector(
    function(list)
        return fillNext(list, fillTargetInBattle(list, LE_BATTLE_PET_ALLY))
    end,
    function(list)
        return fillNext(list, fillTargetOutBattle(list, LE_BATTLE_PET_ALLY))
    end
)

Snippets.Condition.enemy = battleSelector(
    function(list)
        return fillTargetInBattle(list, LE_BATTLE_PET_ENEMY)
    end,
    function(list)
        return fillTargetOutBattle(list, LE_BATTLE_PET_ENEMY)
    end
)

Snippets.Condition.ally = battleSelector(
    function(list)
        return fillTargetInBattle(list, LE_BATTLE_PET_ALLY)
    end,
    function(list)
        return fillTargetOutBattle(list, LE_BATTLE_PET_ALLY)
    end
)

Snippets.Condition.self = Snippets.Condition.ally

Snippets.Condition.weather = function(list)
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

Snippets.Condition.aura = battleSelector(
    function(list, word, owner, pet)
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

Snippets.Condition.ability = battleSelector(
    function(list, word, owner, pet)
        return fillAbilityInBattle(list, owner, pet)
    end,
    function(list, word, owner, pet)
        return fillAbilityOutBattle(list, owner, pet)
    end
)
