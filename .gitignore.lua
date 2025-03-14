local fov = fov or 180;
local Players = game:GetService("Players");
local localPlayer = Players.LocalPlayer;
local rotation = CFrame.Angles(0, math.pi*0.5, 0);

-- สุ่มเลือกชิ้นส่วนของตัวละครเป้าหมาย
local function getRandomPart(character)
    local parts = {}
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    return #parts > 0 and parts[math.random(1, #parts)] or character:FindFirstChild("Head")
end

-- Hook ระบบยิงกระสุน
local old;
old = hookmetamethod(workspace, "__newindex", function(self, index, value) 
    if index == "CFrame" and debug.info(3, "n") == "firebullet" then
        local closest = math.rad(fov);
        local origin, direction = value.Position, value.LookVector;
        for _, player in ipairs(Players:GetPlayers()) do
            local character, team = player.Character, player.Team;
            if character and (not team or team ~= localPlayer.Team) then
                local hitpart = getRandomPart(character)
                if hitpart then
                    local cframe = CFrame.new(origin, hitpart.Position) * rotation;
                    local angle = math.acos(direction:Dot(cframe.LookVector));
                    if angle < closest then
                        value = cframe;
                        closest = angle;
                    end
                end
            end
        end
    end
    old(self, index, value);
end);

-- สร้าง GUI แสดงข้อความ "PaCaWaT silent aim"
local playerGui = localPlayer:FindFirstChild("PlayerGui")
if playerGui then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui

    local label = Instance.new("TextLabel")
    label.Parent = screenGui
    label.Size = UDim2.new(0, 200, 0, 50) -- ขนาด
    label.Position = UDim2.new(0.5, -100, 0.05, 0) -- ตำแหน่งกลางบนจอ
    label.BackgroundTransparency = 0.5 -- โปร่งใส 50%
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- พื้นหลังสีดำ
    label.TextColor3 = Color3.fromRGB(255, 0, 0) -- ข้อความสีแดง
    label.Font = Enum.Font.Code -- ฟอนต์ Code
    label.TextSize = 20
    label.Text = "PaCaWaT silent aim"
end

