--[[
AutoSizeGridView.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'AutoSizeGridView', 3
local GUI = LibStub('tdGUI-1.0')
local AutoSizeGridView = GUI:NewClass(MAJOR, MINOR, 'Frame', 'Refresh', 'View', 'Select', 'Owner')
if not AutoSizeGridView then return end

function AutoSizeGridView:Constructor()
    self._buttons = {}
    self._layouts = {}

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

    self:SetSelectMode('NONE')
    self:EnableMouseWheel(true)
    self:SetScript('OnShow', self.Refresh)
    self:SetScript('OnMouseWheel', self.OnMouseWheel)
end

function AutoSizeGridView:GetColumnLayout(column)
    if not self._layouts[column] then
        self._layouts[column] = CreateFrame('Frame', nil, self)
    end
    return self._layouts[column]
end

function AutoSizeGridView:SetOffset(value)
    local offset = math.floor(value + 0.5)
    if self._offset ~= offset then
        self._offset = offset
        self:Refresh()
    end
end

function AutoSizeGridView:GetOffset()
    return self._offset or 1
end

function AutoSizeGridView:OnMouseWheel(delta)
    self.scrollBar:SetValue(self.scrollBar:GetValue() - self.scrollBar:GetValueStep() * delta)
end

function AutoSizeGridView:Update()
    self:UpdateScrollBar()
    self:UpdateItems()
end

function AutoSizeGridView:GetMaxCount()
    return self:GetRowCount() * self:GetColumnCount()
end

function AutoSizeGridView:UpdateScrollBar()
    local maxCount  = self:GetMaxCount()
    local itemCount = self:GetItemCount()
    local maxValue  = itemCount <= maxCount and 1 or itemCount - maxCount + 1

    self.scrollBar:SetMinMaxValues(1, maxValue)
    self.scrollBar:SetValue(self:GetOffset())
end

function AutoSizeGridView:UpdateItems()
    local offset      = self:GetOffset()
    local maxCount    = min(self:GetColumnCount() * self:GetRowCount(), self:GetItemCount())
    local columnCount = self:GetColumnCount()
    local rowCount    = self:GetRowCount()

    local left, right, top, bottom = self:GetPadding()
    local spacingV, spacingH       = self:GetItemSpacing()
    local itemHeight               = self:GetItemHeight()

    local columnWidths = {}

    offset = ceil((offset - 1) / columnCount) * columnCount + 1

    for i = 1, columnCount do
        self:GetColumnLayout(i)
    end

    for i, layout in ipairs(self._layouts) do
        if i > columnCount then
            layout:Hide()
        else
            layout:ClearAllPoints()
            layout:SetSize(1, 1)
            layout:Show()

            if i == 1 then
                layout:SetPoint('TOPLEFT', left, -top)
            else
                layout:SetPoint('TOPLEFT', self:GetColumnLayout(i-1), 'TOPRIGHT', spacingH, 0)
            end
        end
    end

    for i = 1, maxCount do
        local button = self:GetButton(i)
        local index  = offset + i - 1
        local column = (index - 1) % columnCount + 1

        if self:GetItem(index) then
            button:SetID(index)
            button:SetChecked(self:IsSelected(index))
            button:Show()
            button:FireFormat()

            local layout    = self:GetColumnLayout(column)
            local autoWidth = button:GetAutoWidth()

            if layout:GetWidth() < autoWidth then
                layout:SetWidth(autoWidth)
                columnWidths[column] = autoWidth
            end

            local row = floor((i-1)/columnCount)
            local col = (i-1)%columnCount
            local y = -row*(itemHeight+spacingV)

            button:SetParent(layout)
            button:ClearAllPoints()
            button:SetPoint('TOPLEFT', layout, 'TOPLEFT', 0, y)
            button:SetPoint('TOPRIGHT', layout, 'TOPRIGHT', 0, y)
            button:SetHeight(itemHeight)
        else
            button:Hide()
        end
    end

    for i = maxCount + 1, #self._buttons do
        self:GetButton(i):Hide()
    end
    
    local width = 0 do
        for i = 1, columnCount do
            width = width + (columnWidths[i] or 0)
        end
        width = width + left + right + (columnCount - 1) * spacingH
    end

    self:SetSize(width, top+bottom+rowCount*(itemHeight+spacingV)-spacingV)
end

function AutoSizeGridView:UpdateItemPosition(i)
end

function AutoSizeGridView:SetColumnCount(columnCount)
    self._columnCount = columnCount
    self:SetScrollStep(columnCount)
end

function AutoSizeGridView:GetColumnCount()
    return self._columnCount or 1
end

function AutoSizeGridView:SetRowCount(rowCount)
    self._rowCount = rowCount
end

function AutoSizeGridView:GetRowCount()
    if not self._rowCount then
        local itemCount = self:GetItemCount()
        local columnCount = self:GetColumnCount()
        if columnCount == 0 then
            return 0
        end
        return math.ceil(itemCount / columnCount)
    end
    return self._rowCount
end

function AutoSizeGridView:SetItemSpacing(itemSpacingV, itemSpacingH)
    self.itemSpacingV, self.itemSpacingH = itemSpacingV, itemSpacingH
end

function AutoSizeGridView:GetItemSpacing()
    return  self.itemSpacingV or 0,
            self.itemSpacingH or self.itemSpacingV or 0
end

function AutoSizeGridView:GetScrollBarFixedWidth()
    return self.scrollBar:IsShown() and self.scrollBar:GetWidth() or 0
end

function AutoSizeGridView:SetScrollStep(scrollStep)
    self.scrollBar.scrollStep = scrollStep
    self.scrollBar:SetValueStep(scrollStep)
    -- self.scrollBar:SetStepsPerPage(scrollStep)
end

function AutoSizeGridView:GetScrollStep()
    return self.scrollBar.scrollStep
end
