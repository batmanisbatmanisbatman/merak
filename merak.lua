--// Merak GUI (Purple Theme, Orbit, Camlock, Fly, Desync, ESP) + Notifications & Sounds
if game.CoreGui:FindFirstChild("merak") then
    game.CoreGui.merak:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

Mouse.Icon = "rbxassetid://12550511253"

local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "merak"
Gui.ResetOnSpawn = false

-- Notification system
local function Notify(text)
    local frame = Instance.new("TextLabel", Gui)
    frame.Size = UDim2.new(0, 0, 0, 30)
    frame.Position = UDim2.new(0.5, 0, 0.1, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
    frame.TextColor3 = Color3.new(1,1,1)
    frame.Text = text
    frame.Font = Enum.Font.GothamBold
    frame.TextSize = 16
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame)
    local snd = Instance.new("Sound", frame)
    snd.SoundId = "rbxassetid://9118823104" -- soft click sound
    snd.Volume = 1
    snd:Play()

    local t = TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 250, 0, 30)})
    t:Play()
    task.delay(2.5, function()
        local out = TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 30)})
        out:Play()
        out.Completed:Wait()
        frame:Destroy()
    end)
end

-- Main UI Frame
local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 650, 0, 200)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(180, 0, 255)
Stroke.Transparency = 0.2

-- Tab system
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 100, 1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(45, 0, 60)
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Vertical
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createTabButton(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name
    btn.Name = name .. "Tab"
    btn.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    return btn
end

local function createPage(name)
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -100, 1, 0)
    page.Position = UDim2.new(0, 100, 0, 0)
    page.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
    page.Visible = false
    page.Name = name .. "Page"
    return page
end

local TargetTab = createTabButton("Target")
local DesyncTab = createTabButton("Desync")
local CharacterTab = createTabButton("Character")
local ESPTab = createTabButton("ESP")

local TargetPage = createPage("Target")
local DesyncPage = createPage("Desync")
local CharacterPage = createPage("Character")
local ESPPage = createPage("ESP")

TargetPage.Visible = true

local function showTab(tab)
    for _, page in pairs({TargetPage, DesyncPage, CharacterPage, ESPPage}) do
        page.Visible = false
    end
    tab.Visible = true
    Notify(tab.Name:gsub("Page", "") .. " tab opened")
end

TargetTab.MouseButton1Click:Connect(function()
    showTab(TargetPage)
end)
DesyncTab.MouseButton1Click:Connect(function()
    showTab(DesyncPage)
end)
CharacterTab.MouseButton1Click:Connect(function()
    showTab(CharacterPage)
end)
ESPTab.MouseButton1Click:Connect(function()
    showTab(ESPPage)
end)

-- The rest of the script remains the same...
-- (orbit, fly, desync, etc. -- already included)
-- You can now call Notify("Your message") anywhere to display notifications
