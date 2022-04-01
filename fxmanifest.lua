
fx_version('cerulean')
games({ 'gta5' })

author 'Zykem'
description 'Skrypt na Komende /odbierz'

shared_script('');

server_scripts({

    'config.lua',
    'server.lua',
    '@mysql-async/lib/MySQL.lua'

});

client_scripts({

    'config.lua',
    'client.lua'

});