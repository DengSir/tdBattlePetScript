--[[
enUS.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local L = LibStub('AceLocale-3.0'):NewLocale('tdBattlePetScript', 'enUS', true)
if not L then return end

L.ADDON_NAME = 'Battle pet script'

L['Auto']             = true
L['Create script']    = true
L['Debugging script'] = true
L['Debugging script'] = true
L['Edit script']      = true
L['Export']           = true
L['Font face']        = true
L['Font size']        = true
L['Found error']      = true
L['Import']           = true
L['New script']       = true
L['No script']        = true
L['Options']          = true
L['Run']              = true
L['Save success']     = true
L['Script author']    = true
L['Script editor']    = true
L['Script name']      = true
L['Script notes']     = true
L['Script selector']  = true
L['Script']           = true
L['Select script']    = true
L['Beauty script']    = true
L['Script manager']   = true

L.TOGGLE_SCRIPT_MANAGER            = 'Toggle script manager'
L.TOGGLE_SCRIPT_SELECTOR           = 'Toggle script selector'
L.SCRIPT_SELECTOR_LOST_TOOLTIP     = 'Script selector developer does not define the function `OnTooltipFormatting`'
L.SCRIPT_EDITOR_LABEL_TOGGLE_EXTRA = 'Toggle extension information editor'
L.SCRIPT_EDITOR_DELETE_SCRIPT      = 'Are you sure you want to |cffff0000delete|r the script |cffffd000[%s - %s]|r ?'

L.SCRIPT_IMPORT_LABEL_COVER = 'The matching mode existing script, and continue to import will cover the current script.'
L.SCRIPT_IMPORT_LABEL_EXTRA = 'Continue to import the plugin data'
L.SCRIPT_IMPORT_LABEL_GOON  = 'Cover and continue to import'

L.OPTION_GENERAL_NOTES                        = 'Here are some general Settings.'
L.OPTION_SCRIPTSELECTOR_NOTES                 = 'Here you can manage the script selector is open.'
L.OPTION_SETTINGS_AUTO_SELECT_SCRIPT_ONLY_ONE = 'It is only a script automatically selected'
L.OPTION_SETTINGS_HIDE_SELECTOR_NO_SCRIPT     = 'The script selector is not displayed when there is no script'
L.OPTION_SETTINGS_NO_WAIT_DELETE_SCRIPT       = 'Do not wait for the script to be deleted'
L.OPTION_SETTINGS_AUTOBUTTON_HOTKEY           = 'Auto button hotkey'
L.OPTION_SCRIPTEDITOR_NOTES                   = 'Here is the script editor preferences'


L.PLUGINBASE_TITLE      = 'Base'
L.PLUGINBASE_NOTES      = 'This script chooser matches ally and enemy.'
L.PLUGINBASE_TEAM_ALLY  = 'Ally'
L.PLUGINBASE_TEAM_ENEMY = 'Enemy'
L.PLUGINBASE_TOOLTIP_CREATE_SCRIPT = 'Base: Create a script for the current match'
