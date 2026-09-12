local Config = require('config.config')

local function getLocale()
    if Config.Language and Config.Language ~= '' then
        return Config.Language
    end

    local oxLocale = GetConvar('ox:locale', '')
    if oxLocale ~= '' then
        return oxLocale
    end

    return 'en'
end

lib.locale(getLocale())

local models = require('config.models')
local isSit = false
local _debug = Config.Debug or false
local oldcoords = nil
local chairent = nil

local function debug(...)
    if not _debug then return end
    lib.print.info(...)
end

local function checkOccupied(pos)
    local players = lib.getNearbyPlayers(pos, 0.55)
    if #players > 0 then return true end

    local peds = lib.getNearbyPeds(pos, 0.55)
    return #peds > 0
end

local function findSeat(entity, seatList)
    local coords = GetEntityCoords(cache.ped)
    local candidate = nil
    local minDistance = 999.0

    for i = 1, #seatList do
        local s = seatList[i]
        local worldPos = GetOffsetFromEntityInWorldCoords(entity, s.x, s.y, s.z)
        local dist = #(coords - worldPos)

        if dist < minDistance and not checkOccupied(worldPos) then
            minDistance = dist
            candidate = s
        end
    end

    return candidate
end

local function sit(ent, offset)
    offset = offset or {}
    chairent = ent
    isSit = true
    lib.showTextUI(locale('press_to_get_up'), {
        position = Config.TextUIPosition or 'right-center',
    })
    FreezeEntityPosition(cache.ped, true)
    local coords = GetEntityCoords(cache.ped)
    oldcoords = vec4(coords.x, coords.y, coords.z, GetEntityHeading(cache.ped))
    AttachEntityToEntity(cache.ped, ent, 0, offset.x or 0.0, offset.y or 0.0, offset.z or 0.5, 0.0, 0.0, offset.w or 180.0, false, false, false, true, 2, true)
    TaskStartScenarioInPlace(cache.ped, 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', -1, true)
    CreateThread(function()
        while isSit do
            DisableCamCollisionForEntity(ent)
            Wait(0)
        end
    end)
end

local function getUp()
    if not isSit then return end
    isSit = false
    lib.hideTextUI()
    FreezeEntityPosition(cache.ped, false)
    if IsEntityAttached(cache.ped) then
        DetachEntity(cache.ped, true, true)
    end
    ClearPedTasks(cache.ped)
    if oldcoords then
        SetEntityCoords(cache.ped, oldcoords.x, oldcoords.y, oldcoords.z - 1, 0, 0, 0, 0)
        SetEntityHeading(cache.ped, oldcoords.w)
        oldcoords = nil
    end
    debug('getting up')
    if chairent then
        FreezeEntityPosition(chairent, false)
        chairent = nil
    end
    Wait(1000)
end

CreateThread(function()
    local modelList = {}
    for hash in pairs(models) do
        modelList[#modelList + 1] = hash
    end

    exports.ox_target:addModel(modelList, {
        icon = Config.Target and Config.Target.icon or 'fa-solid fa-chair',
        label = locale('target_sit'),
        distance = Config.Target and Config.Target.distance or 1.5,
        onSelect = function(data)
            if isSit then
                debug('already sitting')
                return
            end
            local seats = models[GetEntityModel(data.entity)]
            if not seats then return end

            local targetSeat = findSeat(data.entity, seats)
            if not targetSeat then
                lib.notify({
                    title = locale('seat_title'),
                    description = locale('seat_occupied'),
                    type = 'error'
                })
                return
            end
            FreezeEntityPosition(data.entity, true)
            sit(data.entity, targetSeat)
        end
    })

    lib.addKeybind({
        name = '_0_getUpsr_sit',
        description = locale('keybind_stand_up'),
        defaultKey = Config.DefaultKey or 'X',
        allowInPauseMenu = true,
        onPressed = function(self)
            getUp()
        end
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= cache.resource then return end
    getUp()
end)