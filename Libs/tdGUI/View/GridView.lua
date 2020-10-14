--[[
GridView.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'GridView', 5
local GUI = LibStub('tdGUI-1.0')
local GridView = GUI:NewClass(MAJOR, MINOR, 'Frame', 'Refresh', 'View', 'Select', 'Owner')
if not GridView then return end

function GridView:Constructor()
    self._buttons = {}
    self:SetSelectMode('NONE')
    self:SetScript('OnShow', self.Refresh)
    self:SetScript('OnSizeChanged', self.OnSizeChanged)

    local scrollBar = CreateFrame('Slider', nil, self, 'UIPanelScrollBarTemplate') do
        self.scrollBar  = scrollBar
        self.scrollUp   = scrollBar.ScrollUpButton
        self.scrollDown = scrollBar.ScrollDownButton

        scrollBar.thumbTexture = scrollBar.ThumbTexture
        scrollBar:SetValueStep(1)
        scrollBar:SetStepsPerPage(1)
        scrollBar:SetPoint('TOPRIGHT', 0, -18)
        scrollBar:SetPoint('BOTTOMRIGHT', 0, 18)
        scrollBar:SetScript('OnValueChanged', function(scrollBar, value)
            HybridScrollFrame_UpdateButtonStates(self, value)
            self:SetOffset(value)
        end)
        scrollBar:SetScript('OnMinMaxChanged', function(scrollBar, minValue, maxValue)
            scrollBar:SetShown(minValue ~= maxValue)
        end)
        scrollBar:SetScript('OnShow', function(scrollBar)
            self:Refresh()
        end)
        scrollBar:SetScript('OnHide', function(scrollBar)
            self:Refresh()
        end)
    end

    self:EnableMouseWheel(true)
    self:SetScript('OnMouseWheel', self.OnMouseWheel)
end

function GridView:SetOffset(value)
    local offset = math.floor(value + 0.5)
    if self._offset ~= offset then
        self._offset = offset
        self:Refresh()
    end
end

function GridView:GetOffset()
    return self._offset or 1
end

function GridView:OnMouseWheel(delta)
    self.scrollBar:SetValue(self.scrollBar:GetValue() - self.scrollBar:GetValueStep() * delta)
end

function GridView:OnSizeChanged()
    self._rowCount = nil
    self:UpdateLayout()
    self:Refresh()
end

function GridView:Update()
    self:UpdateScrollBar()
    self:UpdateItems()
    self:UpdateLayout()
end

function GridView:GetMaxCount()
    return self:GetRowCount() * self:GetColumnCount()
end

function GridView:UpdateScrollBar()
    local maxCount  = self:GetMaxCount()
    local itemCount = self:GetItemCount()
    local maxValue  = itemCount <= maxCount and 1 or itemCount - maxCount + 1

    self.scrollBar:SetMinMaxValues(1, maxValue)
    self.scrollBar:SetValue(self:GetOffset())
end

function GridView:UpdateLayout()
    for i in ipairs(self._buttons) do
        self:UpdateItemPosition(i)
    end
end

function GridView:UpdateItemPosition(i)
    local button                     = self:GetButton(i)
    local itemSpacingV, itemSpacingH = self:GetItemSpacing()
    local itemHeight                 = self:GetItemHeight()
    local itemWidth                  = self:GetItemWidth()
    local lineCount                  = self:GetColumnCount()
    local left, right, top, bottom   = self:GetPadding()

    right = right + self:GetScrollBarFixedWidth()

    button:ClearAllPoints()

    if lineCount == 1 then
        button:SetHeight(itemHeight)
        button:SetPoint('TOPLEFT', left, -top-(i-1)*(itemHeight+itemSpacingV))
        button:SetPoint('TOPRIGHT', -right, -top-(i-1)*(itemHeight+itemSpacingV))
    else
        local row = floor((i-1)/lineCount)
        local col = (i-1)%lineCount

        button:SetSize(itemWidth, itemHeight)
        button:SetPoint('TOPLEFT', left+col*(itemWidth+itemSpacingH), -top-row*(itemHeight+itemSpacingV))
    end
end

function GridView:UpdateItems()
    if not self:GetRight() then
        return
    end

    local offset    = self:GetOffset()
    local maxCount  = min(self:GetColumnCount() * self:GetRowCount(), self:GetItemCount())
    local autoWidth = self:GetItemWidth() or 1
    local maxRight  = 0

    local column = self:GetColumnCount()
    offset = ceil((offset - 1) / column) * column + 1

    for i = 1, maxCount do
        local button = self:GetButton(i)
        local index = offset + i - 1

        if self:GetItem(index) then
            button:SetID(index)
            button:SetChecked(self:IsSelected(index))
            button:Show()
            button:FireFormat()

            autoWidth = max(autoWidth, button:GetAutoWidth() or 0)
            maxRight  = max(maxRight, button:GetRight())
        else
            button:Hide()
        end
    end

    for i = maxCount + 1, #self._buttons do
        self:GetButton(i):Hide()
    end

    if maxCount > 0 and self:IsAutoSize() then
        local left, right, top, bottom = self:GetPadding()
        local height                   = self:GetTop() - self:GetButton(maxCount):GetBottom() + bottom
        local width                    = self:GetScrollBarFixedWidth()

        if self:GetColumnCount() == 1 then
            width = width + autoWidth + left + right
        else
            width = width + maxRight - self:GetLeft() + right
        end
        self:SetSize(width, height)
    end
end

function GridView:SetColumnCount(columnCount)
    self._columnCount = columnCount
    self:SetScrollStep(columnCount)
end

function GridView:GetColumnCount()
    return self._columnCount or 1
end

function GridView:SetRowCount(rowCount)
    self._rowCount = rowCount
    self:SetScript('OnSizeChanged', nil)
end

function GridView:GetRowCount()
    if not self._rowCount then
        if self._autoSize then
            return self:GetItemCount()
        else
            local itemHeight  = self:GetItemHeight()
            local itemSpacing = self:GetItemSpacing()
            local top, bottom = select(2, self:GetPadding())
            local height      = self:GetHeight() - top - bottom + itemSpacing

            self._rowCount = floor(height / (itemHeight + itemSpacing))
        end
    end
    return self._rowCount
end

function GridView:SetAutoSize(_autoSize)
    self._autoSize = _autoSize
    self:SetScript('OnSizeChanged', not autosize and self.OnSizeChanged or nil)
    self:SetSize(1, 1)
end

function GridView:IsAutoSize()
    return self._autoSize
end

function GridView:GetItemWidth()
    if not self._autoSize then
        local left, right     = self:GetPadding()
        local _, itemSpacingH = self:GetItemSpacing()
        local columnCount     = self:GetColumnCount()
        local width           = self:GetWidth() - left - right - (columnCount-1) * itemSpacingH - self:GetScrollBarFixedWidth()

        self._itemWidth = width / columnCount

        return self._itemWidth
    end
    return self._itemWidth or 20
end

function GridView:SetItemSpacing(itemSpacingV, itemSpacingH)
    self.itemSpacingV, self.itemSpacingH = itemSpacingV, itemSpacingH
end

function GridView:GetItemSpacing()
    return  self.itemSpacingV or 0,
            self.itemSpacingH or self.itemSpacingV or 0
end

function GridView:GetScrollBarFixedWidth()
    return self.scrollBar:IsShown() and self.scrollBar:GetWidth() or 0
end

function GridView:SetScrollStep(scrollStep)
    self.scrollBar.scrollStep = scrollStep
    self.scrollBar:SetValueStep(scrollStep)
    -- self.scrollBar:SetStepsPerPage(scrollStep)
end

function GridView:GetScrollStep()
    return self.scrollBar.scrollStep
end
