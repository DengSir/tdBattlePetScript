-- BattleCacheManager.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/20/2018, 2:52:21 PM

local ns                   = select(2, ...)
local Addon                = ns.Addon
local BattleCacheManager   = Addon:NewModule('BattleCacheManager', 'AceEvent-3.0')
local BattleCachePrototype = {}

ns.BattleCachePrototype = BattleCachePrototype

BattleCacheManager:SetDefaultModulePrototype(BattleCachePrototype)

function BattleCacheManager:OnInitialize()
    self.caches = _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE or {}

    self:RegisterMessage('PET_BATTLE_SCRIPT_DB_SHUTDOWN')

    if C_PetBattles.IsInBattle() then
        self:RegisterEvent('PET_BATTLE_CLOSE', function()
            self:UnregisterEvent('PET_BATTLE_CLOSE')
            self:RegisterEvent('PET_BATTLE_OPENING_START')
        end)
    else
        self:RegisterEvent('PET_BATTLE_OPENING_START')
    end
end

function BattleCacheManager:PET_BATTLE_SCRIPT_DB_SHUTDOWN()
    if C_PetBattles.IsInBattle() then
        _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE = self.caches
    else
        _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE = nil
    end
end

function BattleCacheManager:PET_BATTLE_OPENING_START()
    for _, module in self:IterateModules() do
        module:OnBattleStart()
    end
end

function BattleCacheManager:AllocCache(name, default)
    if not self.caches[name] then
        self.caches[name] = CopyTable(default) or {}
    end
    return self.caches[name]
end
