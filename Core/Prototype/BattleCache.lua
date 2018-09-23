-- BattleCache.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 9/24/2018, 12:09:10 AM

local ns                   = select(2, ...)
local BattleCacheManager   = ns.BattleCacheManager
local BattleCachePrototype = ns.BattleCachePrototype

function BattleCachePrototype:AllocCache(default)
    return BattleCacheManager:AllocCache(self:GetName(), default)
end

function BattleCachePrototype:OnBattleStart()

end
