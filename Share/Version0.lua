-- ShareVersion0.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/21/2018, 12:10:03 PM

local ns = select(2, ...)
local Addon = ns.Addon
local Director = ns.Director
local VERSION = 0
local Share = Addon:NewShareHandler(VERSION)

function Share:Import(code)
    if not code then
        return
    end

    if code:trim() == '' then
        return
    end

    if not Director:BuildScript(code) then
        return
    end
    return true, {db = {code = code}, warning = ns.L.IMPORT_SCRIPT_WARNING}
end

function Share:Is()
    return true
end
