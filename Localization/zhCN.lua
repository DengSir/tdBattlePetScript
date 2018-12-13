--[[
zhCN.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local L = LibStub('AceLocale-3.0'):NewLocale('tdBattlePetScript', 'zhCN')
if not L then return end

L.ADDON_NAME = '小宠物战斗脚本'

L['Auto']             = '自动'
L['Create script']    = '创建脚本'
L['Debugging script'] = '调试脚本'
L['Debugging script'] = '调试脚本'
L['Edit script']      = '修改脚本'
L['Export']           = '导出'
L['Font face']        = '字体'
L['Font size']        = '字体大小'
L['Found error']      = '发现错误'
L['Import']           = '导入'
L['New script']       = '新建脚本'
L['No script']        = '没有脚本'
L['Options']          = '设置'
L['Run']              = '运行'
L['Save success']     = '保存成功'
L['Script author']    = '作者名称'
L['Script editor']    = '脚本编辑器'
L['Script name']      = '脚本名称'
L['Script notes']     = '脚本备注'
L['Script selector']  = '脚本选择器'
L['Script']           = '脚本'
L['Select script']    = '选择脚本'
L['Beauty script']    = '美化脚本'
L['Script manager']   = '脚本管理器'
L['Installed']        = '已安装'
L['Not Installed']    = '未安装'
L['Download']         = '下载'
L['Don\'t ask me']    = '不再提醒'

L['Update to version: '] = '更新到版本：'

L.TOGGLE_SCRIPT_MANAGER             = '切换脚本管理器'
L.TOGGLE_SCRIPT_SELECTOR            = '切换脚本选择器'
L.SCRIPT_SELECTOR_LOST_TOOLTIP      = '脚本选择器开发者没有定义 OnTooltipFormatting'
L.SCRIPT_EDITOR_LABEL_TOGGLE_EXTRA  = '切换扩展信息编辑器'
L.SCRIPT_EDITOR_DELETE_SCRIPT       = '你确定要|cffff0000删除|r脚本 |cffffd000[%s - %s]|r 么？'
L.TOOLTIP_CREATE_OR_DEBUG_SCRIPT    = '创建或调试脚本'
L.SCRIPT_SELECTOR_NOT_MATCH         = '没有脚本选择器匹配到当前战斗'
L.DIALOG_COPY_URL_HELP              = '按Ctrl-C复制到浏览器打开'
L.SCRIPT_SELECTOR_NOTINSTALLED_TEXT = '发现一个有用的脚本选择器未安装！'
L.SCRIPT_SELECTOR_NOTINSTALLED_HELP = '左键查看，右键关闭'

L.SCRIPT_IMPORT_LABEL_COVER = '这个匹配模式下已存在脚本，继续导入将覆盖当前脚本。'
L.SCRIPT_IMPORT_LABEL_EXTRA = '继续导入扩展信息'
L.SCRIPT_IMPORT_LABEL_GOON  = '覆盖并继续导入'

L.IMPORT_SCRIPT_WELCOME        = '复制分享字符串或脚本到输入框。'
L.IMPORT_SCRIPT_WARNING        = '你输入了脚本，建议你使用分享码导入，当然你也可以继续导入。'
L.IMPORT_REINPUT_TEXT          = '重新编辑'
L.IMPORT_CHOOSE_PLUGIN         = '请选择脚本选择器...'
L.IMPORT_CHOOSE_KEY            = '请选择关建值...'
L.IMPORT_SCRIPT_EXISTS         = '已存在脚本'
L.IMPORT_SHARED_STRING_WARNING = '分享字符串数据不全。但依然可以导入。'

L.OPTION_GENERAL_NOTES                        = '这里是一些常规设置。'
L.OPTION_SCRIPTSELECTOR_NOTES                 = '在这里你可以管理脚本选择器是否开启以及脚本选择器的优先级。'
L.OPTION_SETTINGS_AUTO_SELECT_SCRIPT_ONLY_ONE = '只有一个脚本时自动选择'
L.OPTION_SETTINGS_AUTO_SELECT_SCRIPT_BY_ORDER = '自动根据脚本选择器优先级选择脚本'
L.OPTION_SETTINGS_HIDE_SELECTOR_NO_SCRIPT     = '没有脚本时不显示脚本选择器'
L.OPTION_SETTINGS_NO_WAIT_DELETE_SCRIPT       = '删除脚本时不等待'
L.OPTION_SETTINGS_AUTOBUTTON_HOTKEY           = '自动按钮快捷键'
L.OPTION_SCRIPTEDITOR_NOTES                   = '这里是脚本编辑器的偏好设置'
L.OPTION_SETTINGS_TEST_BREAK                  = 'Debug: test 命令中断脚本'
L.OPTION_SETTINGS_HIDE_MINIMAP                = '隐藏小地图图标'
L.OPTION_SETTINGS_HIDE_MINIMAP_TOOLTIP        = '修改这项设置需要重新载入UI，是否继续？'

L.OPTION_SETTINGS_LOCK_SCRIPT_SELECTOR = '锁定脚本选择器'
L.OPTION_SETTINGS_RESET_FRAMES = '重置面板大小与位置'

L.PLUGINBASE_TITLE      = '基础'
L.PLUGINBASE_NOTES      = '这个脚本选择器将脚本绑定到对阵双方的完整阵容。'
L.PLUGINBASE_TEAM_ALLY  = '我方阵容'
L.PLUGINBASE_TEAM_ENEMY = '敌方阵容'
L.PLUGINBASE_TOOLTIP_CREATE_SCRIPT = '基础：为当前对阵创建脚本'

L.PLUGINALLINONE_TITLE = 'All in one'
L.PLUGINALLINONE_NOTES = '所有小宠物战斗都可以使用这个脚本。'

L.PLUGINFIRSTENEMY_TITLE = 'First enemy'
L.PLUGINFIRSTENEMY_NOTES = '这个脚本选择器将脚本绑定到战斗的第一个敌人。'

L.PLUGINFIRSTENEMY_NOTIFY = '发现你之前使用过修改版的tdBattlePetScript，已将修改版的Base选择器的部分脚本迁移到FirstEnemy选择器。'
