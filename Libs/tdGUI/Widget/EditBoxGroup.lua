--[[
EditBoxGroup.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'EditBoxGroup', 1
local EditBoxGroup = LibStub('tdGUI-1.0'):NewClass(MAJOR, MINOR)
if not EditBoxGroup then return end

function EditBoxGroup:Constructor()
    self._objectOrders = {}
    self._objectIndexs = {}

    self._OnTabPressed = function(object)
        if IsShiftKeyDown() then
            self:GetPrevObject(object):SetFocus()
        else
            self:GetNextObject(object):SetFocus()
        end
    end
end

function EditBoxGroup:RegisterEditBox(object)
    tinsert(self._objectOrders, object)

    self._objectIndexs[object] = #self._objectOrders

    object:SetScript('OnTabPressed', self._OnTabPressed)
end

function EditBoxGroup:GetNextObject(object)
    local index = self._objectIndexs[object]
    if index then
        local count = #self._objectOrders
        local i = index
        local next
        repeat
            i = i % count + 1
            next = self._objectOrders[i]

            if next:IsVisible() and next:IsEnabled() then
                return next
            end
        until i == index
    end
    return object
end

function EditBoxGroup:GetPrevObject(object)
    local index = self._objectIndexs[object]
    if index then
        local count = #self._objectOrders
        local i = index
        local prev
        repeat
            i = i == 1 and count or i - 1
            prev = self._objectOrders[i]

            if prev:IsVisible() and prev:IsEnabled() then
                return prev
            end
        until i == index
    end
end

function EditBoxGroup:ClearFocus()
    for _, object in ipairs(self._objectOrders) do
        object:ClearFocus()
    end
end
