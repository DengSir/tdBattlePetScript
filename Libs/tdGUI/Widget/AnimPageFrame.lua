-- AnimPageFrame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/20/2018, 11:09:58 PM

local MAJOR, MINOR = 'AnimPageFrame', 2
local GUI = LibStub('tdGUI-1.0')
local AnimPageFrame, oldminor = GUI:NewClass(MAJOR, MINOR, 'ScrollFrame', 'Refresh')
if not AnimPageFrame then return end

function AnimPageFrame:Constructor()
    local Body = CreateFrame('Frame', nil, self) do
        Body:SetPoint('TOPLEFT')
        Body:SetSize(1, 1)
        self:SetScrollChild(Body)
    end

    local Group = self:CreateAnimationGroup() do
        Group:SetLooping('NONE')
        Group:SetScript('OnFinished', function()
            self:OnFinished()
        end)
    end

    local Anim = Group:CreateAnimation('Translation') do
        Anim:SetDuration(0.3)
    end

    self.Body = Body
    self.Group = Group
    self.Anim = Anim


    self._pageIndex = 1
    self._pages = {}
    self:SetScript('OnSizeChanged', self.Refresh)
    self:SetOrientation('HORIZONTAL')
    self:Refresh()
end

function AnimPageFrame:UpdateHorizontal()
    local width, height = self:GetSize()

    self.Body:SetHeight(height)
    self.Body:SetWidth(width * self:GetPageCount())

    for i, frame in ipairs(self._pages) do
        frame:ClearAllPoints()
        frame:SetPoint('TOPLEFT', (i - 1) * width, 0)
        frame:SetSize(width, height)
    end
end

function AnimPageFrame:UpdateVertical()
    local width, height = self:GetSize()

    self.Body:SetHeight(height * self:GetPageCount())
    self.Body:SetWidth(width)

    for i, frame in ipairs(self._pages) do
        frame:ClearAllPoints()
        frame:SetPoint('TOPLEFT', 0, - (i - 1) * height)
        frame:SetSize(width, height)
    end
end

function AnimPageFrame:GetPageCount()
    return #self._pages
end

function AnimPageFrame:AddPage(frame)
    local id = self:GetPageCount() + 1
    frame:SetParent(self.Body)
    frame:SetID(id)
    frame:ClearAllPoints()

    self._pages[id] = frame
    self:Refresh()
end

function AnimPageFrame:GetOrientation()
    return self._orientation
end

function AnimPageFrame:SetOrientation(orientation)
    self._orientation = orientation
    self.Update = orientation == 'HORIZONTAL' and self.UpdateHorizontal or self.UpdateVertical
    self:Refresh()
end

function AnimPageFrame:GetPage()
    return self._pageIndex
end

function AnimPageFrame:SetPage(id, force)
    if self._pageIndex == id then
        return
    end

    if self.Anim:IsPlaying() then
        self.Anim:Stop()
        self.Group:Stop()
    end

    local delta = self._pageIndex - id
    self._pageIndex = id

    if force then
        self:OnFinished()
    else
        if self._orientation == 'HORIZONTAL' then
            self.Anim:SetOffset(delta * self:GetWidth(), 0)
        else
            self.Anim:SetOffset(0, - delta * self:GetHeight())
        end
        self.Group:Play()
        self.Anim:Play()
    end
end

function AnimPageFrame:OnFinished()
    if self._orientation == 'HORIZONTAL' then
        self:SetHorizontalScroll((self._pageIndex - 1) * self:GetWidth())
    else
        self:SetVerticalScroll((self._pageIndex - 1) * self:GetHeight())
    end
end
