-- ShareVersion1.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/21/2018, 9:59:09 AM

local ns = select(2, ...)
local Addon = ns.Addon
local AceSerializer = LibStub('AceSerializer-3.0')
local Base64 = LibStub('LibBase64-1.0')
local CRC32 = LibStub('LibCRC32-1.0')
local VERSION = 1
local Share = Addon:NewShareHandler(VERSION)

local template = [[
# tdBattlePetScript Share String
# Url: https://www.curseforge.com/wow/addons/tdbattlepetscript
# Version: %s
# Name: %s
# (Script) : #
%s
]]

function Share:RawExport(script)
    local code = AceSerializer:Serialize({
        db     = script:GetDB(),
        plugin = script:GetPlugin():GetPluginName(),
        key    = script:GetKey(),
        extra  = script:GetPlugin():OnExport(script:GetKey()),
    })
    return CRC32:enc(code) .. code
end

function Share:Export(script)
    return template:format(
        VERSION,
        script:GetName(),
        Base64.Encode(self:RawExport(script)):gsub('(..?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?)', function(x)
            return '# ' .. x .. '\n'
        end)
    )
end

function Share:Import(code)
    local code = code:match('%(Script%) : (.+)')
    if not code then
        return false, 'Decode failed'
    end

    code = code:gsub('[# ]', '')
    local ok, data = pcall(Base64.Decode, code)
    if not ok then
        return false, 'Decode failed'
    end

    local crc, data = data:match('^(%d+)(^.+)$')
    if not crc or not data then
        return false, 'Decode failed'
    end
    if CRC32:enc(data) ~= tonumber(crc) then
        return false, 'CRC32 error'
    end

    local ok, data = AceSerializer:Deserialize(data)
    if not ok or type(data) ~= 'table' then
        return false, 'Deserialize failed'
    end

    if not data.db or not data.db.code then
        return false, 'Data error'
    end
    return true, data
end

function Share:Is(code)
    if not code:find('(Script)', nil, true) then
        return
    end
    local version = code:match('# Version: (%d+)')
    return not version or tonumber(version) == VERSION
end
