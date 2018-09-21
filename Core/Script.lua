--[[
Script.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns       = select(2, ...)
local Addon    = ns.Addon
local Director = ns.Director
local Script   = Addon:NewClass('Script')

function Script:Constructor(db, plugin, key)
    self.db     = db
    self.key    = key
    self.plugin = plugin
end

function Script:GetDB()
    return self.db
end

function Script:GetName()
    return self.db.name
end

function Script:SetName(name)
    self.db.name = name
end

function Script:GetCode()
    return self.db.code
end

function Script:SetCode(code)
    local script, err = Director:BuildScript(code)
    if not script then
        return false, err
    end

    self.db.code = code
    self.script  = script
    return true
end

function Script:GetKey()
    return self.key
end

function Script:GetPlugin()
    return self.plugin
end

function Script:GetScript()
    if not self.script then
        self.script = Director:BuildScript(self.db.code)
    end
    return self.script
end
