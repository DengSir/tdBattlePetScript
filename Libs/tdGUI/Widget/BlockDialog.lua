--[[
BlockDialog.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'BlockDialog', 2
local GUI = LibStub('tdGUI-1.0')
local BlockDialog, oldminor = GUI:NewClass(MAJOR, MINOR, 'Frame')
if not BlockDialog then return end

function BlockDialog:Constructor(parent)
    self:Hide()
    self:EnableMouse(true)
    self:EnableMouseWheel(true)
    self:SetScript('OnMouseWheel', nop)
    self:SetScript('OnHide', self.OnHide)
    self:SetScript('OnShow', self.Layout)

    local Bg = self:CreateTexture(nil, 'BACKGROUND') do
        Bg:SetAllPoints(true)
        Bg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
    end

    local TLCorner = self:CreateTexture(nil, 'ARTWORK') do
        TLCorner:SetSize(64, 64)
        TLCorner:SetPoint('TOPLEFT', Bg, 'TOPLEFT')
        TLCorner:SetTexture([[Interface\Common\bluemenu-main]])
        TLCorner:SetTexCoord(0.00390625, 0.25390625, 0.00097656, 0.06347656)
    end

    local TRCorner = self:CreateTexture(nil, 'ARTWORK') do
        TRCorner:SetSize(64, 64)
        TRCorner:SetPoint('TOPRIGHT', Bg, 'TOPRIGHT')
        TRCorner:SetTexture([[Interface\Common\bluemenu-main]])
        TRCorner:SetTexCoord(0.51953125, 0.76953125, 0.00097656, 0.06347656)
    end

    local BRCorner = self:CreateTexture(nil, 'ARTWORK') do
        BRCorner:SetSize(64, 64)
        BRCorner:SetPoint('BOTTOMRIGHT', Bg, 'BOTTOMRIGHT')
        BRCorner:SetTexture([[Interface\Common\bluemenu-main]])
        BRCorner:SetTexCoord(0.00390625, 0.25390625, 0.06542969, 0.12792969)
    end

    local BLCorner = self:CreateTexture(nil, 'ARTWORK') do
        BLCorner:SetSize(64, 64)
        BLCorner:SetPoint('BOTTOMLEFT', Bg, 'BOTTOMLEFT')
        BLCorner:SetTexture([[Interface\Common\bluemenu-main]])
        BLCorner:SetTexCoord(0.26171875, 0.51171875, 0.00097656, 0.06347656)
    end

    local LLine = self:CreateTexture(nil, 'ARTWORK') do
        LLine:SetWidth(43)
        LLine:SetPoint('TOPLEFT', TLCorner, 'BOTTOMLEFT')
        LLine:SetPoint('BOTTOMLEFT', BLCorner, 'TOPLEFT')
        LLine:SetTexture([[Interface\Common\bluemenu-vert]])
        LLine:SetTexCoord(0.06250000, 0.39843750, 0.00000000, 1.00000000)
    end

    local RLine = self:CreateTexture(nil, 'ARTWORK') do
        RLine:SetWidth(43)
        RLine:SetPoint('TOPRIGHT', TRCorner, 'BOTTOMRIGHT')
        RLine:SetPoint('BOTTOMRIGHT', BRCorner, 'TOPRIGHT')
        RLine:SetTexture([[Interface\Common\bluemenu-vert]])
        RLine:SetTexCoord(0.41406250, 0.75000000, 0.00000000, 1.00000000)
    end

    local BLine = self:CreateTexture(nil, 'ARTWORK') do
        BLine:SetHeight(43)
        BLine:SetPoint('BOTTOMLEFT', BLCorner, 'BOTTOMRIGHT')
        BLine:SetPoint('BOTTOMRIGHT', BRCorner, 'BOTTOMLEFT')
        BLine:SetTexture([[Interface\Common\bluemenu-goldborder-horiz]])
        BLine:SetTexCoord(0.00000000, 1.00000000, 0.35937500, 0.69531250)
    end

    local TLine = self:CreateTexture(nil, 'ARTWORK') do
        TLine:SetHeight(43)
        TLine:SetPoint('TOPLEFT', TLCorner, 'TOPRIGHT')
        TLine:SetPoint('TOPRIGHT', TRCorner, 'TOPLEFT')
        TLine:SetTexture([[Interface\Common\bluemenu-goldborder-horiz]])
        TLine:SetTexCoord(0.00000000, 1.00000000, 0.00781250, 0.34375000)
    end

    local Text = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight') do
        Text:SetPoint('LEFT', 10, 0)
        Text:SetPoint('RIGHT', -10, 0)
    end

    local AcceptButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        AcceptButton:SetSize(80, 22)
        AcceptButton:SetScript('OnClick', function()
            self:OnAcceptClick()
        end)
    end

    local CancelButton = CreateFrame('Button', nil, self, 'UIPanelButtonTemplate') do
        CancelButton:SetSize(80, 22)
        CancelButton:SetScript('OnClick', function()
            self:OnCancelClick()
        end)
    end

    local EditBox = GUI:GetClass('EditBox'):New(self, true) do
        EditBox:Hide()
        EditBox:SetPoint('BOTTOMRIGHT', -10, 40)
        EditBox:SetCallback('OnEditFocusLost', function()
            self:OnEditFocusLost()
        end)
    end

    self.Text         = Text
    self.AcceptButton = AcceptButton
    self.CancelButton = CancelButton
    self.EditBox      = EditBox
end

function BlockDialog:Open(opts)
    self.AcceptButton:SetText(opts.acceptText or ACCEPT)
    self.CancelButton:SetText(opts.cancelText or CANCEL)
    self.CancelButton:SetShown(not opts.cancelHidden)
    self.Text:SetText(opts.text)

    self.OnAccept  = opts.OnAccept or nop
    self.OnCancel  = opts.OnCancel or nop

    self.closeType = nil
    self.ctx = opts.ctx
    self.editFocusLost = nil

    if opts.editBox then
        self.EditBox:Show()
        self.EditBox:SetText(opts.editText or '')
    else
        self.EditBox:Hide()
    end

    if opts.delay and opts.delay > 0 then
        self.acceptText = opts.acceptText or ACCEPT
        self.delay      = math.ceil(opts.delay)
        self.delayTimer = C_Timer.NewTicker(1, function() self:OnTimer() end, self.delay)
        self:OnTimer()
    else
        if self.delayTimer then
            self.delayTimer:Cancel()
        end
        self.delay      = nil
        self.acceptText = nil
        self.delayTimer = nil
        self.AcceptButton:Enable()
    end
    self:Show()

    if opts.editBox then
        if opts.editFocus then
            self.EditBox:SetFocus()
        end
        if opts.editHighlightAll then
            self.EditBox:HighlightText()
        end
        if opts.editFocusLost then
            self.editFocusLost = opts.editFocusLost
        end
    end
end

function BlockDialog:Layout()
    local acceptXOffset = self.CancelButton:IsShown() and -2 or 41
    if self.EditBox:IsShown() then
        self.EditBox:SetPoint('TOPLEFT', 10, - self.Text:GetHeight() - 40)
        self.AcceptButton:SetPoint('TOPRIGHT', self.EditBox, 'BOTTOM', acceptXOffset, -5)
        self.CancelButton:SetPoint('TOPLEFT', self.EditBox, 'BOTTOM', 2, -5)
        self.Text:SetPoint('BOTTOM', self.EditBox, 'TOP', 0, 20)
    else
        self.AcceptButton:SetPoint('TOPRIGHT', self, 'CENTER', acceptXOffset, -5)
        self.CancelButton:SetPoint('TOPLEFT', self, 'CENTER', 2, -5)
        self.Text:SetPoint('BOTTOM', self, 'CENTER', 0, 20)
    end
end

function BlockDialog:OnAcceptClick()
    self.closeType = 'OnAccept'
    self:Hide()
end

function BlockDialog:OnCancelClick()
    self:Hide()
end

function BlockDialog:OnEditFocusLost()
    if not self.editFocusLost then
        return
    end
    if self.editFocusLost == 'ACCEPT' then
        self:OnAcceptClick()
    else
        self:OnCancelClick()
    end
end

function BlockDialog:OnHide()
    if self.delayTimer then
        self.delayTimer:Cancel()
    end
    self:Hide()
    self[self.closeType or 'OnCancel'](self.ctx, self.EditBox:GetText())
end

function BlockDialog:OnTimer()
    if self.delay <= 0 then
        self.delayTimer = nil
        self.AcceptButton:SetText(self.acceptText)
        self.AcceptButton:Enable()
    else
        self.AcceptButton:SetText(format('%s (%d)', self.acceptText, self.delay))
        self.AcceptButton:Disable()
        self.delay = self.delay - 1
    end
end
