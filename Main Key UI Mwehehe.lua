local themes = {
    Aqua = {
        FrameColor = Color3.fromRGB(35, 168, 255),
        BorderColor = Color3.fromRGB(0, 120, 215),
        ButtonColor = Color3.fromRGB(0, 120, 215),
        ButtonTextColor = Color3.fromRGB(255, 255, 255),
        TextBoxColor = Color3.fromRGB(35, 168, 255),
        NotificationColor = Color3.fromRGB(35, 168, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
    Christmas = {
        FrameColor = Color3.fromRGB(0, 128, 0),
        BorderColor = Color3.fromRGB(255, 255, 255),
        ButtonColor = Color3.fromRGB(255, 0, 0),
        ButtonTextColor = Color3.fromRGB(255, 255, 255),
        TextBoxColor = Color3.fromRGB(255, 255, 255),
        NotificationColor = Color3.fromRGB(255, 0, 0),
        TextColor = Color3.fromRGB(0, 0, 0),
    },
    Halloween = {
        FrameColor = Color3.fromRGB(34, 34, 34),
        BorderColor = Color3.fromRGB(255, 85, 0),
        ButtonColor = Color3.fromRGB(255, 85, 0),
        ButtonTextColor = Color3.fromRGB(255, 255, 255),
        TextBoxColor = Color3.fromRGB(60, 60, 60),
        NotificationColor = Color3.fromRGB(255, 85, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
    Simple = {
        FrameColor = Color3.fromRGB(230, 230, 230),
        BorderColor = Color3.fromRGB(100, 100, 100),
        ButtonColor = Color3.fromRGB(200, 200, 200),
        ButtonTextColor = Color3.fromRGB(50, 50, 50),
        TextBoxColor = Color3.fromRGB(240, 240, 240),
        NotificationColor = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(50, 50, 50),
    }
}

local function createUI(name, scripturl, allowedPlayersUrl, foldername, notificationname, getkey, theme)
    -- Check if player is in allowed list first
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local Allowed = loadstring(game:HttpGet(allowedPlayersUrl, true))()
    
    -- If player is allowed, skip key system entirely
    for _, allowedPlayer in pairs(Allowed) do
        if localPlayer.Name == allowedPlayer or localPlayer.UserId == allowedPlayer then
            loadstring(game:HttpGet(scripturl, true))()
            return
        end
    end

    -- Define theme colors
    local selectedTheme = themes[theme] or themes["Aqua"]
    local FrameColor = selectedTheme.FrameColor
    local BorderColor = selectedTheme.BorderColor
    local ButtonColor = selectedTheme.ButtonColor
    local ButtonTextColor = selectedTheme.ButtonTextColor
    local TextBoxColor = selectedTheme.TextBoxColor
    local NotificationColor = selectedTheme.NotificationColor
    local TextColor = selectedTheme.TextColor

    -- Create UI elements with theme colors
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 230)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = FrameColor
    frame.BorderSizePixel = 2
    frame.BorderColor3 = BorderColor
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = name
    title.TextSize = 30
    title.Font = Enum.Font.GothamSemibold
    title.TextColor3 = TextColor
    title.BackgroundTransparency = 1
    title.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -40, 0, 60)
    textBox.Position = UDim2.new(0, 20, 0, 80)
    textBox.Text = ""
    textBox.PlaceholderText = "Enter key here"
    textBox.TextSize = 40
    textBox.Font = Enum.Font.Gotham
    textBox.TextColor3 = TextColor
    textBox.BackgroundColor3 = TextBoxColor
    textBox.BorderSizePixel = 2
    textBox.BorderColor3 = BorderColor
    textBox.Parent = frame

    local leftButton = Instance.new("TextButton")
    leftButton.Size = UDim2.new(0.5, -20, 0, 60)
    leftButton.Position = UDim2.new(0, 10, 0, 160)
    leftButton.Text = "Get Key"
    leftButton.TextSize = 30
    leftButton.Font = Enum.Font.GothamSemibold
    leftButton.TextColor3 = ButtonTextColor
    leftButton.BackgroundColor3 = ButtonColor
    leftButton.BorderSizePixel = 2
    leftButton.BorderColor3 = BorderColor
    leftButton.Parent = frame

    local rightButton = Instance.new("TextButton")
    rightButton.Size = UDim2.new(0.5, -20, 0, 60)
    rightButton.Position = UDim2.new(0.5, 10, 0, 160)
    rightButton.Text = "Submit"
    rightButton.TextSize = 30
    rightButton.Font = Enum.Font.GothamSemibold
    rightButton.TextColor3 = ButtonTextColor
    rightButton.BackgroundColor3 = ButtonColor
    rightButton.BorderSizePixel = 2
    rightButton.BorderColor3 = BorderColor
    rightButton.Parent = frame

    local paste = game:HttpGet("https://gist.githubusercontent.com/MADNESSTEST/d68fc1ce7ea72159553b21b769a4be1c/raw/"..keygetter.."/key")
    local maxAttempts = 3
    local attempts = 0

    -- Function to check if key is still valid (within 24 hours)
    local function isKeyValid(savedData)
        if not savedData or not savedData.timestamp then
            return false
        end
        
        local currentTime = os.time()
        local savedTime = savedData.timestamp
        local timeDifference = currentTime - savedTime
        
        -- 24 hours = 86400 seconds
        return timeDifference < 86400
    end

    -- Function to load saved key data
    local function loadSavedKey()
        if not isfolder(foldername) then
            makefolder(foldername)
        end
        
        if isfile(foldername .. "/key.txt") then
            local fileContent = readfile(foldername .. "/key.txt")
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(fileContent)
            end)
            if success then
                return data
            end
        end
        return nil
    end

    -- Function to save key with timestamp
    local function saveKeyWithTimestamp(keyText)
        if not isfolder(foldername) then
            makefolder(foldername)
        end
        
        local keyData = {
            text = keyText,
            timestamp = os.time()
        }
        
        local jsonString = game:GetService("HttpService"):JSONEncode(keyData)
        writefile(foldername .. "/key.txt", jsonString)
    end

    -- Check if there's a saved key that's still valid
    local savedKeyData = loadSavedKey()
    if savedKeyData and isKeyValid(savedKeyData) then
        -- Key is still valid, auto-login
        screenGui:Destroy()
        loadstring(game:HttpGet(scripturl, true))()
        return
    end

    rightButton.MouseButton1Click:Connect(function()
        local enteredKey = textBox.Text
        
        if enteredKey == paste then
            -- Check if this is a new key (different from saved one)
            local shouldSave = true
            if savedKeyData and savedKeyData.text == enteredKey then
                -- Same key as saved, don't reset the timer
                shouldSave = false
            end
            
            -- Only save if it's a new/different key
            if shouldSave then
                saveKeyWithTimestamp(enteredKey)
            end
            
            screenGui:Destroy()
            loadstring(game:HttpGet(scripturl, true))()
        else
            attempts = attempts + 1
            textBox.Text = ""
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Wrong Key!",
                Text = "Attempts: " .. attempts .. "/" .. maxAttempts,
                Duration = 3,
            })
            if attempts >= maxAttempts then
                game.Players.LocalPlayer:Kick("Are you tired of obtaining the key repeatedly? You can purchase permanent access by sending a direct message to Panda Exploits on Discord: https://discord.com/invite/B3CeTvU7vv")
            end
        end
    end)

    leftButton.MouseButton1Click:Connect(function()
        setclipboard(getkey)
        textBox.Text = getkey
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Link Copied!",
            Text = "Paste the URL into any website",
            Duration = 3,
        })
    end)
    
    return screenGui
end

return createUI
