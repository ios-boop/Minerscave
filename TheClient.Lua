local plr = game:GetService("Players").LocalPlayer
local Humanoid = plr.Character.Humanoid or plr.CharacterAdded.Humanoid
local OldHealth = Humanoid.Health
local speedDown = false
local RS = game:GetService("RunService")
local speed = 2
local mag = 0
local angle = 0
local dt

RS.Heartbeat:Connect(
    function(detect)
        dt = detect
end)

function KillAura()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Name ~= game:GetService("Players").LocalPlayer.Name then
            if v.Character ~= nil and v.Character:FindFirstChild("Humanoid").Health > 0 then
                if (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 10 then
                    game:GetService("ReplicatedStorage").GameRemotes.Attack:InvokeServer(v.Character)
                end
            end
        end
    end
end

function TargetStrafe()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Name ~= game:GetService("Players").LocalPlayer.Name then
            if v.Character ~= nil and v.Character:FindFirstChild("Humanoid").Health > 0 then
                if (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 80 then
                    local a = v.Character:FindFirstChild("HumanoidRootPart")
                    local b = plr.Character:FindFirstChild("HumanoidRootPart")

                    mag = (a.Position - b.Position).Magnitude
                    angle = (angle + dt * (math.pi * speed)) % (2 * math.pi)
                    b.CFrame = a.CFrame * CFrame.new(math.cos(angle) * mag, 0, math.sin(angle) * mag)
                end
            end
        end
    end
end

function Speed()
    if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid").Health > 0 then
        if (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").MoveDirection).Magnitude > 0 then
            if (game:GetService("Players").LocalPlayer.Character.Humanoid.FloorMaterial == Enum.Material.Air) then
                if not speedDown then
                    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity =
                        Vector3.new(75, 0, 75) *
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector +
                        Vector3.new(0, 35, 0)
                    wait(.1)
                    speedDown = true
                elseif speedDown then
                    game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity =
                        Vector3.new(40, 0, 40) *
                        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector +
                        Vector3.new(0, -30, 0)
                end
            else
                speedDown = false
            end
        end
    end
end

function Sprint()
    if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid").Health > 0 then
        plr.Character:FindFirstChild("Humanoid").WalkSpeed = 20
    end
end

function SpeedMine()
    game:GetService("ReplicatedStorage").GameRemotes.AcceptBreakBlock:InvokeServer()
end

function DamageFly()
    if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid").Health > 0 then
        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(70, 0, 70) * game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector + Vector3.new(0, 70, 0)
    end
end

wait(1)

getgenv().KillAuraW = false
getgenv().SpeedW = false
getgenv().SprintW = false
getgenv().SpeedMineW = false
getgenv().TargetStrafeW = false
getgenv().NoFallW = false
getgenv().DmgFlyW = false
local Damage = false

local features = {
    KillAura,
    Speed,
    Sprint,
    SpeedMine,
    TargetStrafe,
    DamageFly
}

Humanoid:GetPropertyChangedSignal("Health"):Connect(
    function()
        local changedhp = Humanoid.Health - OldHealth
        if Humanoid.Health < OldHealth then
            Damage = true
        end

        OldHealth = Humanoid.Health
        wait(.40)
        Damage = false
    end)

spawn(function()
    while wait() do
        if getgenv().KillAuraW then
            features[1]()
        end
    end
end)
spawn(function()
    while wait() do
        if getgenv().SpeedW then
            features[2]()
        end
    end
end)
spawn(function()
    while wait() do
        if getgenv().SprintW then
            features[3]()
        end
    end
end)
spawn(function()
    while wait() do
        if getgenv().SpeedMineW then
            features[4]()
        end
    end
end)
spawn(function()
    while task.wait() do
        if getgenv().TargetStrafeW and KillAura then
            features[5]()
        end
    end
end)   
spawn(function()
    while wait() do
        if getgenv().DmgFlyW and Damage then
           features[6]()
        end
    end
end)
