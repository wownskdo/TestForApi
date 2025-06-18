local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local KEY_LINK = "https://vbfhkc86wxpxyigr.github.io/pandahub.site/"
local FOLDER_NAME = "PandaKey"
local SCRIPT_LINK = "https://gist.githubusercontent.com/wownskdo/3159a28f4549eaf6c563fc5089ee710a/raw/e764168f658ecfdaa99596bf87902c7071e2017e/HaiwibjsiejddJIsiw

-- Key validation from remote source
local KET_GIT = game:HttpGet("https://raw.githubusercontent.com/MADNESSTEST/need/main/new.txt")
local KEY_GIST = game:HttpGet("https://gist.githubusercontent.com/MADNESSTEST/d68fc1ce7ea72159553b21b769a4be1c/raw/"..KET_GIT.."/key")

-- Key validation functions
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

local function loadSavedKey()
    if not isfolder(FOLDER_NAME) then
        makefolder(FOLDER_NAME)
    end
    
    if isfile(FOLDER_NAME .. "/key.txt") then
        local fileContent = readfile(FOLDER_NAME .. "/key.txt")
        local success, data = pcall(function()
            return HttpService:JSONDecode(fileContent)
        end)
        if success then
            return data
        end
    end
    return nil
end

local function saveKeyWithTimestamp(keyText)
    if not isfolder(FOLDER_NAME) then
        makefolder(FOLDER_NAME)
    end
    
    local keyData = {
        text = keyText,
        timestamp = os.time()
    }
    
    local jsonString = HttpService:JSONEncode(keyData)
    writefile(FOLDER_NAME .. "/key.txt", jsonString)
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernKeySystemGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Container Frame (for centering and scaling)
local containerFrame = Instance.new("Frame")
containerFrame.Name = "Container"
containerFrame.Size = UDim2.new(0, 420, 0, 340)
containerFrame.Position = UDim2.new(0.5, -210, 0.5, -170)
containerFrame.BackgroundTransparency = 1
containerFrame.Parent = screenGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = containerFrame

-- Add gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Main frame corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Drop shadow
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "Shadow"
shadowFrame.Size = UDim2.new(1, 10, 1, 10)
shadowFrame.Position = UDim2.new(0, -5, 0, -5)
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.7
shadowFrame.ZIndex = mainFrame.ZIndex - 1
shadowFrame.Parent = containerFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadowFrame

-- Header Frame
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = headerFrame

-- Header gradient
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
}
headerGradient.Rotation = 45
headerGradient.Parent = headerFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 0, 20)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔐 KEY SYSTEM"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- Subtitle
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, -20, 0, 15)
subtitleLabel.Position = UDim2.new(0, 10, 0, 28)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Key resets every 24 hours!"
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
subtitleLabel.TextScaled = true
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = headerFrame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Key Input Container
local inputContainer = Instance.new("Frame")
inputContainer.Name = "InputContainer"
inputContainer.Size = UDim2.new(1, 0, 0, 40)
inputContainer.Position = UDim2.new(0, 0, 0, 10)
inputContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
inputContainer.BorderSizePixel = 0
inputContainer.Parent = contentFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputContainer

-- Key TextBox
local keyTextBox = Instance.new("TextBox")
keyTextBox.Name = "KeyInput"
keyTextBox.Size = UDim2.new(1, -20, 1, -10)
keyTextBox.Position = UDim2.new(0, 10, 0, 5)
keyTextBox.BackgroundTransparency = 1
keyTextBox.PlaceholderText = "Enter your key here..."
keyTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
keyTextBox.Text = ""
keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTextBox.TextScaled = true
keyTextBox.Font = Enum.Font.Gotham
keyTextBox.ClearTextOnFocus = false
keyTextBox.Parent = inputContainer

-- Buttons Container
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Name = "ButtonsContainer"
buttonsContainer.Size = UDim2.new(1, 0, 0, 80)
buttonsContainer.Position = UDim2.new(0, 0, 0, 60)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.Parent = contentFrame

-- Check Key Button
local checkButton = Instance.new("TextButton")
checkButton.Name = "CheckButton"
checkButton.Size = UDim2.new(1, 0, 0, 35)
checkButton.Position = UDim2.new(0, 0, 0, 0)
checkButton.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
checkButton.BorderSizePixel = 0
checkButton.Text = "🔍 VERIFY KEY"
checkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
checkButton.TextScaled = true
checkButton.Font = Enum.Font.GothamBold
checkButton.Parent = buttonsContainer

local checkCorner = Instance.new("UICorner")
checkCorner.CornerRadius = UDim.new(0, 8)
checkCorner.Parent = checkButton

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(1, 0, 0, 35)
getKeyButton.Position = UDim2.new(0, 0, 0, 42)
getKeyButton.BackgroundColor3 = Color3.fromRGB(100, 120, 255)
getKeyButton.BorderSizePixel = 0
getKeyButton.Text = "🔗 GET KEY"
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.TextScaled = true
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = buttonsContainer

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 60)
statusLabel.Position = UDim2.new(0, 0, 0, 150)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "Enter your key to continue..."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.Visible = true
statusLabel.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- Notification System
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "Notification"
notificationFrame.Size = UDim2.new(0, 350, 0, 70)
notificationFrame.Position = UDim2.new(0.5, -175, 0, -100)
notificationFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
notificationFrame.BorderSizePixel = 0
notificationFrame.Visible = false
notificationFrame.ZIndex = 10
notificationFrame.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 14)
notifCorner.Parent = notificationFrame

local notifLabel = Instance.new("TextLabel")
notifLabel.Name = "NotifLabel"
notifLabel.Size = UDim2.new(1, -20, 1, -20)
notifLabel.Position = UDim2.new(0, 10, 0, 10)
notifLabel.BackgroundTransparency = 1
notifLabel.Text = ""
notifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
notifLabel.TextScaled = true
notifLabel.Font = Enum.Font.GothamBold
notifLabel.Parent = notificationFrame

-- Functions
local function showNotification(message, color, icon)
    notifLabel.Text = (icon or "") .. " " .. message
    notificationFrame.BackgroundColor3 = color
    notificationFrame.Visible = true
    
    -- Animate in
    notificationFrame.Position = UDim2.new(0.5, -175, 0, -100)
    local slideIn = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -175, 0, 30)}
    )
    slideIn:Play()
    
    -- Auto hide
    task.wait(3)
    local slideOut = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -175, 0, -100)}
    )
    slideOut:Play()
    slideOut.Completed:Connect(function()
        notificationFrame.Visible = false
    end)
end

local function addButtonEffects(button, normalColor)
    local hoverColor = Color3.new(
        math.min(normalColor.R + 0.1, 1),
        math.min(normalColor.G + 0.1, 1),
        math.min(normalColor.B + 0.1, 1)
    )
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = hoverColor, Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale, button.Size.Y.Offset + 2)}
        )
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {BackgroundColor3 = normalColor, Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale, button.Size.Y.Offset - 2)}
        )
        tween:Play()
    end)
end

-- Add button effects
addButtonEffects(checkButton, Color3.fromRGB(0, 180, 100))
addButtonEffects(getKeyButton, Color3.fromRGB(100, 120, 255))

-- Dragging System (Mobile & PC Compatible)
local dragging = false
local dragStart = nil
local startPos = nil

local function setupDragging(frame)
    local function startDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
end

setupDragging(containerFrame)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        containerFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Check if there's a saved key that's still valid
local savedKeyData = loadSavedKey()
if savedKeyData and isKeyValid(savedKeyData) then
    screenGui:Destroy()
    loadstring(game:HttpGet(SCRIPT_LINK))()
else
    mainFrame.Visible = true
end

-- Button Events
checkButton.MouseButton1Click:Connect(function()
    local enteredKey = keyTextBox.Text:gsub("%s+", "") -- Remove whitespace
    
    if enteredKey == KEY_GIST then
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

        spawn(function()
            showNotification("Key Saved! Valid for 24 hours", Color3.fromRGB(0, 180, 100), "💾")
        end)
        
        statusLabel.Text = "✅ Access Granted! Loading..."
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        task.wait(1.5)
        screenGui:Destroy()
        loadstring(game:HttpGet(SCRIPT_LINK))()
    else
        spawn(function()
            showNotification("Invalid Key! Please try again.", Color3.fromRGB(220, 50, 50), "❌")
        end)
        
        statusLabel.Text = "❌ Invalid key entered. Please check and try again."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Clear text box after error
        task.wait(1)
        keyTextBox.Text = ""
    end
end)

getKeyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(KEY_LINK)
        spawn(function()
            showNotification("Key link copied to clipboard!", Color3.fromRGB(100, 120, 255), "📋")
        end)
    else
        statusLabel.Text = "🔗 Key Link: " .. KEY_LINK
        statusLabel.TextColor3 = Color3.fromRGB(100, 120, 255)
        spawn(function()
            showNotification("Check the status box for the key link!", Color3.fromRGB(100, 120, 255), "📋")
        end)
    end
end)

-- Enter key support
keyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkButton.MouseButton1Click:Fire()
    end
end)
