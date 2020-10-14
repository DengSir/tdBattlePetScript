--[[
View.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'View', 1
local GUI = LibStub('tdGUI-1.0')
local View, oldminor = GUI:NewEmbed(MAJOR, MINOR)
if not View then return end

function View:SetItemList(itemList)
    self._itemList = itemList
end

function View:GetItemList()
    return self._itemList
end

function View:SetItemHeight(itemHeight)
    self._itemHeight = itemHeight
end

function View:GetItemHeight()
    return self._itemHeight or 20
end

function View:SetItemWidth(itemWidth)
    self._itemWidth = itemWidth
end

function View:GetItemWidth()
    return self._itemWidth
end

function View:SetItemSpacing(itemSpacing)
    self._itemSpacing = itemSpacing
end

function View:GetItemSpacing()
    return self._itemSpacing or 0
end

function View:SetPadding(...)
    self._leftPadding,
    self._rightPadding,
    self._topPadding,
    self._bottomPadding = ...
end

function View:GetPadding()
    return  self._leftPadding or 0,
            self._rightPadding or self._leftPadding or 0,
            self._topPadding or self._leftPadding or 0,
            self._bottomPadding or self._leftPadding or 0
end

function View:SetItemClass(itemClass)
    self._itemClass = itemClass
end

function View:GetItemClass()
    return self._itemClass or GUI:GetClass('ViewItem')
end

function View:GetItem(index)
    -- return (self._filterList or self._itemList)[index]
    if self._filterList then
        return self._filterList[index]
    elseif self._itemList then
        return self._itemList[index]
    end
end

function View:GetItemCount()
    return self._filterList and #self._filterList or self._itemList and #self._itemList or 0
end

function View:GetButton(index)
    if not self._buttons[index] then
        local parent = self.scrollChild or self
        local button = self:GetItemClass():New(parent)

        button:Hide()
        button:SetOwner(self)
        button:SetFrameLevel(parent:GetFrameLevel() + 1)

        self._buttons[index] = button
        self:UpdateItemPosition(index)
        self:Fire('OnItemCreated', button, index)
    end
    return self._buttons[index]
end

local mixins = {
    'SetItemList',
    'GetItemList',
    'SetItemHeight',
    'GetItemHeight',
    'SetItemWidth',
    'GetItemWidth',
    'SetItemSpacing',
    'GetItemSpacing',
    'SetPadding',
    'GetPadding',
    'SetItemClass',
    'GetItemClass',
    'GetItem',
    'GetItemCount',
    'GetButton',
}

View.Embed = GUI:EmbedFactory(View, mixins)
