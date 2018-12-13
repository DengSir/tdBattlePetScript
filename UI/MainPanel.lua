--[[
MainPanel.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns       = select(2, ...)
local Addon    = ns.Addon
local UI       = ns.UI
local L        = ns.L
local Director = ns.Director
local GUI      = LibStub('tdGUI-1.0')
local Class    = LibStub('LibClass-2.0')

local STATUS_NONE = 0
local STATUS_ADD  = 1
local STATUS_EDIT = 2

local STATUS_LABELS = {
    [STATUS_ADD]   = L['Create script'],
    [STATUS_EDIT]  = L['Edit script'],
}

local Module = Addon:NewModule('UI.MainPanel', 'AceEvent-3.0')

function Module:OnInitialize()
    local function UpdateLayout() self:UpdateLayout() end
    local function UpdateSaveButton() self:UpdateSaveButton() end

    local MainPanel = GUI:GetClass('BasicPanel'):New(UIParent) do
        MainPanel.SetTitle = function(p, t) return p:SetText('tdBattlePetScript - ' .. t) end

        MainPanel:Hide()
        MainPanel:SetSize(550, 450)
        MainPanel:SetPoint('CENTER')
        MainPanel:SetMovable(true)
        MainPanel:SetResizable(true)
        MainPanel:SetMinResize(550, 350)
        MainPanel:SetMaxResize(900, 700)
        MainPanel:ShowPortrait()
        MainPanel:SetFrameStrata('DIALOG')
        MainPanel:SetTitle(L['Script editor'])
        MainPanel:SetPortrait(ns.ICON)

        MainPanel:RegisterConfig(Addon.db.profile.position)

        MainPanel:SetAttribute('UIPanelLayout-enabled', true)
        MainPanel:SetAttribute('UIPanelLayout-whileDead', true)
        MainPanel:SetAttribute('UIPanelLayout-area', 'left')
        MainPanel:SetAttribute('UIPanelLayout-pushable', 1)
    end

    local Inset = CreateFrame('Frame', nil, MainPanel, 'InsetFrameTemplate') do
        Inset:SetPoint('TOPLEFT', 4, -60)
        Inset:SetPoint('BOTTOMRIGHT', -6, 26)
        Inset.Bg:SetDrawLayer('BACKGROUND')
    end

    local ScriptList = GUI:GetClass('ListView'):New(Inset) do
        ScriptList:SetPoint('TOPLEFT', 0, 0)
        ScriptList:SetPoint('BOTTOMLEFT', 0, -1)
        ScriptList:SetWidth(200)
        ScriptList:SetItemHeight(30)
        ScriptList:SetPadding(5)
        ScriptList:SetSelectMode('RADIO')
        ScriptList:SetItemClass(Addon:GetClass('ScriptItem'))
        ScriptList:SetCallback('OnItemFormatting', function(ScriptList, button, d)
            if d.type == 'plugin' then
                button:SetText(d.value:GetPluginTitle())
                button:SetTexture(d.value:GetPluginIcon())
                button:ShowIcon()
                button:SetSelectable(false)
                button:SetType(d.type)
            elseif d.type == 'script' then
                button:SetText(d.value:GetName())
                button:HideIcon()
                button:SetSelectable(true)
                button:SetType(d.type)
            end
        end)
        ScriptList:SetCallback('OnSelectChanged', function(ScriptList, index, d)
            local script = d.value
            self:OpenScript(script:GetPlugin(), script:GetKey(), script:GetName())
        end)
        ScriptList:SetCallback('OnItemEnter', function(ScriptList, button, d)
            if d.type == 'script' then
                UI.OpenScriptTooltip(d.value, button, 'ANCHOR_RIGHT')
            else
            end
        end)
        ScriptList:SetCallback('OnItemLeave', function()
            GameTooltip:Hide()
        end)
        ScriptList:SetScript('OnShow', function()
            self:UpdateLayout()
            self:UpdateScriptList()
        end)
        ScriptList:SetScript('OnHide', UpdateLayout)
    end

    local Content = CreateFrame('Frame', nil, Inset) do
        Content:SetPoint('TOPLEFT', ScriptList, 'TOPRIGHT', 2, 0)
        Content:SetPoint('BOTTOMRIGHT')
    end

    local Banner = CreateFrame('Frame', nil, Content) do
        Banner:SetPoint('BOTTOMLEFT', Content, 'TOPLEFT')
        Banner:SetPoint('BOTTOMRIGHT', Content, 'TOPRIGHT', -30, 0)
        Banner:SetHeight(35)
    end

    local ShareButton = CreateFrame('Button', nil, MainPanel) do
        ShareButton:SetSize(26, 26)
        ShareButton:SetPoint('LEFT', Banner, 'RIGHT')
        ShareButton:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIcon-Chat-Up]])
        ShareButton:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIcon-Chat-Down]])
        ShareButton:SetHighlightTexture([[Interface\CHATFRAME\UI-ChatIcon-BlinkHilight]], 'ADD')
        ShareButton:SetScript('OnClick', function()
            self:OnShareButtonClick()
        end)
    end

    local HelpIcon = CreateFrame('Button', nil, Banner) do
        HelpIcon:SetSize(28, 28)
        HelpIcon:SetPoint('LEFT', 5, 0)

        local Border = HelpIcon:CreateTexture(nil, 'ARTWORK') do
            Border:SetTexture([[Interface\PetBattles\PetBattleHUD]])
            Border:SetPoint('TOPLEFT', 0, 1)
            Border:SetPoint('BOTTOMRIGHT', 1, 0)
            Border:SetTexCoord(0.884765625, 0.943359375, 0.681640625, 0.798828125)
        end

        local Highlight = HelpIcon:CreateTexture(nil, 'HIGHLIGHT') do
            Highlight:SetPoint('TOPLEFT', -1, 1)
            Highlight:SetPoint('BOTTOMRIGHT', 2, -2)
            Highlight:SetBlendMode('ADD')
            Highlight:SetTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
        end

        local Icon = HelpIcon:CreateTexture(nil, 'BORDER') do
            Icon:SetMask([[Textures\MinimapMask]])
            Icon:SetSize(28, 28)
            Icon:SetAllPoints(true)
        end

        HelpIcon:SetScript('OnEnter', function(HelpIcon)
            UI.OpenScriptTooltip(self.script, HelpIcon, 'ANCHOR_BOTTOMRIGHT')
        end)
        HelpIcon:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)

        function HelpIcon:SetTexture(texture)
            return Icon:SetTexture(texture)
        end
    end

    local ExtraButton = CreateFrame('CheckButton', nil, Banner) do
        ExtraButton:SetSize(26, 26)
        ExtraButton:SetPoint('RIGHT')
        ExtraButton:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollDown-Up]])
        ExtraButton:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollDown-Down]])
        ExtraButton:SetHighlightTexture([[Interface\CHATFRAME\UI-ChatIcon-BlinkHilight]], 'ADD')
        ExtraButton:SetScript('OnClick', function(ExtraButton)
            if ExtraButton:GetChecked() then
                ExtraButton:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollUp-Up]])
                ExtraButton:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollUp-Down]])
                PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF or 'igMainMenuOptionCheckBoxOff')
            else
                ExtraButton:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollDown-Up]])
                ExtraButton:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIcon-ScrollDown-Down]])
                PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 'igMainMenuOptionCheckBoxOn')
            end
            self.ExtraFrame:SetShown(ExtraButton:GetChecked())
        end)
        ExtraButton:SetScript('OnEnter', function(ExtraButton)
            GameTooltip:SetOwner(ExtraButton, 'ANCHOR_BOTTOMLEFT')
            GameTooltip:SetText(L.SCRIPT_EDITOR_LABEL_TOGGLE_EXTRA)
            GameTooltip:Show()
        end)
        ExtraButton:SetScript('OnLeave', function()
            GameTooltip:Hide()
        end)
    end

    local Name = Banner:CreateFontString(nil, 'ARTWORK', 'GameFontNormalOutline') do
        Name:SetHeight(30)
        Name:SetJustifyH('CENTER')
        Name:SetJustifyV('MIDDLE')
        Name:SetPoint('LEFT', HelpIcon, 'RIGHT', 2, 0)
        Name:SetPoint('RIGHT', ExtraButton, 'LEFT', -2, 0)
    end

    local SaveButton = CreateFrame('Button', nil, Content, 'UIPanelButtonTemplate') do
        SaveButton:SetPoint('BOTTOMRIGHT', MainPanel, 'BOTTOMRIGHT', -10, 4)
        SaveButton:SetSize(80, 22)
        SaveButton:SetText(SAVE)
        SaveButton:SetScript('OnClick', function()
            self:OnSaveButtonClick()
        end)
    end

    local DebugButton = CreateFrame('Button', nil, Content, 'UIPanelButtonTemplate') do
        DebugButton:SetPoint('RIGHT', SaveButton, 'LEFT')
        DebugButton:SetSize(80, 22)
        DebugButton:SetText(L['Run'])
        DebugButton:SetScript('OnClick', function()
            self:Run()
        end)
    end

    local DeleteButton = CreateFrame('Button', nil, Content, 'UIPanelButtonTemplate') do
        DeleteButton:SetPoint('BOTTOMLEFT', MainPanel, 'BOTTOMLEFT', 8, 4)
        DeleteButton:SetSize(80, 22)
        DeleteButton:SetText(DELETE)
        DeleteButton:SetScript('OnClick', function()
            self:OnDeleteButtonClick()
        end)
    end

    local ExtraFrame = CreateFrame('Frame', nil, Content) do
        ExtraFrame:Hide()
        ExtraFrame:SetPoint('TOPLEFT')
        ExtraFrame:SetPoint('TOPRIGHT')
        ExtraFrame:SetHeight(40)
        ExtraFrame:EnableMouse(true)
        ExtraFrame:SetScript('OnShow', UpdateLayout)
        ExtraFrame:SetScript('OnHide', UpdateLayout)
    end

    local function MakeBox(className, parent, labelText)
        local class = Class:IsClass(className) and className or GUI:GetClass(className)
        local box = class:New(parent, true) do
            local label = box:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall') do
                label:SetPoint('BOTTOMLEFT', box, 'TOPLEFT')
                label:SetText(labelText)
            end
        end
        return box
    end

    local NameBox = MakeBox('InputBox', ExtraFrame, L['Script name']) do
        NameBox:SetPoint('TOPLEFT', 10, -25)
        NameBox:SetPoint('TOPRIGHT', -10, -25)
        NameBox:SetHeight(22)
        NameBox:SetCallback('OnTextChanged', UpdateSaveButton)
    end

    local ScriptEditor = CreateFrame('Frame', nil, Content) do
        ScriptEditor:SetPoint('TOPLEFT')
        ScriptEditor:SetPoint('BOTTOMRIGHT')
    end

    local ScriptBox = MakeBox(Addon:GetClass('ScriptEditor'), ScriptEditor, L['Script']) do
        ScriptBox:SetPoint('TOPLEFT', 10, -25)
        ScriptBox:SetPoint('BOTTOMRIGHT', -10, 10)
        ScriptBox:SetCallback('OnTextChanged', function(ScriptBox, userInput)
            ScriptBox:OnTextChanged(userInput)
            self.BugFrame:Hide()
            self:UpdateSaveButton()
        end)
    end

    local BugFrame = CreateFrame('Frame', nil, Content) do
        BugFrame:Hide()
        BugFrame:SetPoint('BOTTOMLEFT', 8, 6)
        BugFrame:SetPoint('BOTTOMRIGHT', -8, 6)
        BugFrame:SetHeight(32)
        BugFrame:SetBackdrop{
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            tile = true,
            edgeSize = 16,
        }
        BugFrame:SetBackdropBorderColor(0.5, 0.5, 0.5)

        local Bg = BugFrame:CreateTexture(nil, 'BACKGROUND') do
            Bg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
            Bg:SetPoint('TOPLEFT', 3, -3)
            Bg:SetPoint('BOTTOMRIGHT', -3, 3)
            Bg:SetTexCoord(0, 1, 0, 0.2)
        end

        local Icon = BugFrame:CreateTexture(nil, 'ARTWORK') do
            Icon:SetSize(26, 26)
            Icon:SetTexture([[Interface\HELPFRAME\HelpIcon-Bug]])
            Icon:SetPoint('LEFT', 10, 0)
        end

        local Text = BugFrame:CreateFontString(nil, 'ARTWORK', 'GameFontRed') do
            Text:SetPoint('LEFT', Icon, 'RIGHT', 5, 0)
            Text:SetPoint('RIGHT', -5, 0)
            Text:SetJustifyH('LEFT')
            Text:SetWordWrap(false)
        end
        BugFrame.Text = Text
        BugFrame.Icon = Icon

        BugFrame:SetScript('OnEnter', function(BugFrame)
            if not BugFrame.err then
                return
            end
            GameTooltip:SetOwner(BugFrame, 'ANCHOR_TOP')
            GameTooltip:SetText('Bug')
            GameTooltip:AddLine(BugFrame.message, 1, 1, 1, true)
            GameTooltip:AddLine(BugFrame.err,     1, 0, 0, true)
            GameTooltip:Show()
        end)
        BugFrame:SetScript('OnLeave', GameTooltip_Hide)
        BugFrame:SetScript('OnShow', UpdateLayout)
        BugFrame:SetScript('OnHide', UpdateLayout)
    end

    local EditBoxGroup = GUI:GetClass('EditBoxGroup'):New() do
        EditBoxGroup:RegisterEditBox(NameBox)
        EditBoxGroup:RegisterEditBox(ScriptBox.EditBox)
    end

    local BlockDialog = GUI:GetClass('BlockDialog'):New(MainPanel) do
        BlockDialog:SetPoint('TOPLEFT', 3, -22)
        BlockDialog:SetPoint('BOTTOMRIGHT', -3, 3)
        BlockDialog:SetFrameLevel(MainPanel:GetFrameLevel() + 100)
    end

    self.Banner         = Banner
    self.BlockDialog    = BlockDialog
    self.BugFrame       = BugFrame
    self.CollapseButton = CollapseButton
    self.Content        = Content
    self.Content        = Content
    self.DebugButton    = DebugButton
    self.DeleteButton   = DeleteButton
    self.EditBoxGroup   = EditBoxGroup
    self.ExtraFrame     = ExtraFrame
    self.HelpIcon       = HelpIcon
    self.MainPanel      = MainPanel
    self.Name           = Name
    self.NameBox        = NameBox
    self.SaveButton     = SaveButton
    self.ScriptBox      = ScriptBox
    self.ScriptEditor   = ScriptEditor
    self.ScriptList     = ScriptList
    self.ShareButton    = ShareButton

    self:Bind('UpdateLayout', MainPanel)
    self:Bind('UpdateStatus', Content)
    self:Bind('UpdateSaveButton', SaveButton)
end

function Module:OnEnable()
    self:OnFontChanged()

    self:RegisterEvent('PET_BATTLE_ACTION_SELECTED')
    self:RegisterEvent('PET_BATTLE_OPENING_START', 'UpdateDebugButton')
    self:RegisterEvent('PET_BATTLE_CLOSE', 'UpdateDebugButton')
    self:RegisterEvent('PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE', 'UpdateDebugButton')
    self:RegisterMessage('PET_BATTLE_SCRIPT_SCRIPT_LIST_UPDATE', 'UpdateScriptList')

    self:RegisterMessage('PET_BATTLE_SCRIPT_RESET_FRAMES')
    self:RegisterMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED_editorFontFace', 'OnFontChanged')
    self:RegisterMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED_editorFontSize', 'OnFontChanged')
end

function Module:OnFontChanged()
    self.ScriptBox:SetFont(Addon:GetSetting('editorFontFace'), Addon:GetSetting('editorFontSize'))
end

function Module:PET_BATTLE_ACTION_SELECTED()
    self.DebugButton:Disable()
end

function Module:PET_BATTLE_SCRIPT_RESET_FRAMES()
    self.MainPanel:RestorePosition()
    self.MainPanel:RestoreSize()
end

function Module:UpdateScriptList()
    if not self.ScriptList:IsShown() then
        return
    end

    local list = {} do
        for _, plugin in Addon:IteratePlugins() do
            tinsert(list, {
                type = 'plugin',
                value = plugin
            })

            local scripts = {} do
                for _, script in plugin:IterateScripts() do
                    tinsert(scripts, script)
                end
                sort(scripts, function(a, b)
                    return a:GetName() < b:GetName()
                end)
            end

            for _, script in ipairs(scripts) do
                tinsert(list, {
                    type = 'script',
                    value = script
                })
            end
        end
    end

    self.ScriptList:SetItemList(list)
    self.ScriptList:Refresh()
end

function Module:Message(flag, message, err)
    self.BugFrame.Icon:SetTexture(flag and [[Interface\DialogFrame\UI-Dialog-Icon-AlertOther]] or [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
    self.BugFrame.Text:SetFontObject(flag and 'GameFontNormalSmall' or 'GameFontRedSmall')
    self.BugFrame.Text:SetText(err and message .. ': ' .. err or message)
    self.BugFrame:Show()
    self.BugFrame.err     = err
    self.BugFrame.message = message
end

function Module:Clear()
    self.isDialog = false
    self.script   = nil
    self.plugin   = nil
    self.key      = nil
    self.status   = STATUS_NONE
end

function Module:OpenScript(plugin, key, defaultName)
    local script = plugin:GetScript(key)
    if script then
        self.script = script
        self.status = STATUS_EDIT
    else
        self.script = Addon:GetClass('Script'):New({}, plugin, key)
        self.status = STATUS_ADD
    end

    self.plugin      = plugin
    self.key         = key
    self.defaultName = self.script:GetName() or defaultName

    self:UpdateLayout()
    self:UpdateSaveButton()
    self:UpdateStatus()
    self:UpdateScript()

    self.Content:Show()
end

function Module:OpenScriptDialog(...)
    self:OpenScript(...)
    self:ShowDialog()
end

function Module:ShowDialog()
    self.isDialog = true
    self.ScriptList:Hide()
    self.MainPanel:RestorePosition()
    self.MainPanel:RestoreSize()
    self.MainPanel:SetMovable(true)
    self.MainPanel:SetResizable(true)
    self.MainPanel:SetFrameStrata('DIALOG')
    self.MainPanel:SetTitle(L['Script editor'])

    if self.MainPanel:IsShown() then
        self:HidePanel()
    end

    self.MainPanel:Show()
end

function Module:ShowPanel()
    self:Clear()
    self.ScriptList:Show()
    self.Content:Hide()
    self.MainPanel:SetSize(550, 450)
    self.MainPanel:SetMovable(false)
    self.MainPanel:SetResizable(false)
    self.MainPanel:SetFrameStrata('MEDIUM')
    self.MainPanel:SetTitle(L['Script manager'])

    if self.MainPanel:IsShown() then
        self:HidePanel()
    end
    self.MainPanel:SetAttribute('UIPanelLayout-defined', true)
    ShowUIPanel(self.MainPanel)
end

function Module:TogglePanel()
    if self.MainPanel:IsShown() then
        self:HidePanel()
    else
        self:ShowPanel()
    end
end

function Module:HidePanel()
    HideUIPanel(self.MainPanel)
end

function Module:UpdateLayout()
    if not self.MainPanel:IsVisible() then
        return
    end
    if self.ScriptList:IsShown() then
        self.Content:SetPoint('TOPLEFT', self.ScriptList, 'TOPRIGHT', 2, 0)
        self.MainPanel:SetMinResize(550, 350)
        self.MainPanel:SetMaxResize(900, 700)
        self.MainPanel:ShowPortrait()
    else
        self.Content:SetPoint('TOPLEFT')
        self.MainPanel:SetMinResize(350, 350)
        self.MainPanel:SetMaxResize(700, 700)
        self.MainPanel:HidePortrait()
    end

    if self.ExtraFrame:IsShown() then
        self.ScriptEditor:SetPoint('TOPLEFT', self.ExtraFrame, 'BOTTOMLEFT')
    else
        self.ScriptEditor:SetPoint('TOPLEFT')
    end

    if self.BugFrame:IsShown() then
        self.ScriptEditor:SetPoint('BOTTOMRIGHT', 0, 30)
    else
        self.ScriptEditor:SetPoint('BOTTOMRIGHT')
    end
end

function Module:UpdateScript()
    self.BugFrame:Hide()
    self.BlockDialog:Hide()

    self.HelpIcon:SetTexture(self.plugin:GetPluginIcon())

    self.NameBox:SetText(self.defaultName)
    self.ScriptBox:SetText(self.script:GetCode() or '')
end

function Module:UpdateDebugButton()
    self.DebugButton:SetShown(C_PetBattles.IsInBattle())
    self.DebugButton:SetEnabled(C_PetBattles.IsSkipAvailable() or C_PetBattles.ShouldShowPetSelect())
end

function Module:UpdateSaveButton()
    self.SaveButton:SetEnabled(self:IsCanSave())
end

function Module:UpdateStatus()
    self.Name:SetFormattedText('%s: |cff00ff00%s|r-|cffffffff%s|r', STATUS_LABELS[self.status], self.plugin:GetPluginTitle(), self.defaultName)

    self.DeleteButton:SetShown(self.status == STATUS_EDIT)
    self.DebugButton:SetShown(C_PetBattles.IsInBattle())
end

function Module:IsCanSave()
    if not self:GetEditBoxText(self.ScriptBox) then
        return false
    end
    return  self.script:GetCode()   ~= self:GetEditBoxText(self.ScriptBox) or
            self.script:GetName()   ~= self:GetEditBoxText(self.NameBox)
end

function Module:GetEditBoxText(editBox)
    local text = editBox:GetText():trim()
    return text ~= '' and text or nil
end

function Module:OnSaveButtonClick()
    local ok, err = self.script:SetCode(self.ScriptBox:GetText():trim())
    if ok and not self.status ~= STATUS_EDIT then
        self.status = STATUS_EDIT
        self.plugin:AddScript(self.key, self.script)
    end

    self:Message(ok, ok and L['Save success'] or L['Found error'], err)

    if not ok then
        return
    end

    self.script:SetName(self:GetEditBoxText(self.NameBox))

    self.EditBoxGroup:ClearFocus()
    self:UpdateSaveButton()
    self:UpdateStatus()
end

function Module:OnBeautyButtonClick()
    if not self.script:GetCode() or self:IsCanSave() then
        return
    end
    local code = Director:BeautyScript(self.script:GetScript())

    self.ScriptBox:SetText(code)
end

function Module:OnDeleteButtonClick()
    self.EditBoxGroup:ClearFocus()
    self.BlockDialog:Open{
        text     = format(L.SCRIPT_EDITOR_DELETE_SCRIPT, self.plugin:GetPluginTitle(), self.script:GetName()),
        delay    = Addon:GetSetting('noWaitDeleteScript') and 0 or 3,
        ctx      = self.script,
        OnAccept = function(script)
            script:GetPlugin():RemoveScript(script:GetKey())
            if self.isDialog then
                self:HidePanel()
            else
                self:ShowPanel()
            end
        end,
    }
end

function Module:Run()
    local script, err = Director:BuildScript(self:GetEditBoxText(self.ScriptBox))
    if not script then
        self:Message(false, L['Found error'], err)
    else
        Director:Debug(script)
    end
end

function Module:OnShareButtonClick()
    GUI:ToggleMenu(self.ShareButton, {
        {
            text     = L['Beauty script'],
            disabled = not self.script or not self.script:GetCode() or self:IsCanSave(),
            func     = function()
                self:OnBeautyButtonClick()
            end
        },
        {
            text = L['Import'],
            func = function()
                UI.Import.Frame:Show()
                self:HidePanel()
            end
        },
        {
            text     = L['Export'],
            disabled = self.status ~= STATUS_EDIT,
            func     = function()
                self.BlockDialog:Open{
                    text             = L['Export'],
                    cancelHidden     = true,
                    acceptText       = OKAY,
                    editBox          = true,
                    editText         = Addon:Export(self.script),
                    editFocus        = true,
                    editHighlightAll = true,
                    editFocusLost    = 'ACCEPT',
                }
            end
        },
        {
            text = L['Options'],
            func = function()
                Addon:OpenOptionFrame()
            end
        }
    })
end

function Module:Bind(method, obj)
    GUI:Embed(obj, 'Refresh')

    local fn = self[method]

    obj.Update = function(...)
        return fn(self, ...)
    end

    self[method] = function()
        return obj:Refresh()
    end
end
