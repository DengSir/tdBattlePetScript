--[[
Round.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local Round = Addon:NewModule('Round', 'AceEvent-3.0')

function Round:OnEnable()
    self.rounds = {
        [0]                   = 0,
        [LE_BATTLE_PET_ALLY]  = 0,
        [LE_BATTLE_PET_ENEMY] = 0,
    }

    if C_PetBattles.IsInBattle() then
        local cvar = GetCVar('tdBattlePetScript_Round')
        if cvar then
            local all, ally, enemy = cvar:match('^(%d+)/(%d+)/(%d+)$')

            self.rounds[0]                   = tonumber(all) or 0
            self.rounds[LE_BATTLE_PET_ALLY]  = tonumber(ally) or 0
            self.rounds[LE_BATTLE_PET_ENEMY] = tonumber(enemy) or 0
        end
    end

    self:RegisterEvent('PET_BATTLE_OPENING_START')
    self:RegisterEvent('PET_BATTLE_PET_ROUND_RESULTS')
    self:RegisterEvent('PET_BATTLE_PET_CHANGED')
    self:RegisterMessage('PET_BATTLE_AUTO_COMBAT_DB_SHUTDOWN')
end

function Round:PET_BATTLE_OPENING_START()
    self.rounds[0]                   = 0
    self.rounds[LE_BATTLE_PET_ALLY]  = 0
    self.rounds[LE_BATTLE_PET_ENEMY] = 0
end

function Round:PET_BATTLE_PET_ROUND_RESULTS(_, round)
    self.rounds[0]                   = round + 1
    self.rounds[LE_BATTLE_PET_ALLY]  = self.rounds[LE_BATTLE_PET_ALLY] + 1
    self.rounds[LE_BATTLE_PET_ENEMY] = self.rounds[LE_BATTLE_PET_ENEMY] + 1
end

function Round:PET_BATTLE_PET_CHANGED(_, owner)
    if self.rounds[owner] then
        self.rounds[owner] = 1
    end
end

function Round:PET_BATTLE_AUTO_COMBAT_DB_SHUTDOWN()
    if C_PetBattles.IsInBattle() then
        RegisterCVar('tdBattlePetScript_Round')
        SetCVar('tdBattlePetScript_Round', format('%d/%d/%d', self.rounds[0], unpack(self.rounds)))
    end
end

function Round:GetRound()
    return self.rounds[0]
end

function Round:GetRoundByOwner(owner)
    return self.rounds[owner]
end
