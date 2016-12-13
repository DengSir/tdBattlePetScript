--[[
AutoCompleteItem.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns               = select(2, ...)
local Addon            = ns.Addon
local GUI              = LibStub('tdGUI-1.0')
local AutoCompleteItem = Addon:NewClass('AutoCompleteItem', GUI:GetClass('ViewItem'))

function AutoCompleteItem:Constructor()
    local Text = self:CreateFontString(nil, 'ARTWORK', 'ChatFontNormal') do
        Text:SetJustifyH('LEFT')
        Text:SetPoint('LEFT')
        Text:SetPoint('RIGHT')
        Text:SetWordWrap(false)
    end

    local ct = self:CreateTexture(nil, 'OVERLAY') do
        ct:SetAllPoints(true)
        ct:SetAlpha(0.3)
        ct:SetColorTexture(0, 1, 1)
    end

    local ht = self:CreateTexture(nil, 'HIGHLIGHT') do
        ht:SetAllPoints(true)
        ht:SetAlpha(0.3)
        ht:SetColorTexture(1, 0.82, 0)
    end

    self.CheckedTexture = ct
    self.Text           = Text
end

function AutoCompleteItem:GetAutoWidth()
    return self.Text:GetStringWidth() + 10
end
