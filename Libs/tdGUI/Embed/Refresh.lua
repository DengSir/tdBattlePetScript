--[[
Refresh.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'Refresh', 1
local GUI = LibStub('tdGUI-1.0')
local View, oldminor = GUI:NewEmbed(MAJOR, MINOR)
if not View then return end

local function Refresh(self)
    self:Update()
    self:SetScript('OnUpdate', nil)

    if type(self.Fire) == 'function' then
        self:Fire('OnRefresh')
    end
end

function View:Refresh()
    if self.__nonRefreshOnShow and not self:IsVisible() then
        return
    end

    if type(self.Update) == 'function' then
        self:SetScript('OnUpdate', Refresh)
    end
end

function View:SetRefreshOnShow(flag)
    self.__nonRefreshOnShow = not flag or nil
    self:SetScript('OnUpdate', nil)
end

function View:IsRefreshOnShow()
    return not self.__nonRefreshOnShow
end

local mixins = {
    'Refresh',
    'SetRefreshOnShow',
    'IsRefreshOnShow',
}

View.Embed = GUI:EmbedFactory(View, mixins)
