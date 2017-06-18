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

    local ct = self:CreateTexture(nil, 'BACKGROUND') do
        ct:SetAllPoints(true)
        ct:SetColorTexture(1, 0.82, 0, 0.2)
    end

    local ht = self:CreateTexture(nil, 'HIGHLIGHT') do
        ht:SetAllPoints(true)
        ht:SetColorTexture(1, 0.82, 0, 0.2)
    end

    local Icon = self:CreateTexture(nil, 'BORDER') do
        Icon:SetMask([[Textures\MinimapMask]])
        Icon:SetSize(24, 24)
        Icon:SetPoint('CENTER')
    end

    local IconBorder = self:CreateTexture(nil, 'ARTWORK') do
        IconBorder:SetTexture([[Interface\PetBattles\PetBattleHUD]])
        IconBorder:SetPoint('TOPLEFT', Icon, 'TOPLEFT', 0, 1)
        IconBorder:SetPoint('BOTTOMRIGHT', Icon, 'BOTTOMRIGHT', 1, 0)
        IconBorder:SetTexCoord(0.884765625, 0.943359375, 0.681640625, 0.798828125)
    end

    self.CheckedTexture = ct
    self.Text           = Text
    self.Icon           = Icon
    self.IconBorder     = IconBorder
end

function AutoCompleteItem:SetItem(item)
    if item.icon then
        self.Icon:SetTexture(item.icon)
        self.Icon:Show()
        self.IconBorder:Show()
    else
        self.Icon:Hide()
        self.IconBorder:Hide()
    end

    if item.text then
        self.Text:SetText(item.text)
        self.Text:Show()
    else
        self.Text:SetText('')
        self.Text:Hide()
    end

    self:SetEnabled(item.value)
end

function AutoCompleteItem:GetAutoWidth()
    if self.Icon:IsShown() then
        return 24
    else
        return self.Text:GetStringWidth() + 3
    end
end
