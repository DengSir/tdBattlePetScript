--[[
Select.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'Select', 1
local GUI = LibStub('tdGUI-1.0')
local View, oldminor = GUI:NewEmbed(MAJOR, MINOR)
if not View then return end

local SELECT_MODES = {
    NONE = {
        SetSelected     = nop,
        GetSelected     = nop,
        IsSelected      = nop,
        GetSelectedItem = nop,
        SetSelectedItem = nop,
    },
    RADIO = {
        SetSelected = function(self, index)
            if index ~= self._selected or self._selectedItem ~= self:GetItem(index) then
                self._selected = index
                self._selectedItem = self:GetItem(index)
                self:Refresh()
                self:Fire('OnSelectChanged', index, self._selectedItem)
            end
        end,
        GetSelected = function(self)
            return self._selected
        end,
        IsSelected = function(self, index)
            return self._selected == index
        end,
        SelectAll = nop,
        GetSelectedItem = function(self)
            return self._selected and self:GetItem(self._selected) or nil
        end,
        SetSelectedItem = function(self, item)
            for i = 1, self:GetItemCount() do
                if self:GetItem(i) == item then
                    return self:SetSelected(i)
                end
            end
            self:SetSelected(nil)
        end,
    },
    MULTI = {
        SetSelected = function(self, index)
            self._selected[index] = not self._selected[index] or nil
            self:Refresh()
        end,
        GetSelected = function(self)
            return self._selected
        end,
        IsSelected = function(self, index)
            return self._selected[index]
        end,
        SelectAll = function(self, flag)
            if flag then
                for i = 1, self:GetItemCount() do
                    self._selected[i] = true
                end
            else
                wipe(self._selected)
            end
            self:Refresh()
        end,
        GetSelectedItem = nop,
        SetSelectedItem = nop,
    },
}

function View:SetSelectMode(mode)
    mode = mode:upper()

    if not (mode == 'NONE' or mode == 'MULTI' or mode == 'RADIO') then
        error(([[Cannot set select mode to '%s']]):format(mode), 2)
    end
    self._selectMode = mode

    for k, v in pairs(SELECT_MODES[mode]) do
        self[k] = v
    end

    if mode == 'MULTI' then
        self._selected = {}
    else
        self._selected = nil
    end
end

function View:GetSelectMode()
    return self._selectMode or 'NONE'
end

local mixins = {
    'SetSelectMode',
    'GetSelectMode',
}

View.Embed = GUI:EmbedFactory(View, mixins)
