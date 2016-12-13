--[[
ScriptEditor.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns       = select(2, ...)
local Addon    = ns.Addon
local UI       = ns.UI
local GUI      = LibStub('tdGUI-1.0')
local Snippets = ns.Snippets

local ScriptEditor = Addon:NewClass('ScriptEditor', GUI:GetClass('EditBox'))

function ScriptEditor:Constructor()
    self:SetCallback('OnCursorChanged', self.OnCursorChanged)

    self.AutoCompleteBox = Addon:GetClass('AutoCompleteBox'):New(UIParent)
end

function ScriptEditor:OnCursorChanged(x, y, w, h)
    self.cursorX = x + 10
    self.cursorY = y - 10 + self.ScrollFrame:GetVerticalScroll()
end

function ScriptEditor:OnTextChanged(userInput)
    if not userInput then
        return
    end
    local pos  = self:GetCursorPosition()
    local line = self:GetText():sub(1, pos):match('([^\r\n]+)$')
    if not line then
        return
    end

    local word = line:match('(%w+)$')
    if not word then
        return
    end

    return self:TriggerAutoComplete(self:CallSnippet(Snippets[word], word))
end

function ScriptEditor:CallSnippet(snippet, word)
    local list = Addon:GetClass('SnippetList'):New()

    snippet(list, word)

    return list:ToList()
end

function ScriptEditor:TriggerAutoComplete(list)
    if not list or #list == 0 then
        self.AutoCompleteBox:Hide()
        return
    end
    self.AutoCompleteBox:ClearAllPoints()
    self.AutoCompleteBox:SetPoint('TOPLEFT', self, 'TOPLEFT', self.cursorX, self.cursorY)
    self.AutoCompleteBox:Open(self, list)
    return true
end
