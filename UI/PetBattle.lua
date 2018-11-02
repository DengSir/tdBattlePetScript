--[[
PetBattle.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns       = select(2, ...)
local GUI      = LibStub('tdGUI-1.0')
local L        = ns.L
local UI       = ns.UI
local Addon    = ns.Addon
local Director = ns.Director
local Module   = Addon:NewModule('UI.PetBattle', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')

function Module:OnInitialize()
    local TurnTimer = PetBattleFrame.BottomFrame.TurnTimer
    local SkipButton = TurnTimer.SkipButton

    TurnTimer.ArtFrame2:Hide()
    TurnTimer.ArtFrame2.Show = nop

    local ToolButton = CreateFrame('Button', nil, PetBattleFrame) do
        ToolButton:SetPoint('TOP')
        ToolButton:SetSize(155, 50)
        ToolButton:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

        local Highlight = ToolButton:CreateTexture(nil, 'HIGHLIGHT') do
            Highlight:SetPoint('TOP')
            Highlight:SetAtlas('BattleHUD-Versus', true)
            Highlight:SetBlendMode('ADD')
        end

        ToolButton:SetScript('OnEnter', function(ToolButton)
            PetBattleFrame.TopVersusText:SetTextColor(GREEN_FONT_COLOR:GetRGB())

            GameTooltip:SetOwner(ToolButton, 'ANCHOR_BOTTOM')
            GameTooltip:SetText('tdBattlePetScript')
            GameTooltip:AddLine(L.ADDON_NAME, GREEN_FONT_COLOR:GetRGB())
            GameTooltip:AddLine(' ')
            GameTooltip:AddLine(UI.LEFT_MOUSE_BUTTON .. L.TOGGLE_SCRIPT_SELECTOR, HIGHLIGHT_FONT_COLOR:GetRGB())
            -- GameTooltip:AddLine(UI.RIGHT_MOUSE_BUTTON .. L.TOOLTIP_CREATE_OR_DEBUG_SCRIPT, HIGHLIGHT_FONT_COLOR:GetRGB())
            GameTooltip:Show()
        end)
        ToolButton:SetScript('OnLeave', function()
            PetBattleFrame.TopVersusText:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
            GameTooltip:Hide()
        end)

        ToolButton:SetScript('OnClick', function(ToolButton, click)
            local basePlugin = Addon:GetPlugin('Base')
            GameTooltip:Hide()

            if self.ScriptFrame:IsShown() then
                self.ScriptFrame:Hide()
            else
                self:UpdateScriptList(true)
            end
        end)
    end

    local AutoButton = CreateFrame('Button', 'tdBattlePetScriptAutoButton', SkipButton:GetParent(), 'UIPanelButtonTemplate') do
        AutoButton:SetSize(SkipButton:GetSize())
        AutoButton:SetPoint('LEFT', SkipButton, 'RIGHT')
        AutoButton:SetText(L['Auto'])
        AutoButton:SetEnabled(SkipButton:IsEnabled())
        AutoButton:SetScript('OnClick', function()
            self:OnAutoButtonClick()
        end)
        AutoButton:SetScript('OnShow', function(AutoButton)
            self:UpdateHotKey()
        end)
        AutoButton:SetScript('OnHide', function(AutoButton)
            ClearOverrideBindings(AutoButton)
        end)
        -- AutoButton:SetScript('OnEnter', function(AutoButton)
        --     local script = Director:GetScript()
        --     if script then
        --         UI.OpenScriptTooltip(script, AutoButton, 'ANCHOR_TOP')
        --     end
        -- end)
        -- AutoButton:SetScript('OnLeave', function()
        --     GameTooltip:Hide()
        -- end)

        AutoButton.HotKey = AutoButton:CreateFontString(nil, 'OVERLAY', 'NumberFontNormalSmallGray')
        AutoButton.HotKey:SetPoint('TOPRIGHT', -1, -2)
        AutoButton.HotKey:SetText('')
    end

    local ArtFrame2 = CreateFrame('Frame', nil, TurnTimer) do
        ArtFrame2:SetSize(208, 32)
        ArtFrame2:SetPoint('CENTER', 0, -2)

        local Left = ArtFrame2:CreateTexture('nil', 'OVERLAY') do
            Left:SetParent(ArtFrame2)
            Left:ClearAllPoints()
            Left:SetSize(32, 32)
            Left:SetPoint('TOPLEFT')
            Left:SetTexture([[Interface\PetBattles\PassButtonFrame]])
            Left:SetTexCoord(0, 0.25, 0, 1)
        end

        local Right = ArtFrame2:CreateTexture('nil', 'OVERLAY') do
            Right:SetSize(32, 32)
            Right:SetPoint('TOPRIGHT')
            Right:SetTexture([[Interface\PetBattles\PassButtonFrame]])
            Right:SetTexCoord(0.75, 1, 0, 1)
        end

        local Middle = ArtFrame2:CreateTexture('nil', 'OVERLAY') do
            Middle:SetPoint('TOPLEFT', Left, 'TOPRIGHT')
            Middle:SetPoint('BOTTOMRIGHT', Right, 'BOTTOMLEFT')
            Middle:SetTexture([[Interface\PetBattles\PassButtonFrame]])
            Middle:SetTexCoord(0.25, 0.75, 0, 1)
        end

        SkipButton:SetFrameLevel(ArtFrame2:GetFrameLevel() + 10)
        AutoButton:SetFrameLevel(ArtFrame2:GetFrameLevel() + 10)
    end

    local ScriptFrame = GUI:GetClass('BasicPanel'):New(PetBattleFrame) do
        ScriptFrame:Hide()
        ScriptFrame:SetFrameStrata('DIALOG')
        ScriptFrame:SetSize(200, 200)
        ScriptFrame:SetText(L['Script selector'])
        ScriptFrame:RegisterConfig(Addon.db.profile.scriptSelectorPosition)
        ScriptFrame:RestorePosition()
    end

    local ScriptList = GUI:GetClass('GridView'):New(ScriptFrame) do
        ScriptList:SetPoint('TOPLEFT', 5, -25)
        ScriptList:SetPoint('TOPRIGHT', -5, -25)
        ScriptList:SetItemHeight(30)
        ScriptList:SetItemWidth(200)
        ScriptList:SetAutoSize(true)
        ScriptList:SetRowCount(5)
        ScriptList:SetColumnCount(1)
        ScriptList:SetItemClass(Addon:GetClass('ScriptItem'))

        local EmptyLabel = ScriptList:CreateFontString(nil, 'OVERLAY', 'GameFontNormalOutline') do
            EmptyLabel:SetText(L['No script'])
            EmptyLabel:SetPoint('CENTER', ScriptFrame, 'CENTER', 0, -10)
            EmptyLabel:Hide()
        end

        ScriptList:SetCallback('OnItemFormatting', function(ScriptList, button, plugin)
            local key = plugin:GetCurrentKey()
            local script = key and plugin:GetScript(key)

            button.key    = key
            button.script = script
            button:SetText(plugin:GetPluginTitle())
            button.Icon:SetTexture(plugin:GetPluginIcon())

            if script then
                button.Checked:SetShown(script == Director:GetScript())
                button:SetDesaturated(false)
            else
                button.Checked:Hide()
                button:SetDesaturated(true)
            end
        end)
        ScriptList:SetCallback('OnItemClick', function(ScriptList, button, plugin)
            self.ScriptFrame:Hide()

            if button.script then
                Director:SetScript(button.script)
            else
                plugin:OpenScriptEditor(button.key, plugin:GetTitleByKey(button.key))
            end
        end)
        ScriptList:SetCallback('OnItemMenu', function(ScriptList, button, plugin)
            if button.script then
                self.ScriptFrame:Hide()
                plugin:OpenScriptEditor(button.key, plugin:GetTitleByKey(button.key))
            end
        end)
        ScriptList:SetCallback('OnItemEnter', function(ScriptList, button, plugin)
            if button.script then
                local tip = UI.OpenScriptTooltip(button.script, button, 'ANCHOR_BOTTOMRIGHT')
                tip:AddLine(' ')
                tip:AddLine(UI.LEFT_MOUSE_BUTTON .. L['Select script'])
                tip:AddLine(UI.RIGHT_MOUSE_BUTTON .. L['Debugging script'])
                tip:Show()
            else
                local tip = UI.OpenPluginTooltip(plugin, button.key, button, 'ANCHOR_BOTTOMRIGHT')
                tip:AddLine(' ')
                tip:AddLine(UI.LEFT_MOUSE_BUTTON .. L['Create script'])
                tip:Show()
            end
        end)
        ScriptList:SetCallback('OnItemLeave', function()
            GameTooltip:Hide()
        end)
        ScriptList:SetCallback('OnRefresh', function(ScriptList)
            if ScriptList:GetItemCount() == 0 then
                EmptyLabel:Show()
                ScriptFrame:SetHeight(60)
            else
                EmptyLabel:Hide()
                ScriptFrame:SetHeight(ScriptList:GetHeight() + 30)
            end
        end)
    end

    self.ToolButton  = ToolButton
    self.SkipButton  = SkipButton
    self.AutoButton  = AutoButton
    self.ArtFrame2   = ArtFrame2
    self.ScriptList  = ScriptList
    self.ScriptFrame = ScriptFrame
end

function Module:OnEnable()
    self:RegisterEvent('PET_BATTLE_ACTION_SELECTED')
    self:RegisterEvent('PET_BATTLE_OPENING_START')
    self:RegisterEvent('PET_BATTLE_CLOSE')
    self:RegisterEvent('PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE', 'UpdateAutoButton')

    self:RegisterMessage('PET_BATTLE_SCRIPT_SCRIPT_UPDATE', 'UpdateAutoButton')
    self:RegisterMessage('PET_BATTLE_SCRIPT_SCRIPT_UPDATE', 'UpdateAutoButton')

    self:RegisterMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED_autoButtonHotKey', 'UpdateHotKey')
    self:RegisterMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED_lockScriptSelector', 'UpdateLocked')

    self:RegisterMessage('PET_BATTLE_SCRIPT_RESET_FRAMES')

    self:SecureHook('PetBattleFrame_UpdatePassButtonAndTimer')

    if C_PetBattles.IsInBattle() then
        self:PetBattleFrame_UpdatePassButtonAndTimer()
        self:UpdateAutoButton()
        self:ScheduleTimer('UpdateScriptList', 0)
    end

    self:UpdateLocked()
end

function Module:PET_BATTLE_OPENING_START()
    self:UpdateScriptList()
    self:UpdateAutoButton()
end

function Module:PET_BATTLE_ACTION_SELECTED()
    self.AutoButton:Disable()
end

function Module:PET_BATTLE_CLOSE()
    self:UpdateAutoButton()
    self.ScriptFrame:Hide()
end

function Module:PET_BATTLE_SCRIPT_RESET_FRAMES()
    self.ScriptFrame:RestorePosition()
end

function Module:UpdateHotKey()
    if not self.AutoButton:IsVisible() then
        return
    end

    ClearOverrideBindings(self.AutoButton)

    local hotKey = Addon:GetSetting('autoButtonHotKey')
    if hotKey then
        SetOverrideBindingClick(self.AutoButton, true, hotKey, self.AutoButton:GetName())
        self.AutoButton.HotKey:SetText(hotKey)
    else
        self.AutoButton.HotKey:SetText('')
    end
end

function Module:UpdateAutoButton()
    self.AutoButton:SetEnabled(Director:GetScript() and (C_PetBattles.IsSkipAvailable() or C_PetBattles.ShouldShowPetSelect()))
end

function Module:UpdateScriptList(userCall)
    local scripts = Director:Select()
    if not userCall then
        if #scripts > 0 and Addon:GetSetting('autoSelect') then
            Director:SetScript(scripts[1])
            return self.ScriptFrame:Hide()
        end
        if #scripts == 0 and Addon:GetSetting('hideNoScript') then
            return self.ScriptFrame:Hide()
        end
    end

    self.ScriptList:SetItemList(self:GetPluginList())
    self.ScriptList:Refresh()
    self.ScriptFrame:Show()
end

function Module:UpdateLocked()
    self.ScriptFrame:SetMovable(not Addon:GetSetting('lockScriptSelector'))
end

function Module:PetBattleFrame_UpdatePassButtonAndTimer()
    local pveBattle = C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)

    self.AutoButton:SetShown(pveBattle)
    self.ArtFrame2:SetShown(pveBattle)

    if pveBattle then
        self.SkipButton:ClearAllPoints()
        self.SkipButton:SetPoint('RIGHT', self.ArtFrame2, 'CENTER', 0, 2)
    end
end

function Module:OnAutoButtonClick()
    if Director:GetScript() then
        Director:Run()
    end
end

function Module:GetPluginList()
    local list = {}
    for name, plugin in Addon:IterateEnabledPlugins() do
        local key = plugin:GetCurrentKey()
        if key then
            tinsert(list, plugin)
        end
    end
    return list
end
