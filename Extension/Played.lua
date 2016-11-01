--[[
Played.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns     = select(2, ...)
local Addon  = ns.Addon
local Played = Addon:NewModule('Played', 'AceEvent-3.0')

function Played:OnEnable()
    self.played = Addon:GetBattleCache('played') or {}

    if C_PetBattles.IsInBattle() then
        self:RegisterEvent('PET_BATTLE_CLOSE', function()
            self:UnregisterEvent('PET_BATTLE_CLOSE')
            self:RegisterEvent('PET_BATTLE_OPENING_START')
        end)
    else
        self:RegisterEvent('PET_BATTLE_OPENING_START')
    end

    self:RegisterEvent('PET_BATTLE_PET_CHANGED')
    self:RegisterMessage('PET_BATTLE_INBATTLE_SHUTDOWN')
end

function Played:PET_BATTLE_INBATTLE_SHUTDOWN()
    Addon:SetBattleCache('played', self.played)
end

function Played:PET_BATTLE_OPENING_START()
    wipe(self.played)
end

function Played:PET_BATTLE_PET_CHANGED(_, owner)
    self.played[self:GetPetSlot(owner, C_PetBattles.GetActivePet(owner))] = true
end

function Played:GetPetSlot(owner, pet)
    return (owner - 1) * NUM_BATTLE_PETS_IN_BATTLE + pet
end

function Played:IsPetPlayed(owner, pet)
    return self.played[self:GetPetSlot(owner, pet)]
end
