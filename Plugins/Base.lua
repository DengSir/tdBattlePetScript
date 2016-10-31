--[[
Base.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns     = select(2, ...)
local Addon  = ns.Addon
local Script = ns.Script
local L      = ns.L

local PluginBase = Addon:NewPlugin('Base')

function PluginBase:OnInitialize()
    self:EnableWithAddon('Blizzard_PetBattleUI')
    self:SetPluginTitle(L.PLUGINBASE_TITLE)
    self:SetPluginNotes(L.PLUGINBASE_NOTES)
    self:SetPluginIcon([[Interface\ICONS\Ability_Garrison_OrangeBird]])
end

function PluginBase:OnEnable()
end

function PluginBase:OnDisable()
end

function PluginBase:GetCurrentKey()
    return self:GetOwnerKey(LE_BATTLE_PET_ALLY) .. ':' .. self:GetOwnerKey(LE_BATTLE_PET_ENEMY)
end

function PluginBase:GetOwnerKey(owner)
    local sb = {}
    for i = 1, C_PetBattles.GetNumPets(owner) do
        local id = C_PetBattles.GetPetSpeciesID(owner, i)
        if id then
            table.insert(sb, id)
        end
    end
    return table.concat(sb, ';')
end

local function SplitTeams(key)
    local allys, enemys = key:match('^(.+):(.+)$')

    allys  = { strsplit(';', allys ) }
    enemys = { strsplit(';', enemys) }

    return allys, enemys
end

function PluginBase:GetPetTip(id)
    if not id then
        return ' '
    end
    local name, icon, petType = C_PetJournal.GetPetInfoBySpeciesID(id)
    if not name then
        return ' '
    end
    return format('|T%s:20|t %s', icon, name)
end

function PluginBase:OnTooltipFormatting(tip, key)
    local allys, enemys = SplitTeams(key)

    tip:AddDoubleLine(L.PLUGINBASE_TEAM_ALLY, L.PLUGINBASE_TEAM_ENEMY, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)

    for i = 1, max(#allys, #enemys) do
        tip:AddDoubleLine(
            self:GetPetTip(tonumber(allys[i])),
            self:GetPetTip(tonumber(enemys[i])),
            1, 1, 1, 1, 1, 1
        )
    end
end
