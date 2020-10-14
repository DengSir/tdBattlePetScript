--[[
BasicPanel.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'BasicPanel', 3
local GUI = LibStub('tdGUI-1.0')
local BasicPanel, oldminor = GUI:NewClass(MAJOR, MINOR, 'Frame.BasicFrameTemplate')
if not BasicPanel then return end

if BasicPanel.lw11origSetScale then
    BasicPanel.SetScale = BasicPanel.lw11origSetScale
end

LibStub('LibWindow-1.1'):Embed(BasicPanel)

BasicPanel.MakeDraggable = nil

function BasicPanel:Constructor()
    self:SetClampedToScreen(true)
    self:EnableMouse(true)
    self:SetToplevel(true)
    self:SetScript('OnShow', self.OnShow)
    self:SetScript('OnHide', self.OnHide)

    local Drag = CreateFrame('Frame', nil, self) do
        Drag:Hide()
        Drag:SetPoint('TOPLEFT', 20, 0)
        Drag:SetPoint('TOPRIGHT', -20, 0)
        Drag:SetHeight(22)
        Drag:EnableMouse(true)
        Drag:RegisterForDrag('LeftButton')
        Drag:SetScript('OnDragStart', function()
            self:StartMoving()
        end)
        Drag:SetScript('OnDragStop', function()
            self:StopMovingOrSizing()
            self:SavePosition()
        end)
    end

    local Resize = CreateFrame('Button', nil, self) do
        Resize:Hide()
        Resize:SetSize(16, 16)
        Resize:SetPoint('BOTTOMRIGHT')
        Resize:SetFrameLevel(self:GetFrameLevel() + 10)
        Resize:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]])
        Resize:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]])
        Resize:SetHighlightTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]])
        Resize:SetScript('OnMouseDown', function()
            self:StartSizing('BOTTOMRIGHT')
        end)
        Resize:SetScript('OnMouseUp', function()
            self:StopMovingOrSizing()
            self:SaveSize()
            self:SavePosition()
        end)
    end

    local Portrait = CreateFrame('Frame', nil, self) do
        Portrait:Hide()
        Portrait:SetSize(61, 61)
        Portrait:SetPoint('TOPLEFT', -6, 8)
        Portrait:SetFrameLevel(self:GetFrameLevel() + 100)

        local Border = Portrait:CreateTexture(nil, 'OVERLAY', 'UI-Frame-Portrait') do
            Border:ClearAllPoints()
            Border:SetPoint('TOPLEFT', self, 'TOPLEFT', -14, 11)
            Border:SetSize(78, 78)
        end

        local Icon = Portrait:CreateTexture(nil, 'OVERLAY', nil, -1) do
            Icon:SetMask([[Textures\MinimapMask]])
            Icon:SetAllPoints(Portrait)
        end
        Portrait.Icon   = Icon
        Portrait.Border = Border
    end

    self.Drag     = Drag
    self.Resize   = Resize
    self.Portrait = Portrait
end

function BasicPanel:SetMovable(flag)
    self:SuperCall('SetMovable', flag)
    self.Drag:SetShown(flag)
end

function BasicPanel:SetResizable(flag)
    self:SuperCall('SetResizable', flag)
    self.Resize:SetShown(flag)
end

function BasicPanel:SetText(text)
    self.TitleText:SetText(text)
end

function BasicPanel:GetText()
    return self.TitleText:GetText()
end

function BasicPanel:OnShow()
    PlaySound(SOUNDKIT and SOUNDKIT.IG_CHARACTER_INFO_TAB or 'igCharacterInfoTab')
    self:Fire('OnShow')
end

function BasicPanel:OnHide()
    PlaySound(SOUNDKIT and SOUNDKIT.IG_CHARACTER_INFO_CLOSE or 'igMainMenuClose')
    self:Fire('OnHide')
end

function BasicPanel:ShowPortrait()
    self.Portrait:Show()
    self.TopLeftCorner:Hide()
	self.TopBorder:SetPoint('TOPLEFT', self.Portrait.Border, 'TOPRIGHT',  0, -10)
	self.LeftBorder:SetPoint('TOPLEFT', self.Portrait.Border, 'BOTTOMLEFT',  8, 0)
    self.Drag:SetPoint('TOPLEFT', 80, 0)
end

function BasicPanel:HidePortrait()
    self.Portrait:Hide()
    self.TopLeftCorner:Show()
	self.TopBorder:SetPoint('TOPLEFT', self.TopLeftCorner, 'TOPRIGHT',  0, 0)
	self.LeftBorder:SetPoint('TOPLEFT', self.TopLeftCorner, 'BOTTOMLEFT',  0, 0)
    self.Drag:SetPoint('TOPLEFT', 20, 0)
end

function BasicPanel:SetPortrait(texture)
    self.Portrait.Icon:SetTexture(texture)
end

local orig_RegisterConfig = BasicPanel.RegisterConfig
function BasicPanel:RegisterConfig(storage)
    orig_RegisterConfig(self, storage)
    self._storage = storage
end

function BasicPanel:RestoreSize()
    self:SetSize(self._storage.width, self._storage.height)
end

function BasicPanel:SaveSize()
    self._storage.width, self._storage.height = self:GetSize()
end
