--[[
Director.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns        = select(2, ...)
local Util      = ns.Util
local Addon     = ns.Addon
local Action    = ns.Action
local Condition = ns.Condition
local Director  = Addon:NewModule('Director', 'AceEvent-3.0')

function Director:OnInitialize()
    self:RegisterEvent('PET_BATTLE_CLOSE', 'ClearScript')
end

function Director:Run()
    if not self.script then
        return
    end
    self:Action(self.script:GetScript())
end

function Director:Debug(script)
    self:Action(script)
end

function Director:Action(item)
    if type(item) == 'table' then
        for i, v in ipairs(item) do
            if Condition:Run(v[2]) and self:Action(v[1]) then
                return true
            end
        end
    elseif type(item) == 'string' then
        if Action:Run(item) then
            return true
        end
    else
        error('No item')
    end
end

local function FormatMacro(tab, action, condition)
    if not condition then
        return tab .. action
    elseif type(condition) == 'string' then
        return format('%s%s [ %s ]', tab, action, condition)
    else
        return format('%s%s [ %s ]', tab, action, table.concat(condition, ' & '))
    end
end

local function mergeCondition(dest, ...)
    for i = 1, select('#', ...) do
        local v = select(i, ...)
        if type(v) == 'table' then
            mergeCondition(dest, unpack(v))
        elseif type(v) == 'string' then
            v = v:trim()
            if v ~= '' then
                tinsert(dest, v)
            end
        end
    end
    return dest
end

local function MergeCondition(...)
    local condition = mergeCondition({}, ...)
    if #condition > 1 then
        return condition
    elseif #condition == 1 then
        return condition[1]
    else
        return nil
    end
end

local  function CheckCondition(item)
    if type(item) == 'string' then
        return Condition:ParseCondition(item)
    elseif type(item) == 'table' then
        for i, v in ipairs(item) do
            CheckCondition(v)
        end
    elseif not item then
        return
    else
        Util.assert(false, 'Invalid Script (Struct Error)')
    end
end

local function CheckAction(item)
    if type(item) == 'string' then
        return Action:ParseAction(item)
    elseif type(item) == 'table' then
        for i, v in ipairs(item) do
            CheckCondition(v[2])
            CheckAction(v[1])
        end
    else
        Util.assert(false, 'Invalid Script (Struct Error)')
    end
end

function Director:Check(item)
    return pcall(CheckAction, item)
end

function Director:BuildScript(code)
    if type(code) ~= 'string' then
        return nil, 'No code'
    end

    local script = {}
    local stack  = ns.Stack:New()

    stack:Push(script)

    for line in code:gmatch('[^\r\n]+') do
        line = line:trim()

        if line ~= '' then
            local script = stack:Top()
            local action, condition do
                if line:find('^%-%-') then
                    action = line
                elseif line:find('[', nil, true) then
                    action, condition = line:match('^/?(.+)%s+%[(.+)%]$')
                else
                    action = line:match('^/?(.+)$')
                end
            end

            if not action then
                return nil, format('Invalid Line: `%s`', line)
            end

            if condition then
                condition = MergeCondition({strsplit('&', condition)})
            end

            if action == 'if' then
                stack:Push({})
                tinsert(script, {stack:Top(), condition})
            elseif action == 'endif' or action == 'ei' then
                stack:Pop()

                local parent = stack:Top()
                if not parent then
                    return nil, 'Invalid Script: if endif unpaired'
                end

                if #script == 1 then
                    local dest = parent[#parent]
                    local item = script[1]

                    dest[1] = item[1]
                    dest[2] = MergeCondition(dest[2], item[2])
                end
            else
                tinsert(script, {action, condition})
            end
        end
    end

    if stack:Top() ~= script then
        return nil, 'Invalid Script: if endif unpaired'
    end

    local ok, err = Director:Check(script)
    if not ok then
        return nil, err
    end
    return script
end

function Director:BeautyScript(script, deep)
    deep = deep or 0

    local tab = strrep(' ', deep * 4)
    local sb = {}

    for i, v in ipairs(script) do
        local condition = MergeCondition(v[2])
        local action    = v[1]

        if type(action) == 'string' then
            tinsert(sb, FormatMacro(tab, action, condition))
        elseif type(action) == 'table' then
            tinsert(sb, FormatMacro(tab, 'if', condition))
            tinsert(sb, self:BeautyScript(action, deep + 1))
            tinsert(sb, FormatMacro(tab, 'endif'))
        end
    end
    return table.concat(sb, '\n')
end

local function errorhandler(err)
    return geterrorhandler()(err)
end

function Director:Select()
    local list = {}

    for name, plugin in Addon:IterateEnabledPlugins() do
        local ok, key = xpcall(function() return plugin:GetCurrentKey() end, errorhandler)
        local script  = ok and key and plugin:GetScript(key)
        if script then
            tinsert(list, script)
        end
    end
    return list
end

function Director:SetScript(script)
    self.script = script
    self:SendMessage('PET_BATTLE_SCRIPT_SCRIPT_UPDATE')
end

function Director:GetScript()
    return self.script
end

function Director:ClearScript()
    self.script = nil
    self:SendMessage('PET_BATTLE_SCRIPT_SCRIPT_UPDATE')
end
