-- Version2.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/21/2018, 12:43:33 PM

local ns = select(2, ...)
local Addon = ns.Addon
local AceSerializer = LibStub('AceSerializer-3.0')
local Base64 = LibStub('LibBase64-1.0')
local VERSION = 2
local Share = Addon:NewShareHandler(VERSION)

local template = [[
# tdBattlePetScript Share String
# Url: https://www.curseforge.com/wow/addons/tdbattlepetscript
# Version: %s
# Name: %s
# Data: %s
# Code Start
%s
# Code End
]]

function Share:Is(code)
    local version = code:match('# Version: (%d+)')
    return tonumber(version) == VERSION
end

function Share:Export(script)
    local data = Base64.Encode(AceSerializer:Serialize{
        plugin = script:GetPlugin():GetPluginName(),
        key = script:GetKey(),
        extra = script:GetPlugin():OnExport(script:GetKey())
    })

    return template:format(
        VERSION,
        script:GetName(),
        data,
        script:GetCode()
    )
end

function Share:DecodeData(data)
    local ok, data = pcall(Base64.Decode, data)
    if not ok then
        return
    end

    ok, data = AceSerializer:Deserialize(data)
    if not ok then
        return
    end
    return data
end

function Share:Import(code)
    local name = code:match('# Name: (%S+)')
    local data = code:match('# Data: (%S+)')
    local code = code:match('# Code Start(.+)# Code End')

    if not code then
        return false, 'Not found code'
    end

    code = code:trim()
    if code == '' then
        return false, 'Not found code'
    end

    if data then
        data = self:DecodeData(data)
    end
    if not data then
        data = {}
    end

    data.db = {
        code = code,
        name = name,
    }
    return true, data
end
