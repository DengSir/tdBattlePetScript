--[[
ScriptEditor.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local UI    = ns.UI
local Util  = ns.Util
local GUI   = LibStub('tdGUI-1.0')

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

    local condition = line:match('[[&]([^&[]+)$')
    local owner, pet = self:ParseOwnerPet(condition)

    local list, column = Addon:MakeSnippets(word, condition, owner, pet)
    if not list then
        self.AutoCompleteBox:Hide()
    else
        self.AutoCompleteBox:ClearAllPoints()
        self.AutoCompleteBox:SetPoint('TOPLEFT', self, 'TOPLEFT', self.cursorX, self.cursorY)
        self.AutoCompleteBox:Open(self, list, column)
    end
end

function ScriptEditor:ParseOwnerPet(condition)
    if not condition then
        return
    end

    local arg = strsplit('.', condition:trim())
    if not arg then
        return
    end

    local owner, pet = arg:match('^([^()]+)%(?([^()]*)%)?$')
    owner = Util.ParsePetOwner(owner)
    if not owner then
        return
    end

    if not C_PetBattles.IsInBattle() then
        return owner
    end

    pet = pet ~= '' and pet or nil
    pet = Util.ParsePetIndex(owner, pet)

    return owner, pet
end
