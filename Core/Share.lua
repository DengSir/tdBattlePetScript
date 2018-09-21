-- Share.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/21/2018, 9:50:36 AM

local ns = select(2, ...)
local Addon = ns.Addon
local Director = ns.Director

local SharePrototype = {
    Export = nop,
    Import = nop,
    Is = nop,
}

local handlers = {}

function Addon:NewShareHandler(version)
    local handler = CopyTable(SharePrototype)
    handler.version = version

    tinsert(handlers, handler)
    sort(handlers, function(a, b)
        return a.version > b.version
    end)

    return handler
end

function Addon:Export(script)
    return handlers[1]:Export(script)
end

function Addon:Import(code)
    for _, handler in ipairs(handlers) do
        if handler:Is(code) then
            local ok, data = handler:Import(code)
            if not ok or not data or not data.db or not data.db.code then
                return false
            end

            if not Director:BuildScript(data.db.code) then
                return false
            end
            return true, data
        end
    end
end
