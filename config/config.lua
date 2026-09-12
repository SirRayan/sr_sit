return {
    ---@type string | nil
    ---Specify the language code (e.g., 'en', 'ar').
    ---Leave nil or '' to automatically use ox_lib's default (setr ox:locale in server.cfg).
    ---If neither is specified, it defaults to English ('en').
    Language = 'en',

    ---Enable or disable debug logs in the F8 console
    Debug = false,

    ---Check for script updates on server startup
    CheckForUpdates = true,

    ---Target interaction settings
    Target = {
        icon = 'fa-solid fa-chair',
        distance = 1.5,
    },

    ---TextUI prompt position ('right-center', 'top-center', 'left-center', etc.)
    TextUIPosition = 'right-center',

    ---Default key to stand up from a seat
    DefaultKey = 'X',
}
