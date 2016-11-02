--[[
Addon.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = LibStub('AceAddon-3.0'):NewAddon('tdBattlePetScript', 'AceEvent-3.0', 'LibClass-2.0')

ns.Addon = Addon
ns.UI    = {}
ns.L     = LibStub('AceLocale-3.0'):GetLocale('tdBattlePetScript', true)

_G.tdBattlePetScript = Addon

function Addon:OnInitialize()
    local defaults = {
        global = {
            scripts = {

            }
        },
        profile = {
            pluginDisabled = {

            },
            settings = {
                selectOnlyOneScript = true,
                hideNoScript        = false,
                noWaitDeleteScript  = false,
                editorFontFace      = STANDARD_TEXT_FONT,
                editorFontSize      = 14,
                autoButtonHotKey    = 'A',
            },
            minimap = {
                minimapPos = 50,
            },
            position = {
                point = 'CENTER', x = 0, y = 0, width = 350, height = 450,
            }
        }
    }
    self.db = LibStub('AceDB-3.0'):New('TD_DB_BATTLEPETSCRIPT_GLOBAL', defaults, true)

    self.db.RegisterCallback(self, 'OnDatabaseShutdown')

    self.battleCache = _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE or {}
    _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE = nil
end

function Addon:OnEnable()
    self:InitPluginScriptDB()

    C_Timer.After(0, function()
        for _, module in ipairs(self.moduleEnableQueue) do
            if not module.GetPluginName or self:IsPluginAllowed(module:GetPluginName()) then
                module:Enable()
            end
        end
        self:LoadOptionFrame()
    end)
end

function Addon:OnModuleCreated(module)
    local name = module:GetName()
    if name:find('^UI%.') then
        ns.UI[name:match('^UI%.(.+)$')] = module
    else
        ns[module:GetName()] = module
    end
end

function Addon:OnDatabaseShutdown()
    for name, plugin in self:IteratePlugins() do
        local db = wipe(self.db.global.scripts[name])
        for key, script in plugin:IterateScripts() do
            db[key] = script:GetDB()
        end
    end
    self:SendMessage('PET_BATTLE_SCRIPT_DB_SHUTDOWN')

    if C_PetBattles.IsInBattle() then
        self:SendMessage('PET_BATTLE_INBATTLE_SHUTDOWN')
        _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE = self.battleCache
    else
        _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE = nil
    end
end

_G.SD = function()
    Addon:SendMessage('PET_BATTLE_INBATTLE_SHUTDOWN')

    dump(Addon.battleCache)
end

Addon.moduleWatings     = {}
Addon.moduleEnableQueue = {}

function Addon:EnableModuleWithAddonLoaded(name, addon)
    local module = self:GetModule(name)
    if not module then
        return
    end

    module:Disable()

    if not IsAddOnLoaded(addon) then
        self.moduleWatings[addon] = self.moduleWatings[addon] or {}
        tinsert(self.moduleWatings[addon], module)

        self:RegisterEvent('ADDON_LOADED')
    else
        tinsert(self.moduleEnableQueue, module)
    end
end

function Addon:ADDON_LOADED(_, addon)
    repeat
        local modules = self.moduleWatings[addon]
        if modules then
            self.moduleWatings[addon] = nil

            for _, module in ipairs(modules) do
                if not module.GetPluginName or self:IsPluginAllowed(module:GetPluginName()) then
                    module:Enable()
                end
            end
        end
    until not self.moduleWatings[addon]

    if not next(self.moduleWatings) then
        self:UnregisterEvent('ADDON_LOADED')
    end
end

function Addon:IsPluginAllowed(name)
    return not self.db.profile.pluginDisabled[name]
end

function Addon:SetPluginAllowed(name, flag)
    self.db.profile.pluginDisabled[name] = not flag or nil

    C_Timer.After(0, function()
        local module = self:GetPlugin(name)
        if flag then
            module:Enable()
        else
            module:Disable()
        end
    end)
end

function Addon:GetSetting(key)
    return self.db.profile.settings[key]
end

function Addon:SetSetting(key, value)
    self.db.profile.settings[key] = value
    self:SendMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED', key, value)
    self:SendMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED_' .. key, value)
end

function Addon:GetBattleCache(key)
    return self.battleCache[key]
end

function Addon:SetBattleCache(key, value)
    self.battleCache[key] = value
end
