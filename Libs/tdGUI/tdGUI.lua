--[[
Addon.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'tdGUI-1.0', 6
local GUI, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not GUI then return end

---- Embed

function GUI:NewEmbed(major, minor)
    return LibStub:NewLibrary(format('%s.Embed.%s', MAJOR, major), minor)
end

function GUI:GetEmbed(major)
    return LibStub:GetLibrary(format('%s.Embed.%s', MAJOR, major))
end

function GUI:Embed(target, ...)
    for i = 1, select('#', ...) do
        local embed = GUI:GetEmbed(select(i, ...))
        if embed then
            embed:Embed(target)
        end
    end
    return target
end

function GUI:EmbedFactory(embed, mixins)
    embed.embeds = embed.embeds or {}

    local function Embed(_, target)
        for k, v in pairs(mixins) do
            target[v] = embed[v]
        end

        embed.embeds[target] = true
        return target
    end

    for target in pairs(embed.embeds) do
        Embed(embed, target)
    end
    return Embed
end

---- Class

local Class = LibStub('LibClass-2.0')

function GUI:NewClass(major, minor, super, ...)
    local lib, oldminor = LibStub:NewLibrary(format('%s.Class.%s', MAJOR, major), minor)
    if not lib then
        return
    end

    if lib.class then
        local _super, _inherit = Class:SuperHelper(super)

        if lib.class:GetSuper() ~= _super or lib.class:GetInherit() ~= _inherit then
            error('ERROR')
        end
    else
        lib.class = Class:New(super)
    end

    self:Embed(lib.class, ...)

    return lib.class, oldminor, lib
end

function GUI:GetClass(major)
    local lib = LibStub:GetLibrary(format('%s.Class.%s', MAJOR, major))
    return lib.class
end
