--[[
Enable.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]


local MAJOR, MINOR = 'Enable', 1
local GUI = LibStub('tdGUI-1.0')
local View, oldminor = GUI:NewEmbed(MAJOR, MINOR)
if not View then return end

function View:Enable()
    self._disabled = nil
end

function View:Disable()
    self._disabled = true
end

function View:IsEnabled()
    return not self._disabled
end

function View:SetEnabled(flag)
    if flag then
        return self:Enable()
    else
        return self:Disable()
    end
end

local mixins = {
    'Enable',
    'Disable',
    'IsEnabled',
    'SetEnabled',
}

View.Embed = GUI:EmbedFactory(View, mixins)
