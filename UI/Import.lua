--[[
Import.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local UI    = ns.UI
local L     = ns.L
local GUI   = LibStub('tdGUI-1.0')

local Import = Addon:NewModule('UI.Import')

function Import:OnInitialize()
    local Frame = GUI:GetClass('BasicPanel'):New(UIParent) do
        Frame:Hide()
        Frame:SetSize(350, 280)
        Frame:SetPoint('CENTER')
        -- Frame:SetMovable(true)
        -- Frame:SetMinResize(350, 350)
        -- Frame:SetMaxResize(700, 700)
        Frame:SetFrameStrata('DIALOG')
        Frame:SetText(L['Import'])
        Frame:SetCallback('OnShow', function()
            self.EditBox:SetText('')
            self.ExtraCheck:SetChecked(true)
            self:SetScript(nil)
        end)

        local Bg = Frame:CreateTexture(nil, 'BACKGROUND') do
            Bg:SetPoint('TOPLEFT', 3, -22)
            Bg:SetPoint('BOTTOMRIGHT', -3, 3)
            Bg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
        end

        local TLCorner = Frame:CreateTexture(nil, 'ARTWORK') do
            TLCorner:SetSize(64, 64)
            TLCorner:SetPoint('TOPLEFT', Bg, 'TOPLEFT')
            TLCorner:SetTexture([[Interface\Common\bluemenu-main]])
            TLCorner:SetTexCoord(0.00390625, 0.25390625, 0.00097656, 0.06347656)
        end

        local TRCorner = Frame:CreateTexture(nil, 'ARTWORK') do
            TRCorner:SetSize(64, 64)
            TRCorner:SetPoint('TOPRIGHT', Bg, 'TOPRIGHT')
            TRCorner:SetTexture([[Interface\Common\bluemenu-main]])
            TRCorner:SetTexCoord(0.51953125, 0.76953125, 0.00097656, 0.06347656)
        end

        local BRCorner = Frame:CreateTexture(nil, 'ARTWORK') do
            BRCorner:SetSize(64, 64)
            BRCorner:SetPoint('BOTTOMRIGHT', Bg, 'BOTTOMRIGHT')
            BRCorner:SetTexture([[Interface\Common\bluemenu-main]])
            BRCorner:SetTexCoord(0.00390625, 0.25390625, 0.06542969, 0.12792969)
        end

        local BLCorner = Frame:CreateTexture(nil, 'ARTWORK') do
            BLCorner:SetSize(64, 64)
            BLCorner:SetPoint('BOTTOMLEFT', Bg, 'BOTTOMLEFT')
            BLCorner:SetTexture([[Interface\Common\bluemenu-main]])
            BLCorner:SetTexCoord(0.26171875, 0.51171875, 0.00097656, 0.06347656)
        end

        local LLine = Frame:CreateTexture(nil, 'ARTWORK') do
            LLine:SetWidth(43)
            LLine:SetPoint('TOPLEFT', TLCorner, 'BOTTOMLEFT')
            LLine:SetPoint('BOTTOMLEFT', BLCorner, 'TOPLEFT')
            LLine:SetTexture([[Interface\Common\bluemenu-vert]])
            LLine:SetTexCoord(0.06250000, 0.39843750, 0.00000000, 1.00000000)
        end

        local RLine = Frame:CreateTexture(nil, 'ARTWORK') do
            RLine:SetWidth(43)
            RLine:SetPoint('TOPRIGHT', TRCorner, 'BOTTOMRIGHT')
            RLine:SetPoint('BOTTOMRIGHT', BRCorner, 'TOPRIGHT')
            RLine:SetTexture([[Interface\Common\bluemenu-vert]])
            RLine:SetTexCoord(0.41406250, 0.75000000, 0.00000000, 1.00000000)
        end

        local BLine = Frame:CreateTexture(nil, 'ARTWORK') do
            BLine:SetHeight(43)
            BLine:SetPoint('BOTTOMLEFT', BLCorner, 'BOTTOMRIGHT')
            BLine:SetPoint('BOTTOMRIGHT', BRCorner, 'BOTTOMLEFT')
            BLine:SetTexture([[Interface\Common\bluemenu-goldborder-horiz]])
            BLine:SetTexCoord(0.00000000, 1.00000000, 0.35937500, 0.69531250)
        end

        local TLine = Frame:CreateTexture(nil, 'ARTWORK') do
            TLine:SetHeight(43)
            TLine:SetPoint('TOPLEFT', TLCorner, 'TOPRIGHT')
            TLine:SetPoint('TOPRIGHT', TRCorner, 'TOPLEFT')
            TLine:SetTexture([[Interface\Common\bluemenu-goldborder-horiz]])
            TLine:SetTexCoord(0.00000000, 1.00000000, 0.00781250, 0.34375000)
        end
    end

    local EditBox = GUI:GetClass('EditBox'):New(Frame, true) do
        EditBox:SetPoint('TOPLEFT', 30, -70)
        EditBox:SetPoint('TOPRIGHT', -30, -70)
        EditBox:SetHeight(150)
        EditBox:SetCallback('OnTextChanged', function(_, userInput)
            if not userInput then
                return
            end
            self:OnTextChanged()
        end)
    end

    local ScriptInfo = CreateFrame('Button', nil, Frame) do
        ScriptInfo:SetSize(200, 28)
        ScriptInfo:SetPoint('TOP', EditBox, 'BOTTOM', 0, -20)
        ScriptInfo:SetScript('OnEnter', function(ScriptInfo)
            UI.OpenScriptTooltip(self.script, ScriptInfo, 'ANCHOR_RIGHT')
        end)
        ScriptInfo:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)

        local Icon = ScriptInfo:CreateTexture(nil, 'BORDER') do
            Icon:SetMask([[Textures\MinimapMask]])
            Icon:SetSize(28, 28)
            Icon:SetPoint('LEFT', 5, 0)
        end

        local Border = ScriptInfo:CreateTexture(nil, 'ARTWORK') do
            Border:SetTexture([[Interface\PetBattles\PetBattleHUD]])
            Border:SetPoint('TOPLEFT', Icon, 'TOPLEFT', 0, 1)
            Border:SetPoint('BOTTOMRIGHT', Icon, 'BOTTOMRIGHT', 1, 0)
            Border:SetTexCoord(0.884765625, 0.943359375, 0.681640625, 0.798828125)
        end

        local Highlight = ScriptInfo:CreateTexture(nil, 'HIGHLIGHT') do
            Highlight:SetPoint('TOPLEFT', Icon, 'TOPLEFT', -1, 1)
            Highlight:SetPoint('BOTTOMRIGHT', Icon, 'BOTTOMRIGHT', 2, -2)
            Highlight:SetBlendMode('ADD')
            Highlight:SetTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
        end

        local Highlight = ScriptInfo:CreateTexture(nil, 'HIGHLIGHT') do
            Highlight:SetTexture([[Interface\PVPFrame\PvPMegaQueue]])
            Highlight:SetTexCoord(0.00195313, 0.63867188, 0.76953125, 0.83007813)
            Highlight:SetBlendMode('ADD')
            Highlight:SetPoint('TOPLEFT', 20, -4)
            Highlight:SetPoint('BOTTOMRIGHT', -20, 2)
        end

        local Text = ScriptInfo:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall') do
            Text:SetPoint('LEFT', Icon, 'RIGHT', 3, 0)
            Text:SetPoint('RIGHT', -5, 0)
            Text:SetWordWrap(false)
            ScriptInfo:SetFontString(Text)
        end

        local Bg = ScriptInfo:CreateTexture(nil, 'BACKGROUND') do
            Bg:SetAllPoints(true)
            Bg:SetAtlas('groupfinder-button-cover')
        end

        local Bg = ScriptInfo:CreateTexture(nil, 'BACKGROUND', nil, -2) do
            Bg:SetPoint('TOPLEFT', 3, -3)
            Bg:SetPoint('BOTTOMRIGHT', -2, 2)
            Bg:SetColorTexture(0.5, 0.5, 0.5, 0.2)
        end

        ScriptInfo.Icon = Icon
    end

    local Warning = Frame:CreateFontString(nil, 'OVERLAY', 'GameFontRed') do
        Warning:SetPoint('TOP', ScriptInfo, 'BOTTOM', 0, -20)
        Warning:SetPoint('LEFT', 20, 0)
        Warning:SetPoint('RIGHT', -20, 0)
        Warning:SetText(L.SCRIPT_IMPORT_LABEL_COVER)
    end

    local CoverCheck = CreateFrame('CheckButton', nil, Frame, 'UICheckButtonTemplate') do
        CoverCheck:SetPoint('BOTTOM', -60, 50)
        CoverCheck:SetSize(26, 26)
        CoverCheck:SetHitRectInsets(0, -100, 0, 0)
        CoverCheck:SetFontString(CoverCheck.text)
        CoverCheck:SetText(L.SCRIPT_IMPORT_LABEL_GOON)
        CoverCheck:SetScript('OnClick', function()
            self:UpdateControl()
        end)
    end

    local ExtraCheck = CreateFrame('CheckButton', nil, Frame, 'UICheckButtonTemplate') do
        ExtraCheck:SetPoint('BOTTOM', CoverCheck, 'TOP', 0, -3)
        ExtraCheck:SetSize(26, 26)
        ExtraCheck:SetHitRectInsets(0, -100, 0, 0)
        ExtraCheck:SetFontString(ExtraCheck.text)
        ExtraCheck:SetText(L.SCRIPT_IMPORT_LABEL_EXTRA)
        ExtraCheck:SetScript('OnClick', function()

        end)
    end

    local SaveButton = CreateFrame('Button', nil, Frame, 'UIPanelButtonTemplate') do
        SaveButton:SetPoint('BOTTOMRIGHT', Frame, 'BOTTOM',-2, 20)
        SaveButton:SetSize(80, 22)
        SaveButton:SetText(SAVE)
        SaveButton:SetScript('OnClick', function()
            self:OnSaveButtonClick()
        end)
    end

    local CancelButton = CreateFrame('Button', nil, Frame, 'UIPanelButtonTemplate') do
        CancelButton:SetPoint('BOTTOMLEFT', Frame, 'BOTTOM', 2, 20)
        CancelButton:SetSize(80, 22)
        CancelButton:SetText(CANCEL)
        CancelButton:SetScript('OnClick', function()
            self.Frame:Hide()
        end)
    end

    self.Frame      = Frame
    self.EditBox    = EditBox
    self.CoverCheck = CoverCheck
    self.ExtraCheck = ExtraCheck
    self.SaveButton = SaveButton
    self.Warning    = Warning
    self.ScriptInfo = ScriptInfo
end

function Import:OnTextChanged()
    local ok, script, extra = Addon:Import(self.EditBox:GetText():trim())
    if not ok then
        self:SetScript(nil)
        return
    end
    self:SetScript(script, extra)
end

function Import:OnSaveButtonClick()
    self.Frame:Hide()
    self.script:GetPlugin():AddScript(self.script:GetKey(), self.script)

    if self.extra and self.ExtraCheck:GetChecked() then
        self.script:GetPlugin():OnImport(self.extra)
    end
end

function Import:SetScript(script, extra)
    self.script = script
    self.extra  = extra
    self.ExtraCheck:SetShown(extra)

    local height = 280

    if script then
        self.ScriptInfo.Icon:SetTexture(script:GetPlugin():GetPluginIcon())
        self.ScriptInfo:SetText(format('%s-%s', script:GetPlugin():GetPluginTitle(), script:GetName()))
        self.ScriptInfo:Show()
        height = height + 48
    else
        self.ScriptInfo:Hide()
    end

    if script and script:GetPlugin():GetScript(script:GetKey()) then
        self.Warning:Show()
        self.CoverCheck:Show()
        height = height + self.Warning:GetHeight() + 20 + 26 + 8
    else
        self.Warning:Hide()
        self.CoverCheck:Hide()
    end

    if extra then
        if not self.CoverCheck:IsShown() then
            self.ExtraCheck:SetPoint('BOTTOM', self.CoverCheck, 'BOTTOM')
        else
            self.ExtraCheck:SetPoint('BOTTOM', self.CoverCheck, 'TOP', 0, -3)
        end
        self.ExtraCheck:Show()
        height = height + 29
    else
        self.ExtraCheck:Hide()
    end

    self.Frame:SetHeight(height)

    self:UpdateControl()
end

function Import:UpdateControl()
    if not self.script then
        self.SaveButton:Disable()
    elseif self.script:GetPlugin():GetScript(self.script:GetKey()) then
        self.SaveButton:SetEnabled(self.CoverCheck:GetChecked())
    else
        self.SaveButton:Enable()
    end
end
