--@debug@
local L = LibStub('AceLocale-3.0'):NewLocale(..., 'enUS', true)
--@end-debug@
--[===[@non-debug@
local L = LibStub('AceLocale-3.0'):NewLocale(..., 'enUS', true, true)
--@end-non-debug@]===]
if not L then
    return
end

--@localization(locale="enUS", format="lua_additive_table", table-name="L", same-key-is-true=true)@

--@debug@
--@import@
L['ADDON_NAME'] = 'Battle pet script'
L['Auto'] = true
L['Beauty script'] = true
L['Create script'] = true
L['Debugging script'] = true
L['DIALOG_COPY_URL_HELP'] = 'Press ctrl-c to copy and open it in the browser'
L['Don\'t ask me'] = true
L['Download'] = true
L['Edit script'] = true
L['Export'] = true
L['Font face'] = true
L['Font size'] = true
L['Found error'] = true
L['Import'] = true
L['IMPORT_CHOOSE_KEY'] = 'Select the key...'
L['IMPORT_CHOOSE_PLUGIN'] = 'Select the script selector...'
L['IMPORT_REINPUT_TEXT'] = 'Re-edit'
L['IMPORT_SCRIPT_EXISTS'] = 'Script exists'
L['IMPORT_SCRIPT_WARNING'] =
    'You have entered the script and are advised to import using the Share string, although you can continue to import as well.'
L['IMPORT_SCRIPT_WELCOME'] = 'Copy Share string or script to edit box.'
L['IMPORT_SHARED_STRING_WARNING'] = 'Share string data incomplete. But you can still import it.'
L['Installed'] = true
L['New script'] = true
L['No script'] = true
L['Not Installed'] = true
L['OPTION_GENERAL_NOTES'] = 'Here are some general Settings.'
L['OPTION_SCRIPTEDITOR_NOTES'] = 'Here is the script editor preferences'
L['OPTION_SCRIPTSELECTOR_NOTES'] = 'Here you can manage the script selector is open, and its priority.'
L['OPTION_SETTINGS_AUTO_SELECT_SCRIPT_BY_ORDER'] = true
L['OPTION_SETTINGS_AUTO_SELECT_SCRIPT_ONLY_ONE'] = 'Automatically select script by script selector priority'
L['OPTION_SETTINGS_AUTOBUTTON_HOTKEY'] = 'Auto button hotkey'
L['OPTION_SETTINGS_HIDE_MINIMAP'] = 'Hide minimap'
L['OPTION_SETTINGS_HIDE_MINIMAP_TOOLTIP'] = 'Changing this setting requires reloading the UI. Do you want to continue?'
L['OPTION_SETTINGS_HIDE_SELECTOR_NO_SCRIPT'] = 'The script selector is not displayed when there is no script'
L['OPTION_SETTINGS_NO_WAIT_DELETE_SCRIPT'] = 'Do not wait for the script to be deleted'
L['OPTION_SETTINGS_TEST_BREAK'] = 'Debug: Action test break script'
L['OPTION_SETTINGS_LOCK_SCRIPT_SELECTOR'] = 'Lock the script selector'
L['OPTION_SETTINGS_RESET_FRAMES'] = 'Reset the panel size and position'
L['Options'] = true
L['PLUGINFIRSTENEMY_NOTIFY'] = 'Discover that you\'ve previously used the modified version of tdBattlePetScript and have migrated some of the scripts for the modified Base Selector to firstEnemy Selector.'
L['PLUGINFIRSTENEMY_NOTES'] = 'This script selector binds the script to the first enemy in the battle.'
L['PLUGINFIRSTENEMY_TITLE'] = 'First enemy'
L['PLUGINALLINONE_NOTES'] = 'This script can be used in all pet battles.'
L['PLUGINALLINONE_TITLE'] = 'All in one'
L['PLUGINBASE_NOTES'] = 'This script selector matches ally and enemy.'
L['PLUGINBASE_TEAM_ALLY'] = 'Ally'
L['PLUGINBASE_TEAM_ENEMY'] = 'Enemy'
L['PLUGINBASE_TITLE'] = 'Base'
L['PLUGINBASE_TOOLTIP_CREATE_SCRIPT'] = 'Base: Create a script for the current match'
L['Run'] = true
L['Save success'] = true
L['Script'] = true
L['Script author'] = true
L['Script editor'] = true
L['Script manager'] = true
L['Script name'] = true
L['Script notes'] = true
L['Script selector'] = true
L['SCRIPT_EDITOR_DELETE_SCRIPT'] = 'Are you sure you want to |cffff0000delete|r the script |cffffd000[%s - %s]|r ?'
L['SCRIPT_EDITOR_LABEL_TOGGLE_EXTRA'] = 'Toggle extension information editor'
L['SCRIPT_IMPORT_LABEL_COVER'] =
    'The matching mode existing script, and continue to import will cover the current script.'
L['SCRIPT_IMPORT_LABEL_EXTRA'] = 'Continue to import the plugin data'
L['SCRIPT_IMPORT_LABEL_GOON'] = 'Cover and continue to import'
L['SCRIPT_SELECTOR_LOST_TOOLTIP'] = 'Script selector developer does not define the function `OnTooltipFormatting`'
L['SCRIPT_SELECTOR_NOT_MATCH'] = 'No script selector matches to the current battle'
L['SCRIPT_SELECTOR_NOTINSTALLED_HELP'] = 'Left click to view, right click to close'
L['SCRIPT_SELECTOR_NOTINSTALLED_TEXT'] = 'A useful script selector is not installed!'
L['Select script'] = true
L['TOGGLE_SCRIPT_MANAGER'] = 'Toggle script manager'
L['TOGGLE_SCRIPT_SELECTOR'] = 'Toggle script selector'
L['TOOLTIP_CREATE_OR_DEBUG_SCRIPT'] = 'Create or debug script'
L['Update to version: '] = true
--@end-import@
--@end-debug@
