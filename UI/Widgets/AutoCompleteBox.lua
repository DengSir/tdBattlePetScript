--[[
AutoCompleteBox.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]


local ns              = select(2, ...)
local Addon           = ns.Addon
local GUI             = LibStub('tdGUI-1.0')
local AutoCompleteBox = Addon:NewClass('AutoCompleteBox', GUI:GetClass('AutoSizeGridView'))

function AutoCompleteBox:Constructor()
    self:Hide()
    self:SetSize(100, 100)
    self:SetItemHeight(20)
    self:SetItemClass(Addon:GetClass('AutoCompleteItem'))
    self:SetSelectMode('RADIO')
    self:SetClampedToScreen(true)
    self:SetFrameStrata('FULLSCREEN_DIALOG')
    self:EnableMouse(true)

    self:SetPadding(13)
    self:SetItemSpacing(5)
    self:SetBackdrop{
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        edgeSize = 16, tileSize = 16, tile = true,
        insets = {left = 4, right = 4, top = 4, bottom = 4},
    }
    self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
    self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)

    self:SetCallback('OnItemFormatting', self.OnItemFormatting)
    self:SetCallback('OnItemClick', self.OnItemClick)
    self:SetCallback('OnSelectChanged', self.OnSelectChanged)
    self:SetScript('OnKeyDown', self.OnKeyDown)
    self:SetScript('OnHide', self.OnHide)
end

function AutoCompleteBox:Open(object, list, column)
    self:SetOwner(object)
    self:SetPoint('CENTER')
    self:SetColumnCount(column)
    self:SetItemList(list)
    self:SetSelected(1)
    if not list[1].value then
        self:SetSelected(self:Move(1))
    end
    self:Refresh()
    self:Show()
end

function AutoCompleteBox:Input(item)
    self:GetOwner():Insert(item.value)
    self:Hide()

    if item.callback then
        item.callback(item)
    end
end

function AutoCompleteBox:OnItemFormatting(button, item)
    button:SetItem(item)
    button.CheckedTexture:SetShown(self:IsSelected(button:GetID()))
end

function AutoCompleteBox:OnItemClick(button, item)
    return self:Input(item)
end

function AutoCompleteBox:OnHide()
    self:GetOwner():SetFocus()
end

function AutoCompleteBox:OnKeyDown(key)
    self:SetPropagateKeyboardInput(false)
    if key == 'UP' then
        self:OnArrowPresssed(-1*self:GetColumnCount())
    elseif key == 'DOWN' then
        self:OnArrowPresssed(1*self:GetColumnCount())
    elseif key == 'LEFT' then
        self:OnArrowPresssed(-1)
    elseif key == 'RIGHT' then
        self:OnArrowPresssed(1)
    elseif key == 'ENTER' or key == 'TAB' then
        self:OnEnterPressed()
    elseif key == 'ESCAPE' then
        self:Hide()
    else
        self:SetPropagateKeyboardInput(true)
        self:Hide()
    end
end

function AutoCompleteBox:OnArrowPresssed(delta)
    self:SetSelected(self:Move(delta))
end

function AutoCompleteBox:Move(delta)
    local index = self:GetSelected()
    local max   = self:GetItemCount()

    repeat
        index = (index + delta - 1) % self:GetItemCount() + 1
    until self:GetItem(index).value

    return index
end

function AutoCompleteBox:OnEnterPressed()
    return self:Input(self:GetSelectedItem())
end
