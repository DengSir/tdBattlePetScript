--[[
UI.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns = select(2, ...)
local UI = ns.UI

UI.LEFT_MOUSE_BUTTON = [[|TInterface\TutorialFrame\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:228:283|t ]]
UI.RIGHT_MOUSE_BUTTON = [[|TInterface\TutorialFrame\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:330:385|t ]]

function UI.OpenScriptTooltip(script, owner, anchor)
    return UI.OpenPluginTooltip(script:GetPlugin(), script:GetKey(), owner, anchor)
end

function UI.OpenPluginTooltip(plugin, key, owner, anchor)
    local title         = plugin:GetPluginTitle()
    local notes         = plugin:GetPluginNotes()
    local tipFormatting = plugin.OnTooltipFormatting

    GameTooltip:SetOwner(owner, anchor or 'ANCHOR_TOPRIGHT')
    GameTooltip:SetText(title)

    if notes then
        GameTooltip:AddLine(notes, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true)
    end

    if type(tipFormatting) == 'function' then
        GameTooltip:AddLine(' ')
        tipFormatting(plugin, GameTooltip, key)
    end
    GameTooltip:Show()
    return GameTooltip
end
