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
        [Enum.BattlePetOwner.Ally] = 0,
        [Enum.BattlePetOwner.Enemy] = 0
    })

    self:RegisterEvent('PET_BATTLE_PET_ROUND_RESULTS')
    self:RegisterEvent('PET_BATTLE_PET_CHANGED')
end

function Round:PET_BATTLE_PET_ROUND_RESULTS(_, round)
    -- for some reason, the event is fired twice if an enemy(?) pet dies,
    -- leading to increasing self.round counter twice. See issue #1.
    if round == self.rounds[0] - 1 then
        return
    end
    self.rounds[0] = round + 1
    self.rounds[Enum.BattlePetOwner.Ally] = self.rounds[Enum.BattlePetOwner.Ally] + 1
    self.rounds[Enum.BattlePetOwner.Enemy] = self.rounds[Enum.BattlePetOwner.Enemy] + 1
end

function Round:PET_BATTLE_PET_CHANGED(_, owner)
    if self.rounds[owner] then
        self.rounds[owner] = 1
    end
end

function Round:OnBattleStart()
    self.rounds[0] = 0
    self.rounds[Enum.BattlePetOwner.Ally] = 0
    self.rounds[Enum.BattlePetOwner.Enemy] = 0
end

function Round:GetRound()
    return self.rounds[0]
end

function Round:GetRoundByOwner(owner)
    return self.rounds[owner]
end
