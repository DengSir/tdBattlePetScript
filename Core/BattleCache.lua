-- BattleCache.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/20/2018, 2:52:21 PM

local ns = select(2, ...)

local Addon = ns.Addon

local BattleCache = Addon:NewModule('BattleCache', 'AceEvent-3.0')
local BattleCachePrototype = {}

BattleCache:SetDefaultModulePrototype(BattleCachePrototype)

function BattleCache:OnInitialize()
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

function BattleCache:PET_BATTLE_SCRIPT_DB_SHUTDOWN()
    if C_PetBattles.IsInBattle() then
        _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE = self.caches
    else
        _G.TD_DB_BATTLEPETSCRIPT_BATTLE_CACHE = nil
    end
end

function BattleCache:PET_BATTLE_OPENING_START()
    for _, module in self:IterateModules() do
        module:OnBattleStart()
    end
end

function BattleCache:AllocCache(name, default)
    if not self.caches[name] then
        self.caches[name] = CopyTable(default) or {}
    end
    return self.caches[name]
end

-- BattleCachePrototype

function BattleCachePrototype:SetDefault(default)
    return BattleCache:AllocCache(self:GetName(), default)
end

function BattleCachePrototype:OnBattleStart()

end
