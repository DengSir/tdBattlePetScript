--[[
Actions.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns    = select(2, ...)
local Addon = ns.Addon
local Util  = ns.Util


Addon:RegisterAction('test', function(arg)
    print(arg)
    return Addon:GetSetting('testBreak')
end)


Addon:RegisterAction('change', function(index)
    local active = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
    if index == 'next' then
        index = active % C_PetBattles.GetNumPets(LE_BATTLE_PET_ALLY) + 1
    else
        index = Util.ParsePetIndex(LE_BATTLE_PET_ALLY, index)
    end
    -- if not index or active == index or C_PetBattles.GetHealth(LE_BATTLE_PET_ALLY, index) == 0 then
    --     return false
    -- end

    if not index or active == index or not (C_PetBattles.CanActivePetSwapOut() or C_PetBattles.ShouldShowPetSelect()) or not C_PetBattles.CanPetSwapIn(index) then
        return false
    end

    C_PetBattles.ChangePet(index)
    return true
end)


Addon:RegisterAction('ability', 'use', function(ability)
    local index = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
    local ability= Util.ParseAbility(LE_BATTLE_PET_ALLY, index, ability)
    if not ability then
        return false
    end
    if not C_PetBattles.GetAbilityState(LE_BATTLE_PET_ALLY, index, ability) then
        return false
    end
    C_PetBattles.UseAbility(ability)
    return true
end)


Addon:RegisterAction('quit', function()
    C_PetBattles.ForfeitGame()
    return true
end)


Addon:RegisterAction('standby', function()
    if not C_PetBattles.IsSkipAvailable() then
        return false
    end
    C_PetBattles.SkipTurn()
    return true
end)


Addon:RegisterAction('catch', function()
    if not C_PetBattles.IsTrapAvailable() then
        return false
    end
    C_PetBattles.UseTrap()
    return true
end)

Addon:RegisterAction('--', function()
    return false
end)
