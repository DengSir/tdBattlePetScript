--[[
Minimap.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local UI    = ns.UI
local L     = ns.L

local Minimap = Addon:NewModule('UI.Minimap')

function Minimap:OnInitialize()
    local LDB = LibStub('LibDataBroker-1.1')

    local BrokerObject = LDB:NewDataObject('tdBattlePetScript', {
        type = 'launcher',
        icon = [[Interface\Icons\INV_Misc_PenguinPet]],
        OnClick = function()
            UI.MainPanel:TogglePanel()
        end,
        OnTooltipShow = function(tooltip)
            tooltip:SetText(L.ADDON_NAME)
        end,
        OnLeave = function()
            GameTooltip_Hide()
        end
    })

    LibStub('LibDBIcon-1.0'):Register('tdBattlePetScript', BrokerObject, Addon.db.profile.minimap)
    LibStub('LibDBIcon-1.0'):Show('tdBattlePetScript')
end
