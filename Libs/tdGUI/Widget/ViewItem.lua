--[[
ViewItem.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'ViewItem', 3
local ViewItem, oldminor = LibStub('tdGUI-1.0'):NewClass(MAJOR, MINOR, 'Button', 'Owner')
if not ViewItem then return end

local Class = LibStub('LibClass-2.0')

function ViewItem:Constructor(parent)
    self:SetMotionScriptsWhileDisabled(true)
    self:SetFrameLevel(parent:GetFrameLevel() + 1)

    self:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

    self:SetScript('OnClick', self.OnClick)
    self:SetScript('OnEnter', self.OnEnter)
    self:SetScript('OnLeave', self.OnLeave)
    self:SetScript('OnDoubleClick', self.OnDoubleClick)
end

function ViewItem:FireHandler(name, ...)
    local owner = self:GetOwner()
    if owner then
        owner:Fire(name, self, owner:GetItem(self:GetID()), ...)
    end
end

function ViewItem:OnClick(click)
    PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 'igMainMenuOptionCheckBoxOn')

    if click == 'LeftButton' then
        if not IsModifierKeyDown() then
            if self:GetID() == 0 then

            elseif not self._nonSelectable then
                self:GetOwner():SetSelected(self:GetID())
            end
        end
        self:FireHandler('OnItemClick')
    elseif click == 'RightButton' then
        self:FireHandler('OnItemMenu')
    end
end

function ViewItem:OnDoubleClick(click)
    PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 'igMainMenuOptionCheckBoxOn')

    if click == 'LeftButton' then
        self:FireHandler('OnItemDoubleClick')
    end
end

function ViewItem:OnEnter()
    self._isEntered = true
    self:FireHandler('OnItemEnter')
end

function ViewItem:OnLeave()
    self._isEntered = nil
    self:FireHandler('OnItemLeave')
end

function ViewItem:FireFormat()
    self:FireHandler('OnItemFormatting')

    if self._isEntered then
        self:OnEnter()
    end
end

function ViewItem:SetChecked(flag)
    self._checked = flag
end

function ViewItem:GetChecked()
    return self._checked
end

function ViewItem:SetSelectable(flag)
    self._nonSelectable = not flag or nil
end

function ViewItem:BindScript(object, script, handler)
    if not Class:IsWidget(object) then
        error([[bad argument #1 to 'BindScript' (widget expected)]], 2)
    end

    object:SetScript(script, function()
        self:FireHandler(handler)
    end)
end

function ViewItem:BindCallback(object, callback, handler)
    if not Class:IsObject(object) then
        error([[bad argument #1 to 'BindCallback' (widget expected)]], 2)
    end

    object:SetCallback(callback, function()
        self:FireHandler(handler)
    end)
end

ViewItem.GetAutoWidth = ViewItem.GetWidth
