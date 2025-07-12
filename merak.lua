--// Merak GUI Full v1.1 (Neon Purple, Fly + Orbit + Desync + Clone Toggle + Tabs + Sliders + Notifications)
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

-- Main UI Frame (taller & skinnier)
local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 250, 0, 500)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -250)
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
TabBar.Size = UDim2.new(0, 70, 1, 0)
TabBar.BackgroundColor3 = Color3.fromRGB(45, 0, 60)
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Vertical
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createTabButton(name)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Text = name
    btn.Name = name .. "Tab"
    btn.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

local function createPage(name)
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -70, 1, 0)
    page.Position = UDim2.new(0, 70, 0, 0)
    page.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
    page.Visible = false
    page.Name = name .. "Page"
    local corner = Instance.new("UICorner", page)
    corner.CornerRadius = UDim.new(0, 8)
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

-- Slider helper
local function CreateSlider(parent, labelText, min, max, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 50)
    container.Position = UDim2.new(0, 10, 0, 0)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = labelText .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderFrame = Instance.new("Frame", container)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.Size = UDim2.new(1, 0, 0, 20)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 110)
    sliderFrame.ClipsDescendants = true
    local uicorner = Instance.new("UICorner", sliderFrame)
    uicorner.CornerRadius = UDim.new(0, 8)

    local sliderFill = Instance.new("Frame", sliderFrame)
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(0, 8)

    local sliderButton = Instance.new("TextButton", sliderFrame)
    sliderButton.Size = UDim2.new(0, 16, 1, 0)
    sliderButton.Position = UDim2.new(sliderFill.Size.X.Scale, 0, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    sliderButton.AutoButtonColor = false
    sliderButton.Text = ""
    local btnCorner = Instance.new("UICorner", sliderButton)
    btnCorner.CornerRadius = UDim.new(0, 8)

    local dragging = false
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    sliderFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local relativeX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local scale = relativeX / sliderFrame.AbsoluteSize.X
            sliderFill.Size = UDim2.new(scale, 0, 1, 0)
            sliderButton.Position = UDim2.new(scale, 0, 0, 0)
            local value = min + (max - min) * scale
            label.Text = string.format("%s: %.2f", labelText, value)
            callback(value)
        end
    end)

    return container
end

-- Target tab contents
local flySpeed = 1.5
local orbitSpeed = 10

local flyToggle = Instance.new("TextButton", TargetPage)
flyToggle.Size = UDim2.new(0, 100, 0, 30)
flyToggle.Position = UDim2.new(0, 10, 0, 40)
flyToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
flyToggle.TextColor3 = Color3.new(1,1,1)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 18
flyToggle.Text = "Fly: OFF"
flyToggle.AutoButtonColor = false
local flyCorner = Instance.new("UICorner", flyToggle)
flyCorner.CornerRadius = UDim.new(0, 8)

local flying = false
local flyConn

flyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    flyToggle.Text = "Fly: " .. (flying and "ON" or "OFF")
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flying then
        flyConn = RunService:BindToRenderStep("fly", Enum.RenderPriority.Input.Value, function()
            local direction = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += Camera.CFrame.RightVector end
            if direction.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + direction.Unit * flySpeed
            end
        end)
    else
        if flyConn then
            RunService:UnbindFromRenderStep("fly")
            flyConn = nil
        end
    end
end)

local flySlider = CreateSlider(TargetPage, "Fly Speed", 0.5, 5, flySpeed, function(value)
    flySpeed = value
end)
flySlider.Position = UDim2.new(0, 10, 0, 80)

local orbitToggle = Instance.new("TextButton", TargetPage)
orbitToggle.Size = UDim2.new(0, 100, 0, 30)
orbitToggle.Position = UDim2.new(0, 10, 0, 130)
orbitToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
orbitToggle.TextColor3 = Color3.new(1,1,1)
orbitToggle.Font = Enum.Font.GothamBold
orbitToggle.TextSize = 18
orbitToggle.Text = "Orbit: OFF"
orbitToggle.AutoButtonColor = false
local orbitCorner = Instance.new("UICorner", orbitToggle)
orbitCorner.CornerRadius = UDim.new(0, 8)

local orbitEnabled = false
local orbitConn

orbitToggle.MouseButton1Click:Connect(function()
    orbitEnabled = not orbitEnabled
    orbitToggle.Text = "Orbit: " .. (orbitEnabled and "ON" or "OFF")
    if orbitConn then orbitConn:Disconnect() orbitConn = nil end
    if orbitEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- find first other player
        local target = nil
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                target = plr
                break
            end
        end
        if not target then
            Notify("No valid target found for orbit!")
            orbitEnabled = false
            orbitToggle.Text = "Orbit: OFF"
            return
        end
        local TargetHRP = target.Character.HumanoidRootPart
        local angle = 0
        local radius = 7
        orbitConn = RunService.Heartbeat:Connect(function(dt)
            angle += dt * orbitSpeed
            local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            hrp.CFrame = CFrame.new(TargetHRP.Position + offset, TargetHRP.Position)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetHRP.Position + Vector3.new(0,1,0))
        end)
    end
end)

local orbitSpeedSlider = CreateSlider(TargetPage, "Orbit Speed", 1, 30, orbitSpeed, function(value)
    orbitSpeed = value
end)
orbitSpeedSlider.Position = UDim2.new(0, 10, 0, 170)

-- Desync tab contents
local desyncToggle = Instance.new("TextButton", DesyncPage)
desyncToggle.Size = UDim2.new(0, 150, 0, 40)
desyncToggle.Position = UDim2.new(0, 40, 0, 40)
desyncToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
desyncToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
desyncToggle.TextScaled = true
desyncToggle.Text = "Toggle Desync"
desyncToggle.AutoButtonColor = false
local desyncCorner = Instance.new("UICorner", desyncToggle)
desyncCorner.CornerRadius = UDim.new(0, 10)

local desyncing = false
local clone
local heartbeatConn
local cloneExists = false

desyncToggle.MouseButton1Click:Connect(function()
    desyncing = not desyncing
    Notify("Desync: " .. (desyncing and "Enabled" or "Disabled"))
    if desyncing then
        local char = LocalPlayer.Character
        if not char then Notify("Character not found!") return end
        clone = char:Clone()
        clone.Parent = workspace
        for _, v in ipairs(clone:GetDescendants()) do
            if v:IsA("BasePart") then v.Anchored = true end
        end
        cloneExists = true
        local root = char:FindFirstChild("HumanoidRootPart")
        local tickVal = 0
        heartbeatConn = RunService.Heartbeat:Connect(function(dt)
            if not desyncing then
                if clone then clone:Destroy() clone = nil end
                cloneExists = false
                heartbeatConn:Disconnect()
                heartbeatConn = nil
                return
            end
            tickVal += dt
            if root then
                root.CFrame = CFrame.new(0, 5000 + math.sin(tickVal*10)*5, 0) + Vector3.new(math.sin(tickVal)*500, 0, math.cos(tickVal)*500)
            end
        end)
    else
        if clone then
            clone:Destroy()
            clone = nil
        end
        cloneExists = false
        if heartbeatConn then
            heartbeatConn:Disconnect()
            heartbeatConn = nil
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X and desyncing then
        if cloneExists and clone then
            clone:Destroy()
            clone = nil
            cloneExists = false
            Notify("Desync Clone Removed — You see your real character in the sky")
        elseif not cloneExists and desyncing then
            local char = LocalPlayer.Character
            if not char then return end
            clone = char:Clone()
            clone.Parent = workspace
            for _, v in ipairs(clone:GetDescendants()) do
                if v:IsA("BasePart") then v.Anchored = true end
            end
            cloneExists = true
            Notify("Desync Clone Created — Clone back on the ground")
        end
    end
end)

-- Character tab fly (simple cframe fly)
local charFlyToggle = Instance.new("TextButton", CharacterPage)
charFlyToggle.Size = UDim2.new(0, 100, 0, 30)
charFlyToggle.Position = UDim2.new(0, 10, 0, 40)
charFlyToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
charFlyToggle.TextColor3 = Color3.new(1,1,1)
charFlyToggle.Font = Enum.Font.GothamBold
charFlyToggle.TextSize = 18
charFlyToggle.Text = "Fly: OFF"
charFlyToggle.AutoButtonColor = false
local charFlyCorner = Instance.new("UICorner", charFlyToggle)
charFlyCorner.CornerRadius = UDim.new(0, 8)

local charFlying = false
local charFlyConn

charFlyToggle.MouseButton1Click:Connect(function()
    charFlying = not charFlying
    charFlyToggle.Text = "Fly: " .. (charFlying and "ON" or "OFF")
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if charFlying then
        charFlyConn = RunService:BindToRenderStep("charFly", Enum.RenderPriority.Input.Value, function()
            local direction = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += Camera.CFrame.RightVector end
            if direction.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + direction.Unit * 2
            end
        end)
    else
        if charFlyConn then
            RunService:UnbindFromRenderStep("charFly")
            charFlyConn = nil
        end
    end
end)

-- ESP tab placeholder
local espLabel = Instance.new("TextLabel", ESPPage)
espLabel.Text = "ESP features coming soon..."
espLabel.Size = UDim2.new(1, -20, 0, 30)
espLabel.Position = UDim2.new(0, 10, 0, 10)
espLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
espLabel.BackgroundTransparency = 1
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 18
espLabel.TextWrapped = true

-- Close GUI with RightShift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Gui.Enabled then
            Gui.Enabled = false
            Notify("Merak GUI Closed")
        else
            Gui.Enabled = true
            Notify("Merak GUI Opened")
        end
    end
end)
