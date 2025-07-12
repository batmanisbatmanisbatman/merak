--// Merak GUI (Purple Theme, Orbit, Camlock, Fly, Desync, ESP)
if game.CoreGui:FindFirstChild("merak") then
    game.CoreGui.merak:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

Mouse.Icon = "rbxassetid://12550511253" -- custom purple cursor

local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "merak"
Gui.ResetOnSpawn = false

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

-- Target Orbit
local Input = Instance.new("TextBox", TargetPage)
Input.PlaceholderText = "Enter player name..."
Input.Size = UDim2.new(0, 300, 0, 40)
Input.Position = UDim2.new(0, 120, 0, 30)
Input.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextScaled = true
Instance.new("UICorner", Input)

local Button = Instance.new("TextButton", TargetPage)
Button.Size = UDim2.new(0, 300, 0, 40)
Button.Position = UDim2.new(0, 120, 0, 90)
Button.Text = "Orbit + Camlock"
Button.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Instance.new("UICorner", Button)

Button.MouseButton1Click:Connect(function()
    local name = Input.Text
    local target = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if string.lower(plr.Name):sub(1, #name) == string.lower(name) and plr ~= LocalPlayer then
            target = plr
            break
        end
    end
    if not target then warn("Player not found") return end
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local TargetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not HRP or not TargetHRP then return end
    local angle = 0
    local radius = 7
    local speed = 10
    local cam = workspace.CurrentCamera
    local Orbiting = true
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not Orbiting or not TargetHRP or not HRP then connection:Disconnect() return end
        angle = angle + dt * speed
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        HRP.CFrame = CFrame.new(TargetHRP.Position + offset, TargetHRP.Position)
        cam.CFrame = CFrame.new(cam.CFrame.Position, TargetHRP.Position + Vector3.new(0,1,0))
    end)
end)

-- Character Fly
local FlyBtn = Instance.new("TextButton", CharacterPage)
FlyBtn.Size = UDim2.new(0, 200, 0, 40)
FlyBtn.Position = UDim2.new(0, 120, 0, 40)
FlyBtn.Text = "Toggle Fly (F)"
FlyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.TextScaled = true
Instance.new("UICorner", FlyBtn)

local flying = false
local flyspeed = 2
local float
local vel
local function Fly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    float = Instance.new("BodyPosition")
    float.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    float.P = 10000
    float.Position = hrp.Position + Vector3.new(0,2,0)
    float.Parent = hrp
    vel = Instance.new("BodyVelocity")
    vel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    vel.Velocity = Vector3.zero
    vel.Parent = hrp
    RunService.Heartbeat:Connect(function()
        if not flying then return end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        vel.Velocity = dir.Unit * flyspeed * 10
        float.Position = hrp.Position + Vector3.new(0, 2, 0)
    end)
end

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then Fly() else if float then float:Destroy() end if vel then vel:Destroy() end end
end)

-- Desync Tab
local DesyncBtn = Instance.new("TextButton", DesyncPage)
DesyncBtn.Size = UDim2.new(0, 300, 0, 40)
DesyncBtn.Position = UDim2.new(0, 120, 0, 40)
DesyncBtn.Text = "Toggle Desync (G)"
DesyncBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
DesyncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DesyncBtn.TextScaled = true
Instance.new("UICorner", DesyncBtn)

local desyncing = false
DesyncBtn.MouseButton1Click:Connect(function()
    desyncing = not desyncing
    local clone
    if desyncing then
        local char = LocalPlayer.Character
        if not char then return end
        clone = char:Clone()
        clone.Parent = workspace
        for _, v in ipairs(clone:GetDescendants()) do
            if v:IsA("BasePart") then v.Anchored = true end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local tickVal = 0
        RunService.Heartbeat:Connect(function(dt)
            if not desyncing then clone:Destroy() return end
            tickVal += dt
            if root then
                root.CFrame = CFrame.new(0, -4999, 0) + Vector3.new(math.random(-500,500), 0, math.random(-500,500))
            end
        end)
    else
        if workspace:FindFirstChild(clone.Name) then
            clone:Destroy()
        end
    end
end)

-- RightShift to hide GUI
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Gui.Enabled = not Gui.Enabled
    end
end)
