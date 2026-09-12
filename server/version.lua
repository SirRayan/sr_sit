local Config = require('config.config')

if Config.CheckForUpdates == false then return end

local resource = GetCurrentResourceName()
local currentVersion = GetResourceMetadata(resource, 'version', 0)

if not currentVersion then return end
currentVersion = currentVersion:match('%d+%.%d+%.%d+') or currentVersion

local repository = 'SirRayan/sr_sit'

local function compareVersions(current, latest)
    local cv, lv = {}, {}
    for part in string.gmatch(current, '%d+') do cv[#cv + 1] = tonumber(part) end
    for part in string.gmatch(latest, '%d+') do lv[#lv + 1] = tonumber(part) end

    for i = 1, math.max(#cv, #lv) do
        local c = cv[i] or 0
        local l = lv[i] or 0
        if c < l then return -1 end
        if c > l then return 1 end
    end
    return 0
end

local function printVersionStatus(latestVersion)
    if not latestVersion then return end
    latestVersion = latestVersion:match('%d+%.%d+%.%d+') or latestVersion

    local comparison = compareVersions(currentVersion, latestVersion)

    if comparison == 0 then
        print(("^2[%s] You are running the latest version (v%s). No update needed.^0"):format(resource, currentVersion))
    elseif comparison < 0 then
        print(("^3[%s] Update available: v%s -> v%s (https://github.com/%s)^0"):format(resource, currentVersion, latestVersion, repository))
    end
end

CreateThread(function()
    Wait(2000)

    PerformHttpRequest(('https://raw.githubusercontent.com/%s/main/fxmanifest.lua'):format(repository), function(status, response)
        if status == 200 and response then
            local version = response:match("version%s*['\"](.-)['\"]")
            if version then
                return printVersionStatus(version)
            end
        end

        PerformHttpRequest(('https://api.github.com/repos/%s/releases/latest'):format(repository), function(relStatus, relResponse)
            if relStatus == 200 and relResponse then
                local data = json.decode(relResponse)
                if data and data.tag_name then
                    return printVersionStatus(data.tag_name)
                end
            end
        end, 'GET', '', { ['User-Agent'] = 'FiveM-Server-VersionCheck' })
    end, 'GET', '', { ['User-Agent'] = 'FiveM-Server-VersionCheck' })
end)
