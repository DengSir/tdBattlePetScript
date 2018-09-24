
local L = LibStub('AceLocale-3.0'):NewLocale('tdBattlePetScript', 'enUS', true)
if not L then return end

--@debug@
--[[
--@end-debug@
@localization(locale=""enUS", format="lua_additive_table", table-name="L", same-key-is-true=true)@
--@debug@
--]]
--@end-debug@

--@debug@
L["ADDON_NAME"] = "Battle pet script"
L["Auto"] = true
L["Beauty script"] = true
L["Create script"] = true
L["Debugging script"] = true
L["Edit script"] = true
L["Export"] = true
L["Font face"] = true
L["Font size"] = true
L["Found error"] = true
L["Import"] = true
L["New script"] = true
L["No script"] = true
L["OPTION_GENERAL_NOTES"] = "Here are some general Settings."
L["OPTION_SCRIPTEDITOR_NOTES"] = "Here is the script editor preferences"
L["OPTION_SCRIPTSELECTOR_NOTES"] = "Here you can manage the script selector is open, and its priority."
L["OPTION_SETTINGS_AUTO_SELECT_SCRIPT_ONLY_ONE"] = "Automatically select script by script selector priority"
L["OPTION_SETTINGS_AUTO_SELECT_SCRIPT_BY_ORDER"] = true
L["OPTION_SETTINGS_AUTOBUTTON_HOTKEY"] = "Auto button hotkey"
L["OPTION_SETTINGS_HIDE_MINIMAP"] = "Hide minimap"
L["OPTION_SETTINGS_HIDE_MINIMAP_TOOLTIP"] = [=[Detected the addon "MinimapButtonBag", modify the settings need to reload the UI, Do you continue?]=]
L["OPTION_SETTINGS_HIDE_SELECTOR_NO_SCRIPT"] = "The script selector is not displayed when there is no script"
L["OPTION_SETTINGS_NO_WAIT_DELETE_SCRIPT"] = "Do not wait for the script to be deleted"
L["OPTION_SETTINGS_TEST_BREAK"] = "Debug: Action test break script"
L["Options"] = true
L["PLUGINBASE_NOTES"] = "This script chooser matches ally and enemy."
L["PLUGINBASE_TEAM_ALLY"] = "Ally"
L["PLUGINBASE_TEAM_ENEMY"] = "Enemy"
L["PLUGINBASE_TITLE"] = "Base"
L["PLUGINBASE_TOOLTIP_CREATE_SCRIPT"] = "Base: Create a script for the current match"
L["Run"] = true
L["Save success"] = true
L["Script"] = true
L["Script author"] = true
L["Script editor"] = true
L["Script manager"] = true
L["Script name"] = true
L["Script notes"] = true
L["Script selector"] = true
L["SCRIPT_EDITOR_DELETE_SCRIPT"] = "Are you sure you want to |cffff0000delete|r the script |cffffd000[%s - %s]|r ?"
L["SCRIPT_EDITOR_LABEL_TOGGLE_EXTRA"] = "Toggle extension information editor"
L["SCRIPT_IMPORT_LABEL_COVER"] = "The matching mode existing script, and continue to import will cover the current script."
L["SCRIPT_IMPORT_LABEL_EXTRA"] = "Continue to import the plugin data"
L["SCRIPT_IMPORT_LABEL_GOON"] = "Cover and continue to import"
L["SCRIPT_SELECTOR_LOST_TOOLTIP"] = "Script selector developer does not define the function `OnTooltipFormatting`"
L["SCRIPT_SELECTOR_NOT_MATCH"] = "No script selector matches to the current battle"
L["Select script"] = true
L["TOGGLE_SCRIPT_MANAGER"] = "Toggle script manager"
L["TOGGLE_SCRIPT_SELECTOR"] = "Toggle script selector"
L["TOOLTIP_CREATE_OR_DEBUG_SCRIPT"] = "Create or debug script"
L["PLUGINALLINONE_TITLE"] = 'All in one'
L["PLUGINALLINONE_NOTES"] = 'This script can be used in all pet battles.'
L['Installed']        = true
L['Not Installed']    = true
L['Download']         = true
L['Don\'t ask me'] = true
L['Update to version: '] = true

L.IMPORT_SCRIPT_WELCOME = 'Copy Share string or script to edit box.'
L.IMPORT_SCRIPT_WARNING = 'You have entered the script and are advised to import using the Share string, although you can continue to import as well.'
L.IMPORT_REINPUT_TEXT = 'Re-edit'
L.IMPORT_CHOOSE_PLUGIN = 'Select the script selector...'
L.IMPORT_CHOOSE_KEY = 'Select the key...'
L.IMPORT_SCRIPT_EXISTS = 'Script exists'
L.IMPORT_SHARED_STRING_WARNING = 'Share string data incomplete. But you can still import it.'
L.DIALOG_COPY_URL_HELP = 'Press ctrl-c to copy and open it in the browser'
L.SCRIPT_SELECTOR_NOTINSTALLED_TEXT = 'A useful script selector is not installed!'
L.SCRIPT_SELECTOR_NOTINSTALLED_HELP = 'Left click to view, right click to close'

--@end-debug@
