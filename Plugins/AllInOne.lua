-- AllInOne.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/20/2018, 4:05:16 PM

local ns     = select(2, ...)
local Addon  = ns.Addon
local Script = ns.Script
local L      = ns.L

local AllInOne = Addon:NewPlugin('AllInOne')

function AllInOne:OnInitialize(args)
    self:EnableWithAddon('Blizzard_PetBattleUI')
    self:SetPluginTitle(L.PLUGINALLINONE_TITLE)
    self:SetPluginNotes(L.PLUGINALLINONE_NOTES)
    self:SetPluginIcon([[Interface\ICONS\ABILITY_SEAL]])
end

function AllInOne:GetCurrentKey()
    return '-'
end

function AllInOne:IterateKeys()
    return pairs({['-'] = true})
end

function AllInOne:GetTitleByKey(key)
    return L.PLUGINALLINONE_TITLE
end

function AllInOne:OnTooltipFormatting(tip, key)
end
