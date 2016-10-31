--[[
Action.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns     = select(2, ...)
local Util   = ns.Util
local Addon  = ns.Addon
local Action = {} ns.Action = Action

Action.apis = {}

function Addon:RegisterAction(name, method)
    Action.apis[name] = method
end

function Action:Run(action)
    local cmd, value = self:ParseAction(action)

    local fn = self.apis[cmd]
    return fn and fn(value)
end

function Action:ParseAction(action)
    Util.assert(type(action) == 'string', 'Invalid Action: `%s`', action)

    local cmd, value = action:match('^([^()]+)%(?([^()]*)%)?$')

    Util.assert(cmd, 'Invalid Action: `%s`', action)
    Util.assert(self.apis[cmd], 'Invalid Action: `%s` (Not found command)', action)

    return cmd, value ~= '' and value or nil
end
