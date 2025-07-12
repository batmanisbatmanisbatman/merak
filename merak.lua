-- Destroy old GUI if exists
if game.CoreGui:FindFirstChild("merak") then
    game.CoreGui.merak:Destroy()
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "merak"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true

local uicornerMain = Instance.new("UICorner", mainFrame)
uicornerMain.CornerRadius = UDim.new(0, 8)
local uistrokeMain = Instance.new("UIStroke", mainFrame)
uistrokeMain.Thickness = 1
uistrokeMain.Color = Color3.fromRGB(60, 60, 60)

local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(0, 100, 1, 0)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local layout = Instance.new("UIListLayout", tabBar)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local function createTabButton(name)
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Text = name
	btn.Name = name .. "Tab"
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.AutoButtonColor = false
	
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	
	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	end)

	return btn
end

-- Create three tab buttons
local targetTab = createTabButton("Target")
local desyncTab = createTabButton("Desync")
local characterTab = createTabButton("Character")

local function createTabPage(name)
	local page = Instance.new("Frame", mainFrame)
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, -100, 1, 0)
	page.Position = UDim2.new(0, 100, 0, 0)
	page.Visible = false
	page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	
	local corner = Instance.new("UICorner", page)
	corner.CornerRadius = UDim.new(0, 6)
	
	return page
end

local targetPage = createTabPage("Target")
local desyncPage = createTabPage("Desync")
local characterPage = createTabPage("Character")
targetPage.Visible = true -- open by default

local function showTab(page)
	targetPage.Visible = false
	desyncPage.Visible = false
	characterPage.Visible = false
	page.Visible = true
end

targetTab.MouseButton1Click:Connect(function()
	showTab(targetPage)
end)

desyncTab.MouseButton1Click:Connect(function()
	showTab(desyncPage)
end)

characterTab.MouseButton1Click:Connect(function()
	showTab(characterPage)
end)

-- Close button
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.AutoButtonColor = false

local cornerClose = Instance.new("UICorner", closeBtn)
cornerClose.CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
end)
closeBtn.MouseLeave:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- === Character Tab Fly Script (CFrame Fly with speed slider) ===
do
	local flyEnabled = false
	local speed = 50 -- default speed
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	local uis = game:GetService("UserInputService")
	local runService = game:GetService("RunService")
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera

	-- Fly toggle button
	local flyBtn = Instance.new("TextButton", characterPage)
	flyBtn.Size = UDim2.new(0, 200, 0, 40)
	flyBtn.Position = UDim2.new(0, 20, 0, 20)
	flyBtn.Text = "Toggle Fly"
	flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	flyBtn.TextColor3 = Color3.new(1,1,1)
	flyBtn.TextScaled = true
	flyBtn.AutoButtonColor = false
	
	local corner = Instance.new("UICorner", flyBtn)
	corner.CornerRadius = UDim.new(0, 6)

	-- Speed label
	local speedLabel = Instance.new("TextLabel", characterPage)
	speedLabel.Size = UDim2.new(0, 200, 0, 25)
	speedLabel.Position = UDim2.new(0, 20, 0, 70)
	speedLabel.Text = "Fly Speed: " .. speed
	speedLabel.TextColor3 = Color3.new(1,1,1)
	speedLabel.BackgroundTransparency = 1
	speedLabel.TextScaled = true
	speedLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Speed slider background
	local sliderBg = Instance.new("Frame", characterPage)
	sliderBg.Size = UDim2.new(0, 200, 0, 15)
	sliderBg.Position = UDim2.new(0, 20, 0, 100)
	sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	sliderBg.ClipsDescendants = true
	local sliderCorner = Instance.new("UICorner", sliderBg)
	sliderCorner.CornerRadius = UDim.new(0, 6)

	-- Slider fill
	local sliderFill = Instance.new("Frame", sliderBg)
	sliderFill.Size = UDim2.new(speed/150, 0, 1, 0) -- max speed 150
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	local fillCorner = Instance.new("UICorner", sliderFill)
	fillCorner.CornerRadius = UDim.new(0, 6)

	-- Slider button
	local sliderBtn = Instance.new("TextButton", sliderBg)
	sliderBtn.Size = UDim2.new(0, 15, 1, 0)
	sliderBtn.Position = UDim2.new(speed/150 - 0.05, 0, 0, 0)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	sliderBtn.AutoButtonColor = false
	local btnCorner = Instance.new("UICorner", sliderBtn)
	btnCorner.CornerRadius = UDim.new(0, 8)
	sliderBtn.Text = ""

	local dragging = false

	local function updateSlider(inputPosX)
		local relativePos = math.clamp(inputPosX - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
		local percent = relativePos / sliderBg.AbsoluteSize.X
		speed = math.floor(5 + percent * 145) -- speed from 5 to 150
		sliderFill.Size = UDim2.new(percent, 0, 1, 0)
		sliderBtn.Position = UDim2.new(percent - 0.05, 0, 0, 0)
		speedLabel.Text = "Fly Speed: " .. speed
	end

	sliderBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	sliderBtn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateSlider(input.Position.X)
			dragging = true
		end
	end)

	sliderBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	sliderBg.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)

	local velocity = Vector3.new(0,0,0)
	local direction = Vector3.new(0,0,0)

	local connection
	flyBtn.MouseButton1Click:Connect(function()
		flyEnabled = not flyEnabled
		flyBtn.Text = flyEnabled and "Fly Enabled" or "Fly Disabled"
		if flyEnabled then
			character = player.Character or player.CharacterAdded:Wait()
			hrp = character:WaitForChild("HumanoidRootPart")
			cam = workspace.CurrentCamera

			connection = runService.Heartbeat:Connect(function(deltaTime)
				direction = Vector3.new(0,0,0)
				if uis:IsKeyDown(Enum.KeyCode.W) then
					direction = direction + cam.CFrame.LookVector
				end
				if uis:IsKeyDown(Enum.KeyCode.S) then
					direction = direction - cam.CFrame.LookVector
				end
				if uis:IsKeyDown(Enum.KeyCode.A) then
					direction = direction - cam.CFrame.RightVector
				end
				if uis:IsKeyDown(Enum.KeyCode.D) then
					direction = direction + cam.CFrame.RightVector
				end
				if uis:IsKeyDown(Enum.KeyCode.Space) then
					direction = direction + Vector3.new(0,1,0)
				end
				if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
					direction = direction - Vector3.new(0,1,0)
				end
				if direction.Magnitude > 0 then
					direction = direction.Unit
				end
				velocity = direction * speed
				if direction.Magnitude > 0 then
					local newCFrame = hrp.CFrame + velocity * deltaTime
					hrp.CFrame = newCFrame
				end
			end)
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end)
end

-- === Add your Target and Desync tab buttons/features below ===
-- For example, add a dummy button in Target tab:

do
	local btn = Instance.new("TextButton", targetPage)
	btn.Size = UDim2.new(0, 200, 0, 40)
	btn.Position = UDim2.new(0, 20, 0, 20)
	btn.Text = "Example Target Button"
	btn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.AutoButtonColor = false
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function()
		print("Target button clicked!")
	end)
end

-- Dummy button in Desync tab:

do
	local btn = Instance.new("TextButton", desyncPage)
	btn.Size = UDim2.new(0, 200, 0, 40)
	btn.Position = UDim2.new(0, 20, 0, 20)
	btn.Text = "Example Desync Button"
	btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	btn.AutoButtonColor = false
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function()
		print("Desync button clicked!")
	end)
end
