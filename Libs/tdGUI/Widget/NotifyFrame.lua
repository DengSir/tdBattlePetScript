-- NotifyFrame.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/22/2018, 11:26:58 AM

local MAJOR, MINOR = 'NotifyFrame', 2
local GUI = LibStub('tdGUI-1.0')
local NotifyFrame, oldminor, ns = GUI:NewClass(MAJOR, MINOR, 'Button')
if not NotifyFrame then return end

NotifyFrame.opts = {}

local DEFAULT_ICON = [[Interface\Icons\INV_Misc_QuestionMark]]
local BACKGROP = {
    bgFile = [[Interface\BUTTONS\WHITE8X8]],
    edgeFile = [[Interface\BUTTONS\WHITE8X8]],
    tile = true,
    tileSize = 1,
    edgeSize = 1,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

function NotifyFrame:Constructor()
    self:Hide()
    self:SetSize(350, 50)
    self:SetFrameStrata('DIALOG')
    self:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    self:SetBackdrop(BACKGROP)
    self:SetBackdropBorderColor(0, 0, 0, 1)
    self:SetBackdropColor(0, 0, 0, 0.6)

    self:SetScript('OnClick', self.OnClick)
    self:SetScript('OnHide', self.OnHide)

    local Close = CreateFrame('Button', nil, self) do
        Close:SetBackdrop(BACKGROP)
        Close:SetBackdropBorderColor(0, 0, 0, 1)
        Close:SetBackdropColor(0, 0, 0, 0.4)
        Close:SetPoint('TOPRIGHT', 0, 0)
        Close:SetSize(16, 16)
        Close:SetScript('OnClick', function()
            self:OnClick('RightButton')
        end)

        local padding = 4

        local Line1 = Close:CreateLine(nil, 'ARTWORK') do
            Line1:SetThickness(1)
            Line1:SetStartPoint('TOPLEFT', padding, -padding)
            Line1:SetEndPoint('BOTTOMRIGHT', -padding, padding)
            Line1:SetColorTexture(0.5, 0.5, 0.5)
        end

        local Line2 = Close:CreateLine(nil, 'ARTWORK') do
            Line2:SetThickness(1)
            Line2:SetStartPoint('TOPRIGHT', -padding, -padding)
            Line2:SetEndPoint('BOTTOMLEFT', padding, padding)
            Line2:SetColorTexture(0.5, 0.5, 0.5)
        end
    end

    local Icon = self:CreateTexture(nil, 'ARTWORK') do
        Icon:SetPoint('LEFT', 4, 0)
        Icon:SetSize(42, 42)
        Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    end

    local Text = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightLeft') do
        Text:SetPoint('TOPRIGHT', -25, -5)
        Text:SetPoint('LEFT', Icon, 'RIGHT', 5, 0)
    end

    local HelpText = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLeft') do
        HelpText:SetWordWrap(false)
        HelpText:SetPoint('BOTTOM', 0, 4)
        HelpText:SetPoint('LEFT', Icon, 'RIGHT', 5, 0)
        HelpText:SetFont(HelpText:GetFont(), 11)
        HelpText:SetTextColor(0.8, 0.8, 0.3)
    end

    local Anim = self:CreateAnimationGroup() do
        Anim:SetToFinalAlpha(true)
        Anim:SetScript('OnFinished', function()
            if self:GetAlpha() == 0 then
                self:Hide()
            end
        end)
    end

    local Alpha = Anim:CreateAnimation('Alpha') do
        Alpha:SetDuration(0.5)
    end

    local IgnoreButton = CreateFrame('Button', nil, self) do
        IgnoreButton:SetBackdrop(BACKGROP)
        IgnoreButton:SetBackdropBorderColor(0, 0, 0, 1)
        IgnoreButton:SetBackdropColor(0, 0, 0, 0.4)
        IgnoreButton:SetSize(80, 16)
        IgnoreButton:SetPoint('BOTTOMRIGHT')
        IgnoreButton:SetScript('OnClick', function()
            self:OnIgnoreClick()
        end)

        local Text = IgnoreButton:CreateFontString(nil, 'OVERLAY', 'GameFontNormalGraySmall') do
            Text:SetFont(Text:GetFont(), 11)
            Text:SetPoint('CENTER')
            IgnoreButton:SetFontString(Text)
            IgnoreButton:SetHighlightFontObject('GameFontHighlightSmall')
            IgnoreButton:SetNormalFontObject('GameFontNormalGraySmall')
        end
    end

    self.Anim         = Anim
    self.Alpha        = Alpha
    self.Text         = Text
    self.Icon         = Icon
    self.HelpText     = HelpText
    self.IgnoreButton = IgnoreButton
end

function NotifyFrame:SetText(text)
    self.Text:SetText(text)
    self:SetHeight(max(50, self.Text:GetStringHeight() + self.HelpText:GetStringHeight() + 12))
end

function NotifyFrame:FadeIn()
    self:Show()
    self.Anim:Stop()
    self.Alpha:SetFromAlpha(0)
    self.Alpha:SetToAlpha(1)
    self.Anim:Play()
end

function NotifyFrame:FadeOut()
    self.Anim:Stop()
    self.Alpha:SetFromAlpha(1)
    self.Alpha:SetToAlpha(0)
    self.Anim:Play()
end

function NotifyFrame:OnClick(click)
    if self.Anim:IsPlaying() then
        return
    end

    self:CallOptions(click == 'LeftButton' and 'OnAccept' or 'OnCancel')
    self:FadeOut()
end

function NotifyFrame:OnIgnoreClick()
    if self.Anim:IsPlaying() then
        return
    end
    self:CallOptions('OnIgnore')
    self:FadeOut()
end

function NotifyFrame:OnHide()
    self.opts = nil
    self:Fire('OnHide')
end

function NotifyFrame:SetOptions(opts)
    self.opts = opts
    self.Icon:SetTexture(opts.icon or DEFAULT_ICON)
    self.IgnoreButton:SetText(opts.ignore or '')
    self.IgnoreButton:SetShown(opts.ignore)
    self.IgnoreButton:SetWidth(self.IgnoreButton:GetTextWidth() + 10)
    self.HelpText:SetText(opts.help or 'Right click to close')
    self:SetText(opts.text)
end

function NotifyFrame:GetOptions()
    return self.opts
end

function NotifyFrame:CallOptions(method)
    if type(self.opts[method]) == 'function' then
        self.opts[method](self.opts)
    end
end

-- public

local MAX_NOTIFIES = 4

ns.used = ns.used or {}
ns.unused = ns.unused or {}
ns.queue = ns.queue or {}

local NotifyManager = {}
local TYPES = {ONCE = true, DAY = true}

function NotifyManager:CheckOptions(opts)
    if opts.ignore and self:GetStorage(opts, 'ignore') then
        return
    end

    if opts.type then
        local last = self:GetStorage(opts, 'last')
        if last then
            if opts.type == 'ONCE' then
                return
            end
            if opts.type == 'DAY' and last == date('%Y/%m/%d') then
                return
            end
        end
    end
    return true
end

function NotifyManager:SaveStorage(opts, key, value)
    opts.storage[opts.id] = opts.storage[opts.id] or {}
    opts.storage[opts.id][key] = value
end

function NotifyManager:GetStorage(opts, key)
    return opts.storage[opts.id] and opts.storage[opts.id][key]
end

function NotifyManager:Pop()
    while self:Update() do
    end
    self:UpdatePosition()
end

function NotifyManager:UpdatePosition()
    for i, frame in ipairs(ns.used) do
        if i == 1 then
            frame:SetPoint('BOTTOMRIGHT', -25, 90)
        else
            frame:SetPoint('BOTTOMRIGHT', ns.used[i-1], 'TOPRIGHT', 0, 2)
        end
    end
end

function NotifyManager:Update()
    if #ns.used >= MAX_NOTIFIES then
        return
    end

    local opts = table.remove(ns.queue, 1)
    if not opts then
        return
    end

    if not self:CheckOptions(opts) then
        return true
    end

    local notify = table.remove(ns.unused, 1) or NotifyFrame:New(UIParent)
    notify:SetPoint('BOTTOMRIGHT', -25, 90)
    notify:SetCallback('OnHide', function(notify)
        tDeleteItem(ns.used, notify)
        table.insert(ns.unused, notify)
        self:Pop()
    end)
    notify:SetOptions(opts)
    notify:FadeIn()

    table.insert(ns.used, notify)

    if opts.type then
        self:SaveStorage(opts, 'last', date('%Y/%m/%d'))
    end
end

function GUI:Notify(opts)
    if type(opts) ~= 'table' then
        error(format([[bad argument #1 to 'Notify' (table expected, got %s]], type(opts)), 2)
    end
    if type(opts.text) ~= 'string' then
        error(format([[bad argument opts.text to 'Notify' (string expected, got %s)]], type(opts.text)), 2)
    end
    if opts.type or opts.ignore then
        if opts.type and not TYPES[opts.type] then
            error(format([[bad argument opts.type to 'Notify' (ONCE|DAY)]]), 2)
        end
        if type(opts.storage) ~= 'table' then
            error(format([[bad argument opts.storage to 'Notify' (string expected, got %s)]], type(opts.storage)), 2)
        end
        if not opts.id then
            error(format([[bad argument opts.storage to 'Notify']]), 2)
        end
    end

    if opts.ignore then
        opts.OnIgnore = function(opts)
            NotifyManager:SaveStorage(opts, 'ignore', true)
        end
    end

    table.insert(ns.queue, opts)
    NotifyManager:Pop()
end

function GUI:NotifyOnce(opts)
    opts.type = 'ONCE'
    return self:Notify(opts)
end

function GUI:NotifyDay(opts)
    opts.type = 'DAY'
    return self:Notify(opts)
end
