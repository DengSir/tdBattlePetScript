-- PluginManager.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/23/2018, 11:16:26 PM

local ns              = select(2, ...)
local Addon           = ns.Addon
local ScriptManager   = ns.ScriptManager
local PluginPrototype = {}
local L               = ns.L
local GUI             = LibStub('tdGUI-1.0')

ns.PluginPrototype = PluginPrototype

local PluginManager = Addon:NewModule('PluginManager', 'AceEvent-3.0')

function PluginManager:OnInitialize()
    self.moduleWatings = {}
    self.moduleEnableQueue = {}
    self.pluginsOrdered = {}
    self.pluginsNotInstalled = {}
    self.db = Addon.db
end

function PluginManager:OnEnable()
    self:InitPlugins()
    self:InitOrders()
    self:UpdatePlugins()
    self:RebuildPluginOrders()
    self:InitPluginsNotInstalled()

    C_Timer.After(0, function()
        self:LoadPlugins()
    end)
end

function PluginManager:GetPluginList()
    return self.pluginsOrdered
end

function PluginManager:IteratePlugins()
    return ipairs(self.pluginsOrdered)
end

function PluginManager:IterateEnabledPlugins()
    return coroutine.wrap(function()
        for _, plugin in ipairs(self.pluginsOrdered) do
            if plugin:IsEnabled() then
                coroutine.yield(plugin:GetPluginName(), plugin)
            end
        end
    end)
end

function PluginManager:InitPlugins()
    for name, plugin in self:IterateModules() do
        self.db.global.scripts[name] = self.db.global.scripts[name] or {}

        for key, db in pairs(self.db.global.scripts[name]) do
            ScriptManager:AddScript(plugin, key, Addon:GetClass('Script'):New(db, plugin, key))
        end
    end
end

function PluginManager:InitOrders()
    local default         = {'Rematch', 'Base', 'FirstEnemy', 'AllInOne'}
    local pluginOrdersMap = tInvert(self.db.profile.pluginOrders)
    local pluginOrders    = {} do
        for k in pairs(pluginOrdersMap) do
            tinsert(pluginOrders, k)
        end
        sort(pluginOrders, function(lhs, rhs)
            return pluginOrdersMap[lhs] < pluginOrdersMap[rhs]
        end)
    end

    for i, v in pairs(default) do
        if not pluginOrdersMap[v] and self:GetModule(v) then
            tinsert(pluginOrders, i, v)
        end
    end

    self.db.profile.pluginOrders = pluginOrders
end

function PluginManager:UpdatePlugins()
    local base = Addon:GetPlugin('Base')
    local firstEnemy = Addon:GetPlugin('FirstEnemy')
    if not base or not firstEnemy then
        return
    end

    local found = false
    for key, script in base:IterateScripts() do
        if type(key) == 'number' then
            found = true

            base:RemoveScript(key)
            firstEnemy:AddScript(key, script)
        end
    end

    if found then
        C_Timer.After(1, function()
            GUI:Notify{
                text = L.PLUGINFIRSTENEMY_NOTIFY,
                icon = ns.ICON,
                OnAccept = function()
                    Addon:OpenOptionFrame('plugins')
                end
            }
        end)
    end
end

function PluginManager:InitPluginsNotInstalled()
    local thirdPlugins = {
        {
            addon = 'Rematch',
            plugin = 'tdBattlePetScript_Rematch',
            url = 'https://www.curseforge.com/wow/addons/tdbattlepetscript-rematch'
        }
    }

    local addons = {} do
        for i = 1, GetNumAddOns() do
            addons[GetAddOnInfo(i)] = true
        end
    end

    for _, v in ipairs(thirdPlugins) do
        if addons[v.pluginName or v.addon] and not addons[v.plugin] then
            table.insert(self.pluginsNotInstalled, v)
        end
    end
end

function PluginManager:GetNotInstalledPlugins()
    return self.pluginsNotInstalled
end

function PluginManager:RebuildPluginOrders()
    wipe(self.pluginsOrdered)

    for _, name in ipairs(self.db.profile.pluginOrders) do
        local plugin = self:GetModule(name, true)
        if plugin then
            tinsert(self.pluginsOrdered, plugin)
        end
    end
end

function PluginManager:LoadPlugins()
    while true do
        local module = table.remove(self.moduleEnableQueue, 1)
        if not module then
            break
        end

        if self:IsPluginAllowed(module:GetPluginName()) then
            module:Enable()
        end
    end
end

function PluginManager:ADDON_LOADED(_, addon)
    repeat
        local modules = self.moduleWatings[addon]
        if modules then
            self.moduleWatings[addon] = nil

            for _, module in ipairs(modules) do
                if self:IsPluginAllowed(module:GetPluginName()) then
                    module:Enable()
                end
            end
        end
    until not self.moduleWatings[addon]

    if not next(self.moduleWatings) then
        self:UnregisterEvent('ADDON_LOADED')
    end
end

function PluginManager:MoveUpPlugin(name)
    local pluginOrders = self.db.profile.pluginOrders
    local index = tIndexOf(pluginOrders, name)
    if not index or index == 1 then
        return
    end

    tDeleteItem(pluginOrders, name)
    tinsert(pluginOrders, index - 1, name)

    self:RebuildPluginOrders()
end

function PluginManager:MoveDownPlugin(name)
    local pluginOrders = self.db.profile.pluginOrders
    local index = tIndexOf(pluginOrders, name)
    if not index or index == #pluginOrders then
        return
    end

    tDeleteItem(pluginOrders, name)
    tinsert(pluginOrders, index + 1, name)

    self:RebuildPluginOrders()
end

function PluginManager:EnableModuleWithAddonLoaded(module, addon)
    module:Disable()

    if not IsAddOnLoaded(addon) then
        self.moduleWatings[addon] = self.moduleWatings[addon] or {}
        tinsert(self.moduleWatings[addon], module)

        self:RegisterEvent('ADDON_LOADED')
    else
        tinsert(self.moduleEnableQueue, module)
    end
end

function PluginManager:IsPluginAllowed(name)
    return not self.db.profile.pluginDisabled[name]
end

function PluginManager:SetPluginAllowed(name, flag)
    self.db.profile.pluginDisabled[name] = not flag or nil

    C_Timer.After(0, function()
        local module = Addon:GetPlugin(name)
        if flag then
            module:Enable()
        else
            module:Disable()
        end
    end)
end

---- Addon

function Addon:NewPlugin(name, ...)
    return PluginManager:NewModule(name, PluginPrototype, ...)
end

function Addon:GetPlugin(name)
    return PluginManager:GetModule(name, true)
end

function Addon:IteratePlugins()
    return PluginManager:IteratePlugins()
end

function Addon:IterateEnabledPlugins()
    return PluginManager:IterateEnabledPlugins()
end
