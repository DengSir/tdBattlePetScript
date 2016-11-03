--[[
Option.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns       = select(2, ...)
local Addon    = ns.Addon
local L        = ns.L

local AceConfigRegistry = LibStub('AceConfigRegistry-3.0')
local AceConfigDialog   = LibStub('AceConfigDialog-3.0')

local plugins_args = {}

function Addon:LoadOptionFrame()
    self:RefillPluginOptions()

    local order = self:CreateOrderFactory()

    local TestFont = UIParent:CreateFontString(nil, 'BACKGROUND')
    TestFont:Hide()

    local checks = {
        editorFontFace = function(value)
            TestFont:SetFont(value, 10)
            local font = TestFont:GetFont()
            return font and font:lower():gsub('/', '\\') == value:lower():gsub('/', '\\')
        end
    }

    local function check(key, value)
        local fn = checks[key]
        return not fn or fn(value)
    end

    local function get(item)
        return Addon:GetSetting(item[#item])
    end

    local function set(item, value)
        local key = item[#item]
        if not check(key, value) then
            return
        end
        return Addon:SetSetting(key, value)
    end

    local general = {
        type  = 'group',
        name  = GENERAL,
        order = order(),
        get   = get,
        set   = set,
        args  = {
            description = {
                type  = 'description',
                name  = L.OPTION_GENERAL_NOTES .. '\n\n',
                order = order(),
            },
            selectOnlyOneScript = {
                type  = 'toggle',
                name  = L.OPTION_SETTINGS_AUTO_SELECT_SCRIPT_ONLY_ONE,
                width = 'double',
                order = order(),
            },
            hideNoScript = {
                type  = 'toggle',
                name  = L.OPTION_SETTINGS_HIDE_SELECTOR_NO_SCRIPT,
                width = 'double',
                order = order(),
            },
            noWaitDeleteScript = {
                type  = 'toggle',
                name  = L.OPTION_SETTINGS_NO_WAIT_DELETE_SCRIPT,
                width = 'double',
                order = order(),
            },
            testBreak = {
                type  = 'toggle',
                name  = L.OPTION_SETTINGS_TEST_BREAK,
                width = 'double',
                order = order(),
            },
            autoButtonHotKey = {
                type  = 'keybinding',
                name  = L.OPTION_SETTINGS_AUTOBUTTON_HOTKEY,
                width = 'double',
                order = order(),
            },
        }
    }

    local editor = {
        type = 'group',
        name = L['Script editor'],
        order = order(),
        get   = get,
        set   = set,
        args = {
            description = {
                type  = 'description',
                name  = L.OPTION_SCRIPTEDITOR_NOTES .. '\n\n',
                order = order(),
            },
            editorFontFace = {
                type  = 'input',
                name  = L['Font face'],
                width = 'double',
            },
            editorFontSize = {
                type = 'range',
                name = L['Font size'],
                width = 'double',
                min = 9,
                max = 32,
                step = 1,
            },
        }
    }

    local plugins = {
        type  = 'group',
        name  = L['Script selector'],
        order = order(),
        get   = function(item) return self:IsPluginAllowed(item[#item]) end,
        set   = function(item, value) return self:SetPluginAllowed(item[#item], value) end,
        args  = plugins_args,
    }

    AceConfigRegistry:RegisterOptionsTable('tdBattlePetScript Options', general)
    AceConfigRegistry:RegisterOptionsTable('tdBattlePetScript Editor',  editor)
    AceConfigRegistry:RegisterOptionsTable('tdBattlePetScript Plugins', plugins)

    AceConfigDialog:AddToBlizOptions('tdBattlePetScript Options', 'tdBattlePetScript')
    AceConfigDialog:AddToBlizOptions('tdBattlePetScript Editor',  L['Script editor'], 'tdBattlePetScript')
    AceConfigDialog:AddToBlizOptions('tdBattlePetScript Plugins', L['Script selector'], 'tdBattlePetScript')
end

function Addon:CreateOrderFactory()
    local order = 0
    return function()
        order = order + 1
        return order
    end
end

function Addon:RefillPluginOptions()
    local args = wipe(plugins_args)
    local order = self:CreateOrderFactory()

    args.description = {
        type     = 'description',
        name     = L.OPTION_SCRIPTSELECTOR_NOTES .. '\n\n',
        order    = order(),
    }

    for name, plugin in self:IteratePlugins() do
        args[name] = {
            type  = 'toggle',
            name  = plugin:GetPluginTitle(),
            desc  = plugin:GetPluginNotes(),
            order = order(),
            width = 'double',
        }
    end
    AceConfigRegistry:NotifyChange('tdBattlePetScript Plugins')
end

local function OpenToCategory(key)
    InterfaceOptionsFrame_OpenToCategory(key)
    InterfaceOptionsFrame_OpenToCategory(key)

    OpenToCategory = InterfaceOptionsFrame_OpenToCategory
end

function Addon:OpenOptionFrame()
    OpenToCategory('tdBattlePetScript')
end
