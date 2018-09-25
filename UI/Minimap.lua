--[[
Minimap.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns        = select(2, ...)
local Addon     = ns.Addon
local UI        = ns.UI
local L         = ns.L
local GUI       = LibStub('tdGUI-1.0')
local LibDBIcon = LibStub('LibDBIcon-1.0')

local Minimap = Addon:NewModule('UI.Minimap', 'AceEvent-3.0')

function Minimap:OnInitialize()
    if Addon:GetSetting('hideMinimap') then
        return
    end

    local LDB = LibStub('LibDataBroker-1.1')

    local function HideTooltip()
        GameTooltip:Hide()

        if LibDBIcon.tooltip then
            LibDBIcon.tooltip:Hide()
        end
    end

    local BrokerObject = LDB:NewDataObject('tdBattlePetScript', {
        type = 'launcher',
        icon = ns.ICON,
        OnClick = function(button, click)
            HideTooltip()

            if click == 'RightButton' then
                GUI:ToggleMenu(button, {
                    {
                        text = 'tdBattlePetScript',
                        isTitle = true,
                    },
                    {
                        text = L.TOGGLE_SCRIPT_MANAGER,
                        func = function()
                            UI.MainPanel:TogglePanel()
                        end
                    },
                    {
                        text = L.Import,
                        func = function()
                            UI.Import.Frame:Show()
                            UI.MainPanel:HidePanel()
                        end
                    },
                    {
                        text = L.Options,
                        func = function()
                            Addon:OpenOptionFrame()
                        end
                    }
                })
            else
                UI.MainPanel:TogglePanel()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:SetText('tdBattlePetScript')
            tooltip:AddLine(L.ADDON_NAME, GREEN_FONT_COLOR:GetRGB())
            tooltip:AddLine(' ')
            tooltip:AddLine(UI.LEFT_MOUSE_BUTTON .. L.TOGGLE_SCRIPT_MANAGER, 1, 1, 1)
            tooltip:AddLine(UI.RIGHT_MOUSE_BUTTON .. L.Options, 1, 1, 1)
        end,
        OnLeave = HideTooltip
    })

    LibDBIcon:Register('tdBattlePetScript', BrokerObject, Addon.db.profile.minimap)

    self:RegisterMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED_hideMinimap', 'Refresh')
end

function Minimap:Refresh()
    Addon.db.profile.minimap.hide = Addon:GetSetting('hideMinimap') or nil
    LibDBIcon:Refresh('tdBattlePetScript')
end
