--[[
Stack.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns = select(2, ...)
local Addon = ns.Addon

local Stack = Addon:NewClass('Stack') ns.Stack = Stack

function Stack:Constructor()
    self.stack = {}
end

function Stack:Push(item)
    if item ~= nil then
        tinsert(self.stack, 1, item)
    end
end

function Stack:Pop()
    return table.remove(self.stack, 1)
end

function Stack:Top()
    return self.stack[1]
end
