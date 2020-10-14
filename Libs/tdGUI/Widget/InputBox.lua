--[[
InputBox.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'InputBox', 2
local InputBox = LibStub('tdGUI-1.0'):NewClass(MAJOR, MINOR, 'EditBox')
if not InputBox then return end

function InputBox:Constructor()
    local tLeft = self:CreateTexture(nil, 'BACKGROUND') do
        tLeft:SetTexture([[Interface\Common\Common-Input-Border]])
        tLeft:SetTexCoord(0, 0.0625, 0, 0.625)
        tLeft:SetWidth(8)
        tLeft:SetPoint('TOPLEFT')
        tLeft:SetPoint('BOTTOMLEFT')
    end

    local tRight = self:CreateTexture(nil, 'BACKGROUND') do
        tRight:SetTexture([[Interface\Common\Common-Input-Border]])
        tRight:SetTexCoord(0.9375, 1.0, 0, 0.625)
        tRight:SetWidth(8)
        tRight:SetPoint('TOPRIGHT')
        tRight:SetPoint('BOTTOMRIGHT')
    end

    local tMid = self:CreateTexture(nil, 'BACKGROUND') do
        tMid:SetTexture([[Interface\Common\Common-Input-Border]])
        tMid:SetTexCoord(0.0625, 0.9375, 0, 0.625)
        tMid:SetPoint('TOPLEFT', tLeft, 'TOPRIGHT')
        tMid:SetPoint('BOTTOMRIGHT', tRight, 'BOTTOMLEFT')
    end

    local Prompt = self:CreateFontString(nil, 'ARTWORK', 'GameFontDisableSmall') do
        Prompt:SetJustifyH('LEFT')
        Prompt:SetJustifyV('TOP')
        Prompt:SetPoint('LEFT', 8, 0)
    end

    self.Prompt = Prompt
    self.Label  = Label

    self:SetFontObject('GameFontHighlightSmall')
    self:SetAutoFocus(nil)
    self:SetTextInsets(8, 8, 0, 0)

    self:SetScript('OnTextChanged', self.OnTextChanged)
    self:SetScript('OnEscapePressed', self.ClearFocus)
end

function InputBox:OnTextChanged(...)
    self.Prompt:SetShown(self:GetText() == '')
    self:Fire('OnTextChanged', ...)
end

function InputBox:SetPrompt(prompt)
    self.Prompt:SetText(prompt)
end

function InputBox:GetPrompt()
    return self.Prompt:GetText()
end
