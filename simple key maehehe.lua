-- Key System by: PandaExploits
-- Load the UI script
local createUI = loadstring(game:HttpGet("https://github.com/wownskdo/Simple-Key-UI/raw/refs/heads/main/Main%20Key%20UI"))()

-- Name of the script
local name = "Auto Piano v3.5.1: Key System"

-- Main script URL (must be a raw URL)
local scripturl = "https://github.com/wownskdo/Simple-Key-UI/raw/refs/heads/main/Choose%20Script"

-- URL for premium players (must be a raw URL)
local allowedPlayersUrl = "https://github.com/wownskdo/Simple-Key-UI/raw/refs/heads/main/Premium%20Players"

-- Folder Name for saving the key in the executor workspace
local foldername = "PandaHub"

-- Notification name
local notificationname = "Panda Hub"

-- The website where the user can obtain the key
local getkey = "https://vbfhkc86wxpxyigr.github.io/pandahub.site/"

-- Determine theme based on date
local currentDate = os.date("*t")
local theme
if (currentDate.month >= 3 and currentDate.month <= 5) or (currentDate.month == 3 and currentDate.day >= 1) or (currentDate.month == 5 and currentDate.day <= 31) then
    theme = "Simple"
elseif (currentDate.month >= 6 and currentDate.month <= 8) or (currentDate.month == 6 and currentDate.day >= 1) or (currentDate.month == 8 and currentDate.day <= 31) then
    theme = "Aqua"
elseif (currentDate.month >= 9 and currentDate.month <= 11) or (currentDate.month == 9 and currentDate.day >= 1) or (currentDate.month == 11 and currentDate.day <= 30) then
    theme = "Autumn"
else -- December to February
    theme = "Christmas"
end

-- Call the createUI function with the defined parameters
createUI(name, scripturl, allowedPlayersUrl, foldername, notificationname, getkey, theme)
