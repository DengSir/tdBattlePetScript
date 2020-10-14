-- NumericBox.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 10/15/2018, 10:46:28 PM

local MAJOR, MINOR = 'NumericBox', 2
local GUI = LibStub('tdGUI-1.0')
local NumericBox = GUI:NewClass(MAJOR, MINOR, GUI:GetClass('InputBox'))
if not NumericBox then return end

function NumericBox:Constructor()
    self:SetNumeric(true)
    self:SetMinMaxValues(0, 99)
    self:SetValueStep(1)

    self:SetScript('OnTextChanged', self.OnTextChanged)
    self:SetScript('OnMouseWheel', self.OnMouseWheel)
    self:SetScript('OnEditFocusLost', self.OnTextChanged)
end

function NumericBox:SetNumber(num)
    if num < self._minValue then
        num = self._minValue
    elseif num > self._maxValue then
        num = self._maxValue
    end
    self:SuperCall('SetNumber', num)
end

function NumericBox:GetMinMaxValues()
    return self._minValue, self._maxValue
end

function NumericBox:SetMinMaxValues(minValue, maxValue)
    if type(minValue) ~= 'number' then
        error(([[bad argument #1 to 'SetMinMaxValues' (number expected, got %s)]]):format(type(minValue)), 2)
    end
    if type(maxValue) ~= 'number' then
        error(([[bad argument #2 to 'SetMinMaxValues' (number expected, got %s)]]):format(type(maxValue)), 2)
    end
    if minValue < 0 then
        error('err min value', 2)
    end
    if minValue > maxValue then
        error('err max value', 2)
    end

    self._minValue = floor(minValue)
    self._maxValue = floor(maxValue)

    self:SetMaxBytes(#(tostring(self._maxValue)) + 1)
    self:OnTextChanged()
    self:OnEnableChanged()

    self:Fire('OnMinMaxChanged', minValue, maxValue)
end

function NumericBox:SetValueStep(step)
    self._step = step
end

function NumericBox:GetValueStep()
    return self._step
end

function NumericBox:OnTextChanged(userInput)
    if not userInput or #self:GetText() == self:GetMaxBytes() - 1 then
        local value = self:GetNumber()
        if value < self._minValue then
            return self:SetNumber(self._minValue)
        elseif value > self._maxValue then
            return self:SetNumber(self._maxValue)
        end
    end
    self:OnEnableChanged()

    local value = self:GetNumber()
    if value ~= self._prev then
        self._prev = value
        self:Fire('OnValueChanged', value)
    end
end

function NumericBox:OnMouseWheel(delta)
    if not self:IsEnabled() then
        return
    end
    if IsShiftKeyDown() then
        self:SetNumber(self:GetNumber() + delta * self._step * 3)
    elseif IsControlKeyDown() then
        self:SetNumber(delta > 0 and self._maxValue or self._minValue)
    else
        self:SetNumber(self:GetNumber() + delta * self._step)
    end
end

function NumericBox:OnEnableChanged()
    if not self.PlusButton then
        return
    end
    local isEnabled = self:IsEnabled()
    local value = self:GetNumber()

    self.PlusButton:SetEnabled(isEnabled and value < self._maxValue)
    self.MinusButton:SetEnabled(isEnabled and value > self._minValue)
end

local function ButtonOnClick(self)
    self:GetParent():OnMouseWheel(self.delta)
end

local function LayoutTexture(button, texture, x, y, ...)
    button:SetNormalTexture(texture)
    button:SetDisabledTexture(texture)
    button:SetPushedTexture(texture)
    button:SetHighlightTexture(texture, 'ADD')

    local texture = button:GetNormalTexture()
    texture:ClearAllPoints()
    texture:SetPoint('CENTER', x, y)
    texture:SetSize(12, 8)
    texture:SetTexCoord(...)

    local texture = button:GetDisabledTexture()
    texture:ClearAllPoints()
    texture:SetPoint('CENTER', x, y)
    texture:SetSize(12, 8)
    texture:SetTexCoord(...)
    texture:SetDesaturated(true)
    texture:SetAlpha(0.5)

    local texture = button:GetPushedTexture()
    texture:ClearAllPoints()
    texture:SetPoint('CENTER', x + 1, y -1)
    texture:SetSize(12, 8)
    texture:SetTexCoord(...)

    local texture = button:GetHighlightTexture()
    texture:ClearAllPoints()
    texture:SetPoint('CENTER', x, y)
    texture:SetSize(12, 8)
    texture:SetTexCoord(...)
end

function NumericBox:SetButtonsEnabled(state)
    if state then
        if not self.PlusButton then
            local PlusButton = CreateFrame('Button', nil, self) do
                PlusButton:SetWidth(12)
                PlusButton:SetPoint('BOTTOMRIGHT', self, 'RIGHT', -3, 0)
                PlusButton:SetPoint('TOPRIGHT', -3, 0)
                PlusButton:SetScript('OnClick', ButtonOnClick)
                PlusButton.delta = 1
                LayoutTexture(PlusButton, [[Interface\BUTTONS\Arrow-Up-Down]], 0, -1, 0, 1, 0.5, 0.9)
            end

            local MinusButton = CreateFrame('Button', nil, self) do
                MinusButton:SetWidth(12)
                MinusButton:SetPoint('TOPRIGHT', self, 'RIGHT', -3, 0)
                MinusButton:SetPoint('BOTTOMRIGHT', -3, 0)
                MinusButton:SetScript('OnClick', ButtonOnClick)
                MinusButton.delta = -1
                LayoutTexture(MinusButton, [[Interface\BUTTONS\Arrow-Down-Down]], 0, 1, 0, 1, 0.1, 0.5)
            end

            self.PlusButton = PlusButton
            self.MinusButton = MinusButton
        end
        self.PlusButton:Show()
        self.MinusButton:Show()
        self:SetTextInsets(3, 15, 0, 0)
    else
        if self.PlusButton then
            self.PlusButton:Hide()
            self.MinusButton:Hide()
        end
        self:SetTextInsets(3, 3, 0, 0)
    end
end

function NumericBox:IsButtonsEnabled()
    return self.PlusButton or self.PlusButton:IsShown()
end
