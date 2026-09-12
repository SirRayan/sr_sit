local Config = require('config.config')

if Config.CheckForUpdates ~= false then
    lib.versionCheck('SirRayan/sr_sit')
end
