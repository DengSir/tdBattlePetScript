--[[
Condition.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local ns        = select(2, ...)
local Util      = ns.Util
local Addon     = ns.Addon
local Condition = {} ns.Condition = Condition

Condition.apis = {}
Condition.opts = setmetatable({
    __default = {
        owner = true,
        pet   = true,
        arg   = true,
        type  = 'compare',
    }
}, {
    __newindex = function(t, k, v)
        rawset(t, k, setmetatable(v, {__index = t.__default}))
    end,
    __index = function(t)
        return t.__default
    end,
})

local opTabler = {
    compare = {
        ['=']  = function(a, b) return a == b   end,
        ['=='] = function(a, b) return a == b   end,
        ['!='] = function(a, b) return a ~= b   end,
        ['>']  = function(a, b) return a >  b   end,
        ['<']  = function(a, b) return a <  b   end,
        ['>='] = function(a, b) return a >= b   end,
        ['<='] = function(a, b) return a <= b   end,
        ['~']  = function(a, v) return     v[a] end,
        ['!~'] = function(a, v) return not v[a] end,
    },
    boolean = {
        ['=']  = function(a) return     a end,
        ['!']  = function(a) return not a end,
    },
    equality = {
        ['=']  = function(a, b) return a == b   end,
        ['=='] = function(a, b) return a == b   end,
        ['!='] = function(a, b) return a ~= b   end,
        ['~']  = function(a, v) return     v[a] end,
        ['!~'] = function(a, v) return not v[a] end,
    }
}

local multiTabler = {
    ['~']  = true,
    ['!~'] = true,
}

local parses = {
    'valueParse',
    'argParse',
}

local function trynumber(value)
    return tonumber(value) or value
end

local function trynil(value)
    return value ~= '' and value or nil
end

function Addon:RegisterCondition(name, opts, api)
    if opts then
        if opts.type and not opTabler[opts.type] then
            error([[Bad argument opts.type (expect compare/boolean/equality)]], 2)
        end

        for i, v in ipairs(parses) do
            if opts[v] and type(opts[v]) ~= 'function' then
                error(format([[Bad argument opts.%s (expect function)]], v), 2)
            end
        end
    end

    Condition.apis[name] = api
    Condition.opts[name] = opts
end

function Condition:Run(condition)
    if not condition then
        return true
    end
    if type(condition) == 'string' then
        return self:RunCondition(condition)
    elseif type(condition) == 'table' then
        for _, v in ipairs(condition) do
            if not self:Run(v) then
                return false
            end
        end
        return true
    else
        Util.assert(false, 'Invalid Condition: `%s` (type error)', condition)
    end
end

function Condition:RunCondition(condition)
    local owner, pet, cmd, arg, op, value = self:ParseCondition(condition)

    local fn  = self.apis[cmd]
    local opts = self.opts[cmd]
    if not fn then
        error('Big Bang !!!!!!')
    end

    if opts.pet == true and not pet then
        return false
    end
    if opts.arg == true and not arg then
        return false
    end
    return opTabler[opts.type][op](fn(owner, pet, arg), value)
end

function Condition:ParsePet(str)
    if not str then
        return
    end

    local owner, pet = Util.ParseQuote(str)
    owner = Util.ParsePetOwner(owner)
    if not owner then
        return
    end

    petInputed = not not pet
    pet        = Util.ParsePetIndex(owner, pet)
    return owner, pet, petInputed
end

function Condition:ParseCmd(major, minor)
    if not major then
        return
    end

    local cmd, arg = Util.ParseQuote(major)
    return minor and format('%s.%s', cmd, minor) or cmd, arg, not not arg
end

function Condition:ParseApi(str)
    if not str then
        return
    end

    local inQuote = false
    local args = {''}

    for char in str:gmatch('.') do
        if char == '.' and not inQuote then
            tinsert(args, '')
        else
            args[#args] = args[#args] .. char
        end

        if char == '(' then
            inQuote = true
        elseif char == ')' then
            inQuote = false
        end
    end

    local owner, pet, petInputed = self:ParsePet(args[1])
    local cmd,   arg, argInputed = self:ParseCmd(unpack(args, owner and 2 or 1))

    return owner, pet, cmd, arg, petInputed, argInputed
end

function Condition:ParseCondition(condition)
    local non, args, op, value = condition:match('^(!?)([^!=<>~]+)%s*([!=<>~]*)%s*(.*)$')

    Util.assert(non, 'Invalid Condition: `%s` (Can`t parse)', condition)

    local owner, pet, cmd, arg, petInputed, argInputed = self:ParseApi(args:trim())

    Util.assert(cmd, 'Invalid Condition: `%s` (Can`t parse)', condition)
    Util.assert(self.apis[cmd], 'Invalid Condition: `%s` (Not found cmd: `%s`)', condition, cmd)

    op    = trynil(op)
    value = trynil(value)
    non   = trynil(non)

    local opts = self.opts[cmd]

    if opts.type == 'compare' or opts.type == 'equality' then
        Util.assert(not non, 'Invalid Condition: `%s` (Not need non)',  condition)
        Util.assert(op,      'Invalid Condition: `%s` (Require op)',    condition)
        Util.assert(value,   'Invalid Condition: `%s` (Require value)', condition)
    elseif opts.type == 'boolean' then
        Util.assert(not op,    'Invalid Condition: `%s` (Not need op)',    condition)
        Util.assert(not value, 'Invalid Condition: `%s` (Not need value)', condition)

        value = nil
        op    = non or '='
    else
        Util.assert(true)
    end

    Util.assert(opTabler[opts.type][op], 'Invalid Condition: `%s` (Invalid op)', condition)

    if value then
        if multiTabler[op] then
            local values = {strsplit(',', value)}
            value = {}

            for i, v in ipairs(values) do
                v = trynumber(v:trim())
                if opts.valueParse then
                    v = Util.assert(opts.valueParse(v), 'Invalid Condition: `%s` (Error value)', condition)
                end
                value[v] = true
            end
        else
            value = trynumber(value)
            if opts.valueParse then
                value = Util.assert(opts.valueParse(value), 'Invalid Condition: `%s` (Error value)', condition)
            end
        end
    end

    if not opts.owner then
        Util.assert(not owner, 'Invalid Condition: `%s` (Not need owner)', condition)
    end

    if not opts.pet then
        Util.assert(not petInputed, 'Invalid Condition: `%s` (Not need pet)', condition)
    end

    if not opts.arg then
        Util.assert(not argInputed, 'Invalid Condition: `%s` (Not need arg)', condition)
    else
        arg = trynumber(arg)
        if opts.argParse then
            arg = opts.argParse(owner, pet, arg)
        end
    end
    return owner, pet, cmd, arg, op, value
end
