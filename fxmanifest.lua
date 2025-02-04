-- Este archivo es parte del proyecto fzt_Fov.
-- Copyright (c) 2025 fourztL. Todos los derechos reservados.
-- Este proyecto está distribuido bajo la Licencia Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0).
-- Para más detalles, consulta el archivo LICENSE.

fx_version 'cerulean'
game 'gta5'

author 'fourztL'
description 'FOV Changer'
version '1.0.0'

client_script 'client/*.lua'

server_script {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}