--// EGG DIAGNOSTIC V4.1
--// Monitoramento de OpenEgg / onOpenEgg

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local GUI_NAME = "EggDiagnosticV41"

pcall(function()
    local old = pg:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.Parent = pg

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(390, 330)
main.Position = UDim2.new(.5, -195, .5, -165)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,35)
title.Position = UDim2.fromOffset(10,5)
title.BackgroundTransparency = 1
title.Text = "EGG DIAGNOSTIC V4.1"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,22)
status.Position = UDim2.fromOffset(10,38)
status.BackgroundTransparency = 1
status.Text = "Aguardando abertura de Egg..."
status.TextColor3 = Color3.fromRGB(180,180,180)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-105)
scroll.Position = UDim2.fromOffset(10,65)
scroll.BackgroundColor3 = Color3.fromRGB(10,10,10)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.CanvasSize = UDim2.new()
scroll.Parent = main

Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,6)

local output = Instance.new("TextLabel")
output.Size = UDim2.new(1,-12,0,0)
output.Position = UDim2.fromOffset(6,5)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(220,220,220)
output.TextSize = 12
output.Font = Enum.Font.Code
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.TextWrapped = false
output.Text = ""
output.Parent = scroll

local clear = Instance.new("TextButton")
clear.Size = UDim2.fromOffset(105,30)
clear.Position = UDim2.new(0,10,1,-35)
clear.BackgroundColor3 = Color3.fromRGB(130,45,45)
clear.BorderSizePixel = 0
clear.Text = "APAGAR"
clear.TextColor3 = Color3.new(1,1,1)
clear.TextSize = 12
clear.Font = Enum.Font.GothamBold
clear.Parent = main

Instance.new("UICorner", clear).CornerRadius = UDim.new(0,6)

local copy = Instance.new("TextButton")
copy.Size = UDim2.fromOffset(120,30)
copy.Position = UDim2.new(1,-130,1,-35)
copy.BackgroundColor3 = Color3.fromRGB(55,80,130)
copy.BorderSizePixel = 0
copy.Text = "COPIAR TUDO"
copy.TextColor3 = Color3.new(1,1,1)
copy.TextSize = 12
copy.Font = Enum.Font.GothamBold
copy.Parent = main

Instance.new("UICorner", copy).CornerRadius = UDim.new(0,6)

local function add(text)
    output.Text = output.Text .. tostring(text) .. "\n"

    task.defer(function()
        scroll.CanvasSize = UDim2.new(
            0,
            math.max(output.TextBounds.X + 20, scroll.AbsoluteSize.X),
            0,
            output.TextBounds.Y + 15
        )

        scroll.CanvasPosition = Vector2.new(
            0,
            math.max(0, scroll.AbsoluteCanvasSize.Y)
        )
    end)
end

local function format(v, depth)
    depth = depth or 0

    if depth > 5 then
        return "<max depth>"
    end

    local t = typeof(v)

    if t == "string" then
        return string.format("%q", v)
    end

    if t ~= "table" then
        return tostring(v)
    end

    local lines = {"{"}

    for k, value in pairs(v) do
        table.insert(
            lines,
            string.rep("    ", depth + 1) ..
            "[" .. tostring(k) .. "] = " ..
            format(value, depth + 1)
        )
    end

    table.insert(lines, string.rep("    ", depth) .. "}")

    return table.concat(lines, "\n")
end

add("================================")
add("EGG DIAGNOSTIC V4.1")
add("================================")
add("")
add("Alvos:")
add("EggService.RE.onOpenEgg")
add("ItemService.RF.OpenEgg")
add("")
add("Aguardando chamada do jogo...")
add("")

local hooked = false

if typeof(hookmetamethod) == "function"
and typeof(getnamecallmethod) == "function" then

    local oldNamecall

    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()

        local name = ""
        pcall(function()
            name = self.Name
        end)

        local isTarget =
            name == "OpenEgg"
            or name == "onOpenEgg"

        if isTarget then
            local args = {...}

            task.spawn(function()
                add("--------------------------------")
                add("CHAMADA DETECTADA")
                add("Remote: " .. tostring(name))
                add("Classe: " .. tostring(self.ClassName))
                add("Método: " .. tostring(method))
                add("Path: " .. tostring(self:GetFullName()))
                add("Argumentos: " .. tostring(#args))

                for i, value in ipairs(args) do
                    add("")
                    add("ARG #" .. tostring(i))
                    add(format(value))
                end

                add("--------------------------------")
                status.Text = "✓ Chamada detectada: " .. tostring(name)
            end)
        end

        return oldNamecall(self, ...)
    end)

    hooked = true
    status.Text = "✓ Monitoramento ativo"

else
    status.Text = "Executor sem suporte a hookmetamethod"

    add("ERRO:")
    add("Seu executor não possui:")
    add("hookmetamethod/getnamecallmethod")
end

clear.MouseButton1Click:Connect(function()
    output.Text = ""
    scroll.CanvasPosition = Vector2.new(0,0)
    scroll.CanvasSize = UDim2.new()
    status.Text = hooked
        and "Monitoramento ativo"
        or "Monitoramento indisponível"
end)

copy.MouseButton1Click:Connect(function()
    if output.Text == "" then
        status.Text = "Nada para copiar."
        return
    end

    if typeof(setclipboard) ~= "function" then
        status.Text = "setclipboard() indisponível."
        return
    end

    local ok = pcall(function()
        setclipboard(output.Text)
    end)

    if ok then
        local old = copy.Text
        copy.Text = "✓ COPIADO"
        status.Text = "Tudo copiado!"
        task.wait(1)
        copy.Text = old
        status.Text = hooked
            and "Monitoramento ativo"
            or "Monitoramento indisponível"
    else
        status.Text = "Erro ao copiar."
    end
end)

--// Arrastar janela
local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
