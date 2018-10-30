-- FirstEnemy.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 10/30/2018, 10:14:46 AM

local ns     = select(2, ...)
local Addon  = ns.Addon
local Script = ns.Script
local L      = ns.L

local FirstEnemy = Addon:NewPlugin('FirstEnemy')

function FirstEnemy:OnInitialize()
    self:EnableWithAddon('Blizzard_PetBattleUI')
    self:SetPluginTitle(L.PLUGINFIRSTENEMY_TITLE)
    self:SetPluginNotes(L.PLUGINFIRSTENEMY_NOTES)
    self:SetPluginIcon([[Interface\ICONS\Ability_Hisek_Aim]])
end

function FirstEnemy:GetCurrentKey()
    return C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, 1)
end

function FirstEnemy:GetTitleByKey(key)
    return C_PetJournal.GetPetInfoBySpeciesID(key)
end

function FirstEnemy:OnTooltipFormatting(tip, key)
    local name, icon, petType = C_PetJournal.GetPetInfoBySpeciesID(key)
    if name then
        tip:AddLine(format('|T%s:20|t %s', icon, name))
    end
end
