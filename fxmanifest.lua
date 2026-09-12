fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
games { 'gta5' }

author 'SirRayan'
name 'sr_sit'
version '1.0.0'
repository 'https://github.com/SirRayan/sr_sit'

dependencies {
    'ox_lib',
    'ox_target'
}

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server/version.lua',
}

files {
    'locales/*.json',
    'config/*.lua'
}