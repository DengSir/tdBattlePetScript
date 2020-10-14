-- Dropdown.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/20/2018, 6:11:06 PM

local MAJOR, MINOR = 'Dropdown', 2
local GUI = LibStub('tdGUI-1.0')
local Dropdown, oldminor = GUI:NewClass(MAJOR, MINOR, 'Button')
if not Dropdown then return end

function Dropdown:Constructor()
    local tl = self:CreateTexture(nil, 'BACKGROUND') do
        tl:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
        tl:SetTexCoord(0, 0.1953125, 0, 1)
        tl:SetSize(25, 64)
        tl:SetPoint('LEFT', -16, 0)
    end

    local tr = self:CreateTexture(nil, 'BACKGROUND') do
        tr:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
        tr:SetTexCoord(0.8046875, 1, 0, 1)
        tr:SetSize(25, 64)
        tr:SetPoint('RIGHT', 16, 0)
    end

    local tm = self:CreateTexture(nil, 'BACKGROUND') do
        tm:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
        tm:SetTexCoord(0.1953125, 0.8046875, 0, 1)
        tm:SetPoint('TOPLEFT', tl, 'TOPRIGHT')
        tm:SetPoint('BOTTOMRIGHT', tr, 'BOTTOMLEFT')
    end

    local MenuButton = CreateFrame('Button', nil, self) do
        Mixin(MenuButton, BackdropTemplateMixin)
        MenuButton:SetSize(24, 24)
        MenuButton:SetPoint('RIGHT', 0, 1)
        MenuButton:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
        MenuButton:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
        MenuButton:SetDisabledTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]])
        MenuButton:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], 'ADD')
        MenuButton:SetScript('OnClick', function()
            self:Click()
        end)
    end

    local Text = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmallLeft') do
        Text:SetPoint('LEFT', 10, 0)
        Text:SetPoint('RIGHT', MenuButton, 'LEFT')
        Text:SetWordWrap(false)
    end

    self:SetFontString(Text)
    self:SetDisabledFontObject('GameFontDisableSmallLeft')
    self:SetNormalFontObject('GameFontHighlightSmallLeft')

    self.MenuButton = MenuButton

    self:SetScript('OnEnable', self.OnEnable)
    self:SetScript('OnDisable', self.OnDisable)
    self:SetScript('OnClick', self.ToggleMenu)
end

function Dropdown:OnEnable()
    self.MenuButton:Enable()
end

function Dropdown:OnDisable()
    self.MenuButton:Disable()
end

function Dropdown:OnClick()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:ToggleMenu()
end

local function _GetItem(menuTable, value)
    if type(menuTable) == 'function' then
        local list = {}
        menuTable = menuTable(list) or list
    end
    for i, v in ipairs(menuTable) do
        if v.value == value then
            return v
        end
        if v.menuTable then
            local item = _GetItem(v.menuTable, value)
            if item then
                return item
            end
        end
    end
end

function Dropdown:SetValue(value)
    value = value or self.defaultValue

    if not value then
        self.value = nil
        self.item = nil
        self:SetText(self.defaultText)
    elseif self.menuTable then
        local item = _GetItem(self.menuTable, value)
        if item then
            self:SetItem(item)
        end
    end
end

function Dropdown:GetValue()
    return self.value or self.defaultValue
end

function Dropdown:SetMenuTable(menuTable)
    self.menuTable = menuTable
end

function Dropdown:GetMenuTable()
    return self.menuTable
end

function Dropdown:ToggleMenu()
    local menuTable = self:GetMenuTable()
    if type(menuTable) == 'function' then
        local list = {}
        menuTable = menuTable(list) or list
    end
    if not menuTable or #menuTable == 0 then
        return
    end

    if not self.DropMenu then
        local DropMenu = GUI:GetClass('DropMenu'):New(UIParent)
        Dropdown.DropMenu = DropMenu
    end
    self.DropMenu:Toggle(1, menuTable, self, self.maxItem, 'TOPLEFT', self, 'BOTTOMLEFT')
end

function Dropdown:SetItem(item)
    local noFire = self.value == item.value

    self.value = item.value
    self.item = item

    self:SetText(item.full or item.text)

    if self.DropMenu then
        self.DropMenu:Close()
    end

    if not noFire then
        self:Fire('OnSelectChanged', item)
    end
end

function Dropdown:GetItem()
    return self.item
end

function Dropdown:SetDefaultText(text)
    self.defaultText = text
    self:SetText(text)
end

function Dropdown:SetDefaultValue(value)
    self.defaultValue = value
end

function Dropdown:SetMaxItem(value)
    self.maxItem = value
end

function Dropdown:GetMaxItem()
    return self.maxItem
end
