--[[
ScriptItem.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local GUI   = LibStub('tdGUI-1.0')

local ScriptItem = Addon:NewClass('ScriptItem', GUI:GetClass('ViewItem'))

function ScriptItem:Constructor()
    local Bg = self:CreateTexture(nil, 'BACKGROUND') do
        Bg:SetPoint('TOPLEFT')
        Bg:SetPoint('BOTTOMRIGHT')
        Bg:SetAtlas('groupfinder-button-cover')
    end

    local Icon = self:CreateTexture(nil, 'BORDER') do
        Icon:SetMask([[Textures\MinimapMask]])
        Icon:SetSize(28, 28)
        Icon:SetPoint('LEFT', 5, 0)
    end

    local IconBorder = self:CreateTexture(nil, 'ARTWORK') do
        IconBorder:SetTexture([[Interface\PetBattles\PetBattleHUD]])
        IconBorder:SetPoint('TOPLEFT', Icon, 'TOPLEFT', 0, 1)
        IconBorder:SetPoint('BOTTOMRIGHT', Icon, 'BOTTOMRIGHT', 1, 0)
        IconBorder:SetTexCoord(0.884765625, 0.943359375, 0.681640625, 0.798828125)
    end

    local Highlight = self:CreateTexture(nil, 'HIGHLIGHT') do
        Highlight:SetTexture([[Interface\PVPFrame\PvPMegaQueue]])
        Highlight:SetTexCoord(0.00195313, 0.63867188, 0.76953125, 0.83007813)
        Highlight:SetBlendMode('ADD')
        Highlight:SetPoint('TOPLEFT', 20, -3)
        Highlight:SetPoint('BOTTOMRIGHT', -20, 2)
    end

    local Checked = self:CreateTexture(nil, 'OVERLAY') do
        Checked:SetTexture([[Interface\BUTTONS\UI-CheckBox-Check]])
        Checked:SetSize(20, 20)
        Checked:SetPoint('RIGHT', -5, -2)
        Checked:Hide()
    end

    local Text = self:CreateFontString(nil, 'ARTWORK') do
        Text:SetPoint('LEFT', Icon, 'RIGHT')
        Text:SetPoint('RIGHT', -5, 0)
        Text:SetWordWrap(false)
        self:SetFontString(Text)
        self:SetNormalFontObject('GameFontNormal')
        self:SetHighlightFontObject('GameFontHighlight')
    end

    self.Text       = Text
    self.Bg         = Bg
    self.Icon       = Icon
    self.IconBorder = IconBorder
    self.Checked    = Checked
    self.Highlight  = Highlight
end

function ScriptItem:SetTexture(texture)
    self.Icon:SetTexture(texture)
end

function ScriptItem:ShowIcon()
    self.Icon:Show()
    self.IconBorder:Show()
end

function ScriptItem:HideIcon()
    self.Icon:Hide()
    self.IconBorder:Hide()
end

function ScriptItem:SetType(type)
    if type == 'plugin' then
        self.Text:SetPoint('LEFT', self.Icon, 'RIGHT')
    else
        self.Text:SetPoint('LEFT', 5, 0)
    end
end

function ScriptItem:SetDesaturated(flag)
    self.Icon:SetDesaturated(flag)
    self.IconBorder:SetDesaturated(flag)
    self.Highlight:SetDesaturated(flag)
    self.Highlight:SetAlpha(flag and 0.5 or 1)
    self:SetNormalFontObject(flag and 'GameFontDisable' or 'GameFontNormal')
end
