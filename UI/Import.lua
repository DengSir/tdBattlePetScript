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
        Frame:SetFrameStrata('DIALOG')
        Frame:SetText(L['Import'])
        Frame:SetCallback('OnShow', function()
            self.script = nil
            self.data = nil
            self.EditBox:SetText('')
            self.EditBox:SetFocus()
            self.ExtraCheck:SetChecked(true)
            self.PluginDropdown:SetValue(nil)
            self.KeyDropdown:SetValue(nil)
            self.PageFrame:SetPage(1, true)
            self.WelcomeWarning:Hide()
            self:UpdateControl()
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

    local PageFrame = GUI:GetClass('AnimPageFrame'):New(Frame) do
        PageFrame:SetPoint('TOPLEFT', 3, -22)
        PageFrame:SetPoint('BOTTOMRIGHT', -3, 3)
        PageFrame:SetOrientation('VERTICAL')
    end

    local PageWelcome = CreateFrame('Frame', nil, PageFrame) do
        PageFrame:AddPage(PageWelcome)
    end

    local PageSelector = CreateFrame('Frame', nil, PageFrame) do
        PageFrame:AddPage(PageSelector)
    end

    local PageImport = CreateFrame('Frame', nil, PageFrame) do
        PageFrame:AddPage(PageImport)
    end

    self.Frame = Frame
    self.PageFrame = PageFrame
    self.PageWelcome = PageWelcome
    self.PageImport = PageImport
    self.PageSelector = PageSelector

    self:InitPageWelcome(PageWelcome)
    self:InitPageSelector(PageSelector)
    self:InitPageImport(PageImport)
end

function Import:InitPageWelcome(frame)
    local WelcomeHelp = CreateFrame('Frame', nil, frame) do
        WelcomeHelp:SetAllPoints(true)

        local Text = frame:CreateFontString(nil, 'OVERLAY', 'GameFontGreen') do
            Text:SetPoint('TOP', 0, -30)
            Text:SetPoint('LEFT', 60, 0)
            Text:SetPoint('RIGHT', -20, 0)
            Text:SetText(L.IMPORT_SCRIPT_WELCOME)
        end

        local Icon = frame:CreateTexture(nil, 'OVERLAY') do
            Icon:SetTexture([[Interface\DialogFrame\UI-Dialog-Icon-AlertOther]])
            Icon:SetSize(32, 32)
            Icon:SetPoint('RIGHT', Text, 'LEFT', -8, 0)
        end
    end

    local EditBox = GUI:GetClass('EditBox'):New(frame, true) do
        EditBox:SetPoint('TOPLEFT', 27, -68)
        EditBox:SetPoint('TOPRIGHT', -27, -68)
        EditBox:SetHeight(130)
        EditBox:SetCallback('OnTextChanged', function(_, userInput)
            if not userInput then
                return
            end
            self:OnTextChanged()
        end)
    end

    local WelcomeNextButton = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate') do
        WelcomeNextButton:SetPoint('BOTTOM', 0, 20)
        WelcomeNextButton:SetSize(120, 26)
        WelcomeNextButton:SetText(CONTINUE)
        WelcomeNextButton:SetScript('OnClick', function()
            self.EditBox:ClearFocus()
            self.PageFrame:SetPage(2)
        end)
    end

    local WelcomeWarning = CreateFrame('Frame', nil, EditBox) do
        WelcomeWarning:SetAllPoints(true)
        WelcomeWarning:SetFrameLevel(EditBox:GetFrameLevel() + 10)

        local bg = WelcomeWarning:CreateTexture(nil, 'BACKGROUND') do
            bg:SetAllPoints(true)
            bg:SetColorTexture(0, 0, 0, 0.9)
        end

        local Text = WelcomeWarning:CreateFontString(nil, 'OVERLAY', 'GameFontRed') do
            Text:SetPoint('LEFT', 40, 0)
            Text:SetPoint('RIGHT')
        end

        local Icon = WelcomeWarning:CreateTexture(nil, 'OVERLAY') do
            Icon:SetTexture([[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
            Icon:SetSize(32, 32)
            Icon:SetPoint('RIGHT', Text, 'LEFT', -8, 0)
        end
        WelcomeWarning.Text = Text
    end

    local ReinputButton = CreateFrame('Button', nil, WelcomeWarning, 'UIPanelButtonTemplate') do
        ReinputButton:SetPoint('BOTTOM')
        ReinputButton:SetSize(120, 26)
        ReinputButton:SetText(L.IMPORT_REINPUT_TEXT)
        ReinputButton:SetScript('OnClick', function()
            self.WelcomeWarning:Hide()
            self.EditBox:SetText('')
            self.EditBox:SetFocus()
        end)
    end

    self.WelcomeNextButton = WelcomeNextButton
    self.EditBox = EditBox
    self.WelcomeWarning = WelcomeWarning
end

function Import:InitPageSelector(frame)
    local PluginDropdown = GUI:GetClass('Dropdown'):New(frame) do
        PluginDropdown:SetPoint('TOP', 0, -58)
        PluginDropdown:SetSize(200, 26)
        PluginDropdown:SetMaxItem(20)
        PluginDropdown:SetDefaultText(L.IMPORT_CHOOSE_PLUGIN)
        PluginDropdown:SetMenuTable(function(list)
            for _, plugin in Addon:IteratePlugins() do
                if type(plugin.IterateKeys) == 'function' then
                    tinsert(list, {
                        text = plugin:GetPluginTitle(),
                        value = plugin,
                    })
                end
            end
        end)
        PluginDropdown:SetCallback('OnSelectChanged', function(_, item)
            self.KeyDropdown:SetValue(nil)
            self:UpdateControl()
        end)
    end

    local KeyDropdown = GUI:GetClass('Dropdown'):New(frame) do
        KeyDropdown:SetPoint('TOP', PluginDropdown, 'BOTTOM', 0, -30)
        KeyDropdown:SetSize(200, 26)
        KeyDropdown:SetMaxItem(20)
        KeyDropdown:SetDefaultText(L.IMPORT_CHOOSE_KEY)

        local function tooltipMore(tip, item)
            local plugin = item.plugin
            local key = item.value
            local notes = plugin:GetPluginNotes()
            local tipFormatting = plugin.OnTooltipFormatting

            if notes then
                tip:AddLine(notes, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, true)
            end
            if type(tipFormatting) == 'function' then
                tip:AddLine(' ')
                tipFormatting(plugin, tip, key)
            end

            if plugin:GetScript(key) then
                tip:AddLine(' ')
                tip:AddLine(L.IMPORT_SCRIPT_EXISTS, RED_FONT_COLOR:GetRGB())
            end
        end

        KeyDropdown:SetMenuTable(function(list)
            local plugin = PluginDropdown:GetValue()
            if not plugin then
                return
            end
            for key in plugin:IterateKeys() do
                tinsert(list, {
                    text = format('|T%s:14|t %s',
                        plugin:GetScript(key) and 518449 or 1319037,
                        plugin:GetTitleByKey(key)
                    ),
                    full = plugin:GetTitleByKey(key),
                    value = key,
                    plugin = plugin,
                    tooltipTitle = plugin:GetPluginTitle(),
                    tooltipMore = tooltipMore,
                    tooltipOnButton = true,
                })
            end
        end)
        KeyDropdown:SetCallback('OnSelectChanged', function()
            self:UpdateControl()
        end)
    end

    local SelectorNextButton = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate') do
        SelectorNextButton:SetPoint('BOTTOM', 0, 20)
        SelectorNextButton:SetSize(120, 26)
        SelectorNextButton:SetText(CONTINUE)
        SelectorNextButton:SetScript('OnClick', function()
            local plugin = PluginDropdown:GetValue()
            local key = KeyDropdown:GetValue()
            local db = self.data.db
            db.name = db.name or plugin:GetTitleByKey(key) or plugin:AllocName()
            local script = Addon:GetClass('Script'):New(self.data.db, plugin, key)

            self:SetScript(script)
            self.PageFrame:SetPage(3)
        end)
    end

    self.PluginDropdown = PluginDropdown
    self.KeyDropdown = KeyDropdown
    self.SelectorNextButton = SelectorNextButton
end

function Import:InitPageImport(frame)
    local ScriptInfo = CreateFrame('Button', nil, frame) do
        ScriptInfo:SetSize(200, 28)
        ScriptInfo:SetPoint('TOP', 0, -48)
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

    local WarningHelp = CreateFrame('Frame', nil, frame) do
        WarningHelp:SetAllPoints(true)

        local Text = WarningHelp:CreateFontString(nil, 'OVERLAY', 'GameFontRed') do
            Text:SetPoint('TOP', ScriptInfo, 'BOTTOM', 0, -20)
            Text:SetPoint('LEFT', 60, 0)
            Text:SetPoint('RIGHT', -20, 0)
            Text:SetText(L.SCRIPT_IMPORT_LABEL_COVER)
        end

        local Icon = WarningHelp:CreateTexture(nil, 'OVERLAY') do
            Icon:SetTexture([[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
            Icon:SetSize(32, 32)
            Icon:SetPoint('RIGHT', Text, 'LEFT', -8, 0)
        end
    end

    local CoverCheck = CreateFrame('CheckButton', nil, frame, 'UICheckButtonTemplate') do
        CoverCheck:SetPoint('BOTTOM', -60, 50)
        CoverCheck:SetSize(26, 26)
        CoverCheck:SetHitRectInsets(0, -100, 0, 0)
        CoverCheck:SetFontString(CoverCheck.text)
        CoverCheck:SetText(L.SCRIPT_IMPORT_LABEL_GOON)
        CoverCheck:SetScript('OnClick', function()
            self:UpdateControl()
        end)
    end

    local ExtraCheck = CreateFrame('CheckButton', nil, frame, 'UICheckButtonTemplate') do
        ExtraCheck:SetPoint('BOTTOM', CoverCheck, 'TOP', 0, -3)
        ExtraCheck:SetSize(26, 26)
        ExtraCheck:SetHitRectInsets(0, -100, 0, 0)
        ExtraCheck:SetFontString(ExtraCheck.text)
        ExtraCheck:SetText(L.SCRIPT_IMPORT_LABEL_EXTRA)
    end

    local SaveButton = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate') do
        SaveButton:SetPoint('BOTTOM', 0, 20)
        SaveButton:SetSize(120, 22)
        SaveButton:SetText(SAVE)
        SaveButton:SetScript('OnClick', function()
            self:OnSaveButtonClick()
        end)
    end

    self.CoverCheck = CoverCheck
    self.ExtraCheck = ExtraCheck
    self.SaveButton = SaveButton
    self.WarningHelp = WarningHelp
    self.ScriptInfo = ScriptInfo
end

function Import:OnTextChanged()
    local ok, data = Addon:Import(self.EditBox:GetText():trim())
    if not ok then
        self:Clear()
    else
        self:SetData(data)
    end
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

    if script then
        self.ScriptInfo.Icon:SetTexture(script:GetPlugin():GetPluginIcon())
        self.ScriptInfo:SetText(format('%s-%s', script:GetPlugin():GetPluginTitle(), script:GetName()))
        self.ScriptInfo:Show()
    else
        self.ScriptInfo:Hide()
    end

    if script and script:GetPlugin():GetScript(script:GetKey()) then
        self.WarningHelp:Show()
        self.CoverCheck:Show()
    else
        self.WarningHelp:Hide()
        self.CoverCheck:Hide()
    end

    if extra then
        if not self.CoverCheck:IsShown() then
            self.ExtraCheck:SetPoint('BOTTOM', self.CoverCheck, 'BOTTOM')
        else
            self.ExtraCheck:SetPoint('BOTTOM', self.CoverCheck, 'TOP', 0, -3)
        end
        self.ExtraCheck:Show()
    else
        self.ExtraCheck:Hide()
    end

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

    self.WelcomeNextButton:SetEnabled(not not self.data)
    self.SelectorNextButton:SetEnabled(self.PluginDropdown:GetValue() and self.KeyDropdown:GetValue())
end

function Import:UpdateData()
    local data = self.data
    if not data or not data.db then
        self.data = nil
        return self.PageFrame:SetPage(1)
    end

    if data.warning then
        return self:ShowWarning(data.warning)
    end

    local plugin = data.plugin and Addon:GetPlugin(data.plugin)
    if not plugin or not data.key then
        return self:ShowWarning(L.IMPORT_SHARED_STRING_WARNING)
    end

    local script = Addon:GetClass('Script'):New(data.db, plugin, data.key)
    self:SetScript(script, data.extra)
    self.PageFrame:SetPage(3)
end

function Import:ShowWarning(warning)
    self.WelcomeWarning.Text:SetText(warning)
    self.WelcomeWarning:Show()
end

function Import:Update()
    self:UpdateData()
    self:UpdateControl()
end

function Import:Clear()
    self.data = nil
    self.script = nil
    self:Update()
end

function Import:SetData(data)
    if not data.db or not data.db.code then
        data = nil
    end
    self.data = data
    self.script = nil
    self:Update()
    self.EditBox:ClearFocus()
end
