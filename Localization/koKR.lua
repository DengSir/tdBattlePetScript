
local L = LibStub('AceLocale-3.0'):NewLocale('tdBattlePetScript', 'koKR')
if not L then return end

--[===[@debug@
--[[
--@end-debug@]===]
L["ADDON_NAME"] = "애완동물대전 스크립트"
L["Auto"] = "자동"
L["Beauty script"] = "스크립트 보기좋게 정리"
L["Create script"] = "스크립트 생성"
L["Debugging script"] = "스크립트 디버깅"
L["DIALOG_COPY_URL_HELP"] = "Ctrl-C 눌러 열려면 브라우저에 붙여넣기 하십시오."
--[[Translation missing --]]
--[[ L["Don't ask me"] = ""--]] 
L["Download"] = "다운로드"
L["Edit script"] = "스크립트 편집"
L["Export"] = "내보내기"
L["Font face"] = "글꼴"
L["Font size"] = "글꼴 크기"
L["Found error"] = "오류 발견"
L["Import"] = "가져오기"
--[[Translation missing --]]
--[[ L["IMPORT_CHOOSE_KEY"] = ""--]] 
L["IMPORT_CHOOSE_PLUGIN"] = "스크립트 선택기 선택..."
L["IMPORT_REINPUT_TEXT"] = "재편집"
L["IMPORT_SCRIPT_EXISTS"] = "기존 스크립트"
L["IMPORT_SCRIPT_WARNING"] = "스크립트를 하고 가져 오기 위해 공유 코드를 사용하는 것이 좋습니다.，물론 가져 오기를 계속할 수 있습니다."
L["IMPORT_SCRIPT_WELCOME"] = "공유 문자열 또는 스크립트를 입력 상자에 복사하십시오."
L["IMPORT_SHARED_STRING_WARNING"] = "공유 문자열 데이터가 불완전합니다. 하지만 가져올 수 있습니다"
L["Installed"] = "설치됨"
L["New script"] = "새 스크립트"
L["No script"] = "스크립트 없음"
L["Not Installed"] = "설치되지 않음"
L["OPTION_GENERAL_NOTES"] = "일반 설정"
L["OPTION_SCRIPTEDITOR_NOTES"] = "스크립트 편집기 설정"
L["OPTION_SCRIPTSELECTOR_NOTES"] = "스크립트 선택기 설정"
L["OPTION_SETTINGS_AUTO_SELECT_SCRIPT_BY_ORDER"] = "스크립트 선택기 우선 순위에 따라 자동으로 스크립트 선택"
L["OPTION_SETTINGS_AUTO_SELECT_SCRIPT_ONLY_ONE"] = "스크립트가 하나일 경우 자동으로 선택"
L["OPTION_SETTINGS_AUTOBUTTON_HOTKEY"] = "자동 버튼 단축키"
L["OPTION_SETTINGS_HIDE_MINIMAP"] = "미니맵 버튼 감추기"
L["OPTION_SETTINGS_HIDE_MINIMAP_TOOLTIP"] = "\"MinimapButtonBag\" 애드온이 발견되었습니다, 설정 변경에 UI 리로드가 필요합니다, 계속 하시겠습니까?"
L["OPTION_SETTINGS_HIDE_SELECTOR_NO_SCRIPT"] = "스트립트가 없으면 스크립트 선택기 표시하지 않기"
L["OPTION_SETTINGS_LOCK_SCRIPT_SELECTOR"] = "스크립트 선택기 잠금"
L["OPTION_SETTINGS_NO_WAIT_DELETE_SCRIPT"] = "스크립트 삭제할 때에 기다리지 않기"
L["OPTION_SETTINGS_RESET_FRAMES"] = "패널 크기 및 위치 재설정"
L["OPTION_SETTINGS_TEST_BREAK"] = "디버그: 행동 테스트 중지 스크립트"
L["Options"] = "옵션"
L["PLUGINALLINONE_NOTES"] = "이 스크립트는 모든 애완 동물 전투에 사용할 수 있습니다."
--[[Translation missing --]]
--[[ L["PLUGINALLINONE_TITLE"] = ""--]] 
L["PLUGINBASE_NOTES"] = "이 스크립트 선택기는 우리팀과 상대팀을 매칭합니다."
L["PLUGINBASE_TEAM_ALLY"] = "우리팀"
L["PLUGINBASE_TEAM_ENEMY"] = "상대팀"
L["PLUGINBASE_TITLE"] = "기본"
L["PLUGINBASE_TOOLTIP_CREATE_SCRIPT"] = "기본：현재 대전에 대한 스크립트 생성"
L["PLUGINFIRSTENEMY_NOTES"] = "이 스크립트 선택기는 전투의 첫 번째 적에게 스크립트를 묶습니다."
L["PLUGINFIRSTENEMY_NOTIFY"] = "이전 tdBattlePetScript의 수정 된 버전을 사용하고 수정 된 Base selector의 스크립트 중 일부를 FirstEnemy 선택기로 마이그레이션 했습니다."
L["PLUGINFIRSTENEMY_TITLE"] = "첫 번째 적"
L["Run"] = "실행"
L["Save success"] = "저장 완료"
L["Script"] = "스크립트"
L["Script author"] = "스크립트 저자"
L["Script editor"] = "스크립트 편집기"
L["Script manager"] = "스크립트 관리자"
L["Script name"] = "스크립트 이름"
L["Script notes"] = "스크립트 메모"
L["Script selector"] = "스크립트 선택기"
L["SCRIPT_EDITOR_DELETE_SCRIPT"] = "스크립트  |cffffd000[%s - %s]|r 를 |cffff0000삭제|r 하시겠습니까？"
L["SCRIPT_EDITOR_LABEL_TOGGLE_EXTRA"] = "확장된 정보 편집기 토글"
L["SCRIPT_IMPORT_LABEL_COVER"] = "현재 모드와 일치하는 스크립트가 이미 있고, 가져오기를 계속할 경우 현재 스크립트에 덮어 쓸것입니다"
L["SCRIPT_IMPORT_LABEL_EXTRA"] = "플러그인 데이타 가져오기를 계속 진행"
L["SCRIPT_IMPORT_LABEL_GOON"] = "덮어쓰고 가져오기 계속하기"
L["SCRIPT_SELECTOR_LOST_TOOLTIP"] = "스크립트 선택 개발자가 `OnTooltipFormatting` 기능을 정의하지 않았습니다"
L["SCRIPT_SELECTOR_NOT_MATCH"] = "현재 전투와 일치하는 스크립트 선택기가 없습니다"
L["SCRIPT_SELECTOR_NOTINSTALLED_HELP"] = "왼쪽 버튼 보기, 오른쪽 버튼 닫기"
L["SCRIPT_SELECTOR_NOTINSTALLED_TEXT"] = "유용한 스크립트 선택기가 설치되지 않았습니다!"
L["Select script"] = "스크립트 선택"
L["TOGGLE_SCRIPT_MANAGER"] = "스크립트 관리자 토글"
L["TOGGLE_SCRIPT_SELECTOR"] = "스크립트 선택기 토글"
L["TOOLTIP_CREATE_OR_DEBUG_SCRIPT"] = "스크립트를 새로 만들거나 디버깅"
L["Update to version: "] = "버전 업데이트:"

--[===[@debug@
--]]
--@end-debug@]===]
