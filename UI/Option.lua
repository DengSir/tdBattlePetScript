--[[
Option.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]
local ADDON,             ns = ...
local Addon             = ns.Addon
local L                 = ns.L
local PluginManager     = ns.PluginManager
local AceConfigRegistry = LibStub('AceConfigRegistry-3.0')
local AceConfigDialog   = LibStub('AceConfigDialog-3.0')
local GUI               = LibStub('tdGUI-1.0')
local Option            = Addon:NewModule('Option')

local function orderGen()
    local order = 0
    return function()
        order = order + 1
        return order
    end
end

function Option:OnInitialize()
    self.pluginsOptions = {}
    self.fontChecker    = CreateFont('tdBattlePetScriptFontTest')
end

function Option:OnEnable()
    self:InitOptions()
    self:GeneratePluginOptions()
    C_Timer.After(1, function()
        self:CheckNotInstalledPlugins()
    end)
end

function Option:CheckNotInstalledPlugins()
    local notInstallPlugins = PluginManager:GetNotInstalledPlugins()
    if not next(notInstallPlugins) then
        return
    end

    GUI:Notify{
        text     = format('%s\n|cffff0000%s|r', ADDON, L.SCRIPT_SELECTOR_NOTINSTALLED_TEXT),
        icon     = ns.ICON,
        help     = L.SCRIPT_SELECTOR_NOTINSTALLED_HELP,
        ignore   = L['Don\'t ask me'],
        id       = format('%s.Plugin.NotInstalled', ADDON),
        storage  = Addon.db.global.notifies,
        OnAccept = function()
            self:Open('plugins')
        end
    }
end

function Option:InitOptions()
    local order = orderGen()

    local checks = {
        editorFontFace = function(value)
            self.fontChecker:SetFont(value, 10)
            local font = self.fontChecker:GetFont()
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

    local options = {
        type = 'group',
        childGroups = 'tab',
        args = {
            general = {
                type = 'group',
                name = GENERAL,
                order = order(),
                get = get,
                set = set,
                args = {
                    description = {
                        type = 'description',
                        order = order(),
                        name = '\n' .. L.OPTION_GENERAL_NOTES .. '\n\n',
                        fontSize = 'medium',
                        image = [[Interface\Common\help-i]],
                        imageWidth = 32,
                        imageHeight = 32,
                        imageCoords = {.2, .8, .2, .8}
                    },
                    autoSelect = {
                        type = 'toggle',
                        name = L.OPTION_SETTINGS_AUTO_SELECT_SCRIPT_BY_ORDER,
                        width = 'double',
                        order = order()
                    },
                    hideNoScript = {
                        type = 'toggle',
                        name = L.OPTION_SETTINGS_HIDE_SELECTOR_NO_SCRIPT,
                        width = 'double',
                        order = order()
                    },
                    noWaitDeleteScript = {
                        type = 'toggle',
                        name = L.OPTION_SETTINGS_NO_WAIT_DELETE_SCRIPT,
                        width = 'double',
                        order = order()
                    },
                    hideMinimap = {
                        type = 'toggle',
                        name = L.OPTION_SETTINGS_HIDE_MINIMAP,
                        width = 'double',
                        order = order(),
                        confirm = true,
                        confirmText = L.OPTION_SETTINGS_HIDE_MINIMAP_TOOLTIP,
                        set = function(item, value)
                            set(item, value)
                            C_UI.Reload()
                        end
                    },
                    lockScriptSelector = {
                        type = 'toggle',
                        name = L.OPTION_SETTINGS_LOCK_SCRIPT_SELECTOR,
                        width = 'double',
                        order = order()
                    },
                    testBreak = {
                        type = 'toggle',
                        name = L.OPTION_SETTINGS_TEST_BREAK,
                        width = 'double',
                        order = order()
                    },
                    autoButtonHotKey = {
                        type = 'keybinding',
                        name = L.OPTION_SETTINGS_AUTOBUTTON_HOTKEY,
                        width = 'double',
                        order = order()
                    },
                    scriptSelectorResetPos = {
                        type = 'execute',
                        name = L.OPTION_SETTINGS_RESET_FRAMES,
                        width = 'double',
                        order = order(),
                        func = function()
                            Addon:ResetFrames()
                        end
                    }
                }
            },
            editor = {
                type = 'group',
                name = L['Script editor'],
                order = order(),
                get = get,
                set = set,
                args = {
                    description = {
                        type = 'description',
                        name = '\n' .. L.OPTION_SCRIPTEDITOR_NOTES .. '\n\n',
                        order = order(),
                        fontSize = 'medium',
                        image = [[Interface\Common\help-i]],
                        imageWidth = 32,
                        imageHeight = 32,
                        imageCoords = {.2, .8, .2, .8}
                    },
                    editorFontFace = {
                        type = 'input',
                        name = L['Font face'],
                        width = 'double'
                    },
                    editorFontSize = {
                        type = 'range',
                        name = L['Font size'],
                        width = 'double',
                        min = 9,
                        max = 32,
                        step = 1
                    }
                }
            },
            plugins = {
                type = 'group',
                name = L['Script selector'],
                order = order(),
                get = function(item)
                    return PluginManager:IsPluginAllowed(item[#item])
                end,
                set = function(item, value)
                    return PluginManager:SetPluginAllowed(item[#item], value)
                end,
                args = self.pluginsOptions
            }
        }
    }

    AceConfigRegistry:RegisterOptionsTable(ADDON, options)
    AceConfigDialog:AddToBlizOptions(ADDON, ADDON)
end

function Option:FillInstalledPlugins(args, order)
    args.installed = {
        type = 'header',
        order = order(),
        name = L['Installed']
    }

    local pluginCount = #PluginManager:GetPluginList()

    for i, plugin in PluginManager:IteratePlugins() do
        local name = plugin:GetPluginName()
        local isFirst = i == 1
        local isLast = i == pluginCount

        args[name] = {
            type = 'toggle',
            name = function()
                return PluginManager:IsPluginAllowed(name) and plugin:GetPluginTitle() or
                    format('|cff808080%s (%s)|r', plugin:GetPluginTitle(), DISABLE)
            end,
            desc = plugin:GetPluginNotes(),
            width = 'double',
            order = order()
        }

        args[name .. 'Up'] = {
            type = 'execute',
            name = '',
            width = 0.3,
            disabled = isFirst,
            image = function()
                return isFirst and [[Interface\MINIMAP\MiniMap-VignetteArrow]] or
                    [[Interface\MINIMAP\MiniMap-QuestArrow]]
            end,
            imageCoords = {0.1875, 0.8125, 0.1875, 0.8125},
            imageWidth = 19,
            imageHeight = 19,
            order = order(),
            func = function()
                PluginManager:MoveUpPlugin(name)
                self:GeneratePluginOptions()
            end
        }

        args[name .. 'Down'] = {
            type = 'execute',
            name = '',
            width = 0.3,
            disabled = isLast,
            image = function()
                return isLast and [[Interface\MINIMAP\MiniMap-VignetteArrow]] or
                    [[Interface\MINIMAP\MiniMap-QuestArrow]]
            end,
            imageCoords = {0.1875, 0.8125, 0.8125, 0.1875},
            imageWidth = 19,
            imageHeight = 19,
            order = order(),
            func = function()
                PluginManager:MoveDownPlugin(name)
                self:GeneratePluginOptions()
            end
        }

        args[name .. 'Fill'] = {
            type = 'description',
            name = '',
            order = order()
        }
    end
end

function Option:FillNotInstalledPlugins(args, order)
    local notInstallPlugins = PluginManager:GetNotInstalledPlugins()
    if not next(notInstallPlugins) then
        return
    end

    args.notinstalled = {
        type = 'header',
        order = order(),
        name = L['Not Installed']
    }

    for _, v in ipairs(notInstallPlugins) do
        args[v.addon .. 'NotInstalled'] = {
            type = 'toggle',
            order = order(),
            name = v.addon,
            width = 'double',
            disabled = true,
            get = function()
                return false
            end
        }

        args[v.addon .. 'Download'] = {
            type = 'execute',
            order = order(),
            name = L['Download'],
            width = 0.7,
            func = function()
                self:CopyUrl(v.url)
            end
        }
    end
end

function Option:GeneratePluginOptions()
    local args = wipe(self.pluginsOptions)
    local order = orderGen()

    args.description = {
        type = 'description',
        order = order(),
        name = '\n' .. L.OPTION_SCRIPTSELECTOR_NOTES .. '\n\n',
        fontSize = 'medium',
        image = [[Interface\Common\help-i]],
        imageWidth = 32,
        imageHeight = 32,
        imageCoords = {.2, .8, .2, .8}
    }

    self:FillInstalledPlugins(args, order)
    self:FillNotInstalledPlugins(args, order)

    AceConfigRegistry:NotifyChange(ADDON)
end

function Option:CopyUrl(url)
    if not StaticPopupDialogs.TDBATTLEPETSCRIPT_COPYURL then
        StaticPopupDialogs.TDBATTLEPETSCRIPT_COPYURL = {}
    end
    local t = StaticPopupDialogs.TDBATTLEPETSCRIPT_COPYURL
    t.text = L.DIALOG_COPY_URL_HELP
    t.button2 = OKAY
    t.whileDead = 1
    t.hideOnEscape = 1
    t.hasEditBox = 1
    t.editBoxWidth = 300
    t.EditBoxOnTextChanged = function(editBox, url)
        if editBox:GetText() ~= url then
            editBox:SetMaxBytes(nil)
            editBox:SetMaxLetters(nil)
            editBox:SetText(url)
            editBox:HighlightText()
            editBox:SetCursorPosition(0)
            editBox:SetFocus()
        end
    end
    StaticPopup_Show('TDBATTLEPETSCRIPT_COPYURL', nil, nil, url)
end

local OpenToCategory = function(key)
    InterfaceOptionsFrame_OpenToCategory(key)
    InterfaceOptionsFrame_OpenToCategory(key)
    OpenToCategory = InterfaceOptionsFrame_OpenToCategory
end

function Option:Open(...)
    OpenToCategory(ADDON)
    if ... then
        AceConfigDialog:SelectGroup(ADDON, ...)
    end
end

----

function Addon:OpenOptionFrame(...)
    return Option:Open(...)
end
