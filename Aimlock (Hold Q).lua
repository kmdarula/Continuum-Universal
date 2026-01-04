local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

-- SETTINGS
_G.AimPart = "Head"
_G.HoldKey = Enum.KeyCode.Q
_G.ActivationRange = 80      -- smaller = stricter aim range
_G.Strength = 1             -- 1 = HARD LOCK

local aiming = false
local currentTarget = nil

local moveMouse = mousemoverel
if not moveMouse then
    warn("mousemoverel missing")
end

-- handle holding the aim key
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == _G.HoldKey then
        aiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == _G.HoldKey then
        aiming = false
        currentTarget = nil
    end
end)

-- find the closest target under your crosshair
local function getFrontTarget(mousePos)
    local bestTarget = nil
    local bestDepth = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local part = player.Character:FindFirstChild(_G.AimPart)
            local hum = player.Character:FindFirstChild("Humanoid")

            if part and hum and hum.Health > 0 and part:IsA("BasePart") then
                local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen and pos.Z > 0 then
                    local screenDist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if screenDist <= _G.ActivationRange then
                        if pos.Z < bestDepth then
                            bestDepth = pos.Z
                            bestTarget = player
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

RunService.RenderStepped:Connect(function()
    if not aiming or not moveMouse then return end

    local mousePos = UserInputService:GetMouseLocation()

    -- so i kinda made a lil whoopsie and fucked up the target validation before, this fixes it so we only aim at alive players and don't get stuck on missing parts
    if currentTarget then
        local char = currentTarget.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local part = char and char:FindFirstChild(_G.AimPart)
        if not char or not hum or hum.Health <= 0 or not part then
            currentTarget = nil
        end
    end

    -- acquire a target if we don't have one
    if not currentTarget then
        currentTarget = getFrontTarget(mousePos)
    end

    -- aim the mouse at the current target
    if currentTarget then
        local part = currentTarget.Character[_G.AimPart]
        if part and part:IsA("BasePart") then
            local pos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dx = (pos.X - mousePos.X) * _G.Strength
                local dy = (pos.Y - mousePos.Y) * _G.Strength
                moveMouse(dx, dy)
            end
        end
    end
end)
