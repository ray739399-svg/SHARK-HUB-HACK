-- SHARK HUB | Single Script Edition
-- Roblox Studio > StarterPlayer > StarterPlayerScripts
-- Criado para experiências próprias e testes autorizados.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BLUE = Color3.fromRGB(0, 170, 255)
local BG = Color3.fromRGB(10, 15, 28)
local PANEL = Color3.fromRGB(18, 32, 52)
local WHITE = Color3.fromRGB(240, 247, 255)

local old = playerGui:FindFirstChild("SharkHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "SharkHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(320, 430)
main.Position = UDim2.new(0.5, -160, 0.5, -215)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local outline = Instance.new("UIStroke")
outline.Color = BLUE
outline.Thickness = 1.5
outline.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = PANEL
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "SHARK HUB"
title.TextColor3 = BLUE
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local function button(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = PANEL
    b.TextColor3 = WHITE
    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    b.Parent = parent

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    return b
end

local minimize = button(
    header, "—", UDim2.fromOffset(32, 32),
    UDim2.new(1, -76, 0, 8)
)

local close = button(
    header, "×", UDim2.fromOffset(32, 32),
    UDim2.new(1, -38, 0, 8)
)

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(0, 55)
content.Size = UDim2.new(1, 0, 1, -60)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = BLUE
content.CanvasSize = UDim2.new()
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 12)
padding.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local order = 0

local function section(text)
    order += 1
    local label = Instance.new("TextLabel")
    label.LayoutOrder = order
    label.Size = UDim2.new(1, 0, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = BLUE
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = content
end

local function addButton(text, callback)
    order += 1
    local b = button(
        content, text,
        UDim2.new(1, 0, 0, 37),
        UDim2.new()
    )
    b.LayoutOrder = order
    b.Activated:Connect(callback)
    return b
end

local toast
local function notify(message)
    if toast then toast:Destroy() end

    toast = Instance.new("TextLabel")
    toast.Size = UDim2.fromOffset(260, 36)
    toast.Position = UDim2.new(0.5, -130, 0, 18)
    toast.BackgroundColor3 = PANEL
    toast.TextColor3 = WHITE
    toast.Text = message
    toast.TextSize = 13
    toast.Font = Enum.Font.GothamMedium
    toast.Parent = gui

    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)

    local current = toast
    task.delay(1.6, function()
        if current.Parent then current:Destroy() end
    end)
end

-- Janela arrastável por toque ou mouse
do
    local dragging = false
    local startInput
    local startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startInput
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local minimized = false

minimize.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized

    TweenService:Create(main, TweenInfo.new(0.2), {
        Size = minimized
            and UDim2.fromOffset(320, 48)
            or UDim2.fromOffset(320, 430)
    }):Play()
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- ESTADO DOS MÓDULOS
local espOn = false
local showThroughWalls = false
local highlights = {}
local showCircle = true
local radius = 160

-- ESP visual para depuração
local function clearHighlights()
    for model, highlight in pairs(highlights) do
        highlight:Destroy()
        highlights[model] = nil
    end
end

local function refreshESP()
    for model, highlight in pairs(highlights) do
        if not model.Parent or not espOn then
            highlight:Destroy()
            highlights[model] = nil
        end
    end

    if not espOn then return end

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character
        and not highlights[target.Character] then
            local h = Instance.new("Highlight")
            h.Name = "SharkDebugESP"
            h.Adornee = target.Character
            h.FillColor = BLUE
            h.OutlineColor = WHITE
            h.FillTransparency = 0.8
            h.DepthMode = showThroughWalls
                and Enum.HighlightDepthMode.AlwaysOnTop
                or Enum.HighlightDepthMode.Occluded
            h.Parent = gui
            highlights[target.Character] = h
        end
    end
end

section("VISUAL")

addButton("ESP: OFF", function()
    espOn = not espOn
    refreshESP()
    notify("ESP: " .. (espOn and "ON" or "OFF"))
end).Name = "ESPButton"

local espButton = content:FindFirstChild("ESPButton")
if espButton then
    espButton.Activated:Connect(function()
        espButton.Text = "ESP: " .. (espOn and "ON" or "OFF")
    end)
end

addButton("Alternar visualização através de paredes", function()
    showThroughWalls = not showThroughWalls

    for _, h in pairs(highlights) do
        h.DepthMode = showThroughWalls
            and Enum.HighlightDepthMode.AlwaysOnTop
            or Enum.HighlightDepthMode.Occluded
    end

    notify("Modo de visualização alterado")
end)

-- Círculo de calibração da mira
local circle = Instance.new("Frame")
circle.Name = "AimCalibrationCircle"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.fromScale(0.5, 0.5)
circle.Size = UDim2.fromOffset(radius, radius)
circle.BackgroundTransparency = 1
circle.Parent = gui

Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

local circleLine = Instance.new("UIStroke")
circleLine.Color = BLUE
circleLine.Thickness = 2
circleLine.Parent = circle

section("CÂMERA")

addButton("Círculo: mostrar / ocultar", function()
    showCircle = not showCircle
    circle.Visible = showCircle
end)

addButton("Aumentar círculo", function()
    radius = math.min(500, radius + 20)
    circle.Size = UDim2.fromOffset(radius, radius)
end)

addButton("Diminuir círculo", function()
    radius = math.max(40, radius - 20)
    circle.Size = UDim2.fromOffset(radius, radius)
end)

addButton("Alterar cor do círculo", function()
    circleLine.Color = circleLine.Color == BLUE
        and Color3.fromRGB(0, 255, 170)
        or BLUE
end)

-- FERRAMENTAS DE TESTE
section("FERRAMENTAS")

addButton("Verificar personagem", function()
    local character = player.Character
    local humanoid = character
        and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        notify("Vida: " .. math.floor(humanoid.Health))
    else
        notify("Personagem indisponível")
    end
end)

addButton("Restaurar interface", function()
    radius = 160
    circle.Size = UDim2.fromOffset(radius, radius)
    circle.Visible = true
    showCircle = true
    notify("Preferências visuais restauradas")
end)

-- Atualização limitada do ESP
local elapsed = 0
local connection = game:GetService("RunService").Heartbeat:Connect(function(dt)
    elapsed += dt
    if elapsed >= 0.5 then
        elapsed = 0
        refreshESP()
    end
end)

gui.Destroying:Connect(function()
    connection:Disconnect()
    clearHighlights()
end)

notify("SHARK HUB carregado!")
