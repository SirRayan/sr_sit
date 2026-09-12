local Config = require('config.config')

if Config.CheckForUpdates then
    lib.versionCheck('SirRayan/sr_sit')
end
