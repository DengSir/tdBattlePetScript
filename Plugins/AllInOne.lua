-- AllInOne.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/20/2018, 4:05:16 PM

local ns = select(2, ...)
local Addon = ns.Addon
local Script = ns.Script
local L = ns.L

local PluginAllInOne = Addon:NewPlugin('AllInOne')

function PluginAllInOne:OnInitialize(args)
    self:EnableWithAddon('Blizzard_PetBattleUI')
    self:SetPluginTitle(L.PLUGINALLINONE_TITLE)
    self:SetPluginNotes(L.PLUGINALLINONE_NOTES)
    self:SetPluginIcon([[Interface\ICONS\ABILITY_SEAL]])
end

function PluginAllInOne:GetCurrentKey()
    return '-'
end

function PluginAllInOne:GetTitleByKey(key)
    return L.PLUGINALLINONE_TITLE
end

function PluginAllInOne:OnTooltipFormatting(tip, key)
end
