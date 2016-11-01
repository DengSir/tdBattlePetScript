--[[
Export.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns            = select(2, ...)
local Addon         = ns.Addon
local L             = ns.L
local AceSerializer = LibStub('AceSerializer-3.0')
local Base64        = LibStub('LibBase64-1.0')
local CRC32         = LibStub('LibCRC32-1.0')

local template = ([[
# %s (Name) : %%s
# %s (Author) : %%s
# %s (Selector) : %%s
# %s (Notes) : %%s
# %s (Script) : #
%%s
]]):format(L['Script name'], L['Script author'], L['Script selector'], L['Script notes'], L['Script'])

function Addon:Export(script)
    return template:format(
        script:GetName() or '',
        script:GetAuthor() or '',
        script:GetPlugin():GetPluginTitle(),
        (script:GetNotes() or ''):gsub('\n', '\n#                    '),
        Base64:enc(self:RawExport(script)):gsub('(..?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?.?)', function(x)
            return '# ' .. x .. '\n'
        end)
    )
end

function Addon:RawExport(script)
    local code = AceSerializer:Serialize({
        db     = script:GetDB(),
        plugin = script:GetPlugin():GetPluginName(),
        key    = script:GetKey(),
        extra  = script:GetPlugin():OnExport(script:GetKey()),
    })
    return CRC32:enc(code) .. code
end

function Addon:Import(code)
    local code = code:match('%(Script%) : (.+)')
    if not code then
        return false, 'Decode failed'
    end

    code = code:gsub('\n[^#](.+)$', '')

    local crc, data = Base64:dec(code):match('^(%d+)(^.+)$')
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

    if not data.plugin or not data.key or not data.db then
        return false, 'Data error'
    end

    local plugin = self:GetPlugin(data.plugin)
    if not plugin then
        return false, 'Script Selector not exists'
    end

    local script = self:GetClass('Script'):New(data.db, plugin, data.key)
    if not script:GetScript() then
        return false, 'Build script failed'
    end
    return true, script, data.extra
end
