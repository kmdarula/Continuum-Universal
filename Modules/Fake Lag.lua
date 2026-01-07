local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local FakeLag = false
local waitTime = 0.05
local delayTime = 0.4
local isPlatformStand = false
local canStandUp = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FakeLagGUI"
ScreenGui.Parent = game.CoreGui

local DraggableButton = Instance.new("TextButton")
DraggableButton.Parent = ScreenGui
DraggableButton.BackgroundColor3 = Color3.new(0, 0, 0)
DraggableButton.Size = UDim2.new(0, 100, 0, 50)
DraggableButton.Position = UDim2.new(0.5, 200, 0.5, -50)
DraggableButton.Text = "FakeLag: OFF"
DraggableButton.TextColor3 = Color3.new(1, 1, 1)
DraggableButton.BorderSizePixel = 0
DraggableButton.Font = Enum.Font.SourceSans
DraggableButton.TextSize = 18
DraggableButton.AutoButtonColor = false
DraggableButton.Active = true
DraggableButton.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = DraggableButton

local TextBoxWait = Instance.new("TextBox")
TextBoxWait.Parent = ScreenGui
TextBoxWait.Size = UDim2.new(0, 100, 0, 30)
TextBoxWait.Position = UDim2.new(0, 0, 0, 0)
TextBoxWait.PlaceholderText = "Wait Time"
TextBoxWait.Text = tostring(waitTime)
TextBoxWait.TextColor3 = Color3.new(1, 1, 1)
TextBoxWait.BackgroundColor3 = Color3.new(0, 0, 0)
TextBoxWait.BackgroundTransparency = 0.5

local TextBoxDelay = Instance.new("TextBox")
TextBoxDelay.Parent = ScreenGui
TextBoxDelay.Size = UDim2.new(0, 100, 0, 30)
TextBoxDelay.Position = UDim2.new(0, 125, 0, 0)
TextBoxDelay.PlaceholderText = "Delay Time"
TextBoxDelay.Text = tostring(delayTime)
TextBoxDelay.TextColor3 = Color3.new(1, 1, 1)
TextBoxDelay.BackgroundColor3 = Color3.new(0, 0, 0)
TextBoxDelay.BackgroundTransparency = 0.5

local FallingButton = Instance.new("TextButton")
FallingButton.Parent = ScreenGui
FallingButton.BackgroundColor3 = Color3.new(0, 0, 0)
FallingButton.Size = UDim2.new(0, 100, 0, 50)
FallingButton.Position = UDim2.new(0.5, 200, 0.5, 0)
FallingButton.Text = "Falling"
FallingButton.TextColor3 = Color3.new(1, 1, 1)
FallingButton.BorderSizePixel = 0
FallingButton.Font = Enum.Font.SourceSans
FallingButton.TextSize = 24
FallingButton.AutoButtonColor = false
FallingButton.Active = true
FallingButton.Draggable = true

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = FallingButton

DraggableButton.MouseButton1Click:Connect(function()
    FakeLag = not FakeLag
    DraggableButton.Text = FakeLag and "FakeLag: ON" or "FakeLag: OFF"
end)

TextBoxWait.FocusLost:Connect(function()
    waitTime = tonumber(TextBoxWait.Text) or waitTime
end)

TextBoxDelay.FocusLost:Connect(function()
    delayTime = tonumber(TextBoxDelay.Text) or delayTime
end)

local function setupCharacter(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    
    RunService.RenderStepped:Connect(function()
        if FakeLag and hrp then
            hrp.Anchored = true
            task.wait(delayTime)
            hrp.Anchored = false
        end
    end)

    FallingButton.MouseButton1Click:Connect(function()
        if hum then
            if not isPlatformStand then
                hum.PlatformStand = true
                hum:Move(Vector3.new(0, -50, 0))
                canStandUp = true
                isPlatformStand = true
            elseif canStandUp then
                hum.PlatformStand = false
                isPlatformStand = false
                canStandUp = false
            end
        end
    end)
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
    setupCharacter(char)
end)

local DestroyButton = Instance.new("TextButton")
DestroyButton.Parent = ScreenGui
DestroyButton.BackgroundColor3 = Color3.new(0, 0, 0)
DestroyButton.Size = UDim2.new(0, 100, 0, 50)
DestroyButton.Position = UDim2.new(0.5, 200, 0.5, 50)
DestroyButton.Text = "Destroy GUI"
DestroyButton.TextColor3 = Color3.new(1, 1, 1)
DestroyButton.BorderSizePixel = 0
DestroyButton.Font = Enum.Font.SourceSans
DestroyButton.TextSize = 24
DestroyButton.AutoButtonColor = false
DestroyButton.Active = true
DestroyButton.Draggable = true

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 10)
UICorner3.Parent = DestroyButton

DestroyButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
