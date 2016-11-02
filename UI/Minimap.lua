--[[
Minimap.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local UI    = ns.UI
local L     = ns.L
local GUI   = LibStub('tdGUI-1.0')

local Minimap = Addon:NewModule('UI.Minimap')

function Minimap:OnInitialize()
    local LDB = LibStub('LibDataBroker-1.1')

    local BrokerObject = LDB:NewDataObject('tdBattlePetScript', {
        type = 'launcher',
        icon = [[Interface\Icons\INV_Misc_PenguinPet]],
        OnClick = function(button, click)
            GameTooltip:Hide()

            if click == 'RightButton' then
                GUI:ToggleMenu(button, {
                    {
                        text = L.ADDON_NAME,
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
            tooltip:SetText(L.ADDON_NAME)
            tooltip:AddLine(UI.LEFT_MOUSE_BUTTON .. L.TOGGLE_SCRIPT_MANAGER, 1, 1, 1)
            tooltip:AddLine(UI.RIGHT_MOUSE_BUTTON .. L.Options, 1, 1, 1)
        end,
        OnLeave = GameTooltip_Hide,
    })

    LibStub('LibDBIcon-1.0'):Register('tdBattlePetScript', BrokerObject, Addon.db.profile.minimap)
    LibStub('LibDBIcon-1.0'):Show('tdBattlePetScript')
end
