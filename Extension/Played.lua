--[[
Played.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]
local ns     = select(2, ...)
local Played = ns.BattleCacheManager:NewModule('Played', 'AceEvent-3.0')

function Played:OnEnable()
    self.played = self:AllocCache({})

    self:RegisterEvent('PET_BATTLE_PET_CHANGED')
end

function Played:OnBattleStart()
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
