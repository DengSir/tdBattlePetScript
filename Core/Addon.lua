--[[
Addon.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ADDON, ns = ...
local Addon = LibStub('AceAddon-3.0'):NewAddon('tdBattlePetScript', 'AceEvent-3.0', 'LibClass-2.0')
local GUI   = LibStub('tdGUI-1.0')

ns.Addon = Addon
ns.UI    = {}
ns.L     = LibStub('AceLocale-3.0'):GetLocale('tdBattlePetScript', true)
ns.ICON  = [[Interface\Icons\INV_Misc_PenguinPet]]

_G.tdBattlePetScript = Addon

function Addon:OnInitialize()
    local defaults = {
        global = {
            scripts = {

            },
            notifies = {

            }
        },
        profile = {
            pluginDisabled = {},
            pluginOrders = {},
            settings = {
                autoSelect         = true,
                hideNoScript       = true,
                noWaitDeleteScript = false,
                editorFontFace     = STANDARD_TEXT_FONT,
                editorFontSize     = 14,
                autoButtonHotKey   = 'A',
                testBreak          = true,
                lockScriptSelector = false,
            },
            minimap = {
                minimapPos = 50,
            },
            position = {
                point = 'CENTER', x = 0, y = 0, width = 350, height = 450,
            },
            scriptSelectorPosition = {
                point = 'TOP', x = 0, y = -60,
            }
        }
    }

    self.db = LibStub('AceDB-3.0'):New('TD_DB_BATTLEPETSCRIPT_GLOBAL', defaults, true)

    self.db.RegisterCallback(self, 'OnDatabaseShutdown')
end

function Addon:OnEnable()
    self:RegisterMessage('PET_BATTLE_SCRIPT_SCRIPT_ADDED')
    self:RegisterMessage('PET_BATTLE_SCRIPT_SCRIPT_REMOVED')
    self:InitSettings()
    self:UpdateDatabase()
end

function Addon:InitSettings()
    for key, value in pairs(self.db.profile.settings) do
        self:SetSetting(key, value)
    end
end

function Addon:UpdateDatabase()
    local oldVersion = self.db.global.version or 0
    local newVersion = tonumber(GetAddOnMetadata(ADDON, 'Version')) or 99999.99

    if oldVersion ~= newVersion then
        self.db.global.version = newVersion

        C_Timer.After(0.9, function()
            GUI:Notify{
                text = format('%s\n|cff00ffff%s%s|r', ADDON, ns.L['Update to version: '], newVersion),
                icon = ns.ICON,
                help = ''
            }
        end)
    end
end

function Addon:OnModuleCreated(module)
    local name = module:GetName()
    if name:find('^UI%.') then
        ns.UI[name:match('^UI%.(.+)$')] = module
    else
        ns[name] = module
    end
end

function Addon:OnDatabaseShutdown()
    self:SendMessage('PET_BATTLE_SCRIPT_DB_SHUTDOWN')
end

function Addon:PET_BATTLE_SCRIPT_SCRIPT_ADDED(_, plugin, key, script)
    self.db.global.scripts[plugin:GetPluginName()][key] = script:GetDB()
end

function Addon:PET_BATTLE_SCRIPT_SCRIPT_REMOVED(_, plugin, key)
    self.db.global.scripts[plugin:GetPluginName()][key] = nil
end

function Addon:GetSetting(key)
    return self.db.profile.settings[key]
end

function Addon:SetSetting(key, value)
    self.db.profile.settings[key] = value
    self:SendMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED', key, value)
    self:SendMessage('PET_BATTLE_SCRIPT_SETTING_CHANGED_' .. key, value)
end

function Addon:ResetSetting(key)
    if type(self.db.profile[key]) == 'table' then
        wipe(self.db.profile[key])

        for k, v in pairs(self.db.defaults.profile[key]) do
            if type(v) == 'table' then
                self.db.profile[key][k] = CopyTable(v)
            else
                self.db.profile[key][k] = v
            end
        end
    else
        error('not support')
    end
end

function Addon:ResetFrames()
    self:ResetSetting('position')
    self:ResetSetting('scriptSelectorPosition')
    self:SendMessage('PET_BATTLE_SCRIPT_RESET_FRAMES')
end
