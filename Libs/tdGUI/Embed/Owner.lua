--[[
Owner.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]


local MAJOR, MINOR = 'Owner', 1
local GUI = LibStub('tdGUI-1.0')
local View, oldminor = GUI:NewEmbed(MAJOR, MINOR)
if not View then return end

function View:SetOwner(owner)
    self._owner = owner
end

function View:GetOwner()
    return self._owner
end

local mixins = {
    'SetOwner',
    'GetOwner',
}

View.Embed = GUI:EmbedFactory(View, mixins)
