--[[
Round.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]
local ns    = select(2, ...)
local Round = ns.BattleCacheManager:NewModule('Round', 'AceEvent-3.0')

function Round:OnEnable()
    self.rounds = self:AllocCache({
        [0] = 0,
        [LE_BATTLE_PET_ALLY] = 0,
        [LE_BATTLE_PET_ENEMY] = 0
    })

    self:RegisterEvent('PET_BATTLE_PET_ROUND_RESULTS')
    self:RegisterEvent('PET_BATTLE_PET_CHANGED')
end

function Round:PET_BATTLE_PET_ROUND_RESULTS(_, round)
    self.rounds[0] = round + 1
    self.rounds[LE_BATTLE_PET_ALLY] = self.rounds[LE_BATTLE_PET_ALLY] + 1
    self.rounds[LE_BATTLE_PET_ENEMY] = self.rounds[LE_BATTLE_PET_ENEMY] + 1
end

function Round:PET_BATTLE_PET_CHANGED(_, owner)
    if self.rounds[owner] then
        self.rounds[owner] = 1
    end
end

function Round:OnBattleStart()
    self.rounds[0] = 0
    self.rounds[LE_BATTLE_PET_ALLY] = 0
    self.rounds[LE_BATTLE_PET_ENEMY] = 0
end

function Round:GetRound()
    return self.rounds[0]
end

function Round:GetRoundByOwner(owner)
    return self.rounds[owner]
end
