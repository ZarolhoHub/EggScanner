--// EGG SCANNER V4
--// Scanner de Eggs + LiveGameConfig
--// Feito para análise client-side

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local GUI_NAME = "EggScannerV4"

pcall(function()
    local old = PlayerGui:FindFirstChild(GUI_NAME)
    if old then
        old:Destroy()
    end
end)

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 650, 0, 500)
Main.Position = UDim2.new(0.5, -325, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "EGG SCANNER V4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -220, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 45)
SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Nome do Egg / dado..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.new(1, 1, 1)
SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = Main

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBox

local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0, 90, 0, 35)
ScanButton.Position = UDim2.new(1, -200, 0, 45)
ScanButton.BackgroundColor3 = Color3.fromRGB(45, 120, 65)
ScanButton.BorderSizePixel = 0
ScanButton.Text = "SCAN"
ScanButton.TextColor3 = Color3.new(1, 1, 1)
ScanButton.TextSize = 13
ScanButton.Font = Enum.Font.GothamBold
ScanButton.Parent = Main

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0, 90, 0, 35)
ClearButton.Position = UDim2.new(1, -100, 0, 45)
ClearButton.BackgroundColor3 = Color3.fromRGB(130, 45, 45)
ClearButton.BorderSizePixel = 0
ClearButton.Text = "APAGAR"
ClearButton.TextColor3 = Color3.new(1, 1, 1)
ClearButton.TextSize = 13
ClearButton.Font = Enum.Font.GothamBold
ClearButton.Parent = Main

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 120, 0, 30)
CopyButton.Position = UDim2.new(0, 10, 1, -40)
CopyButton.BackgroundColor3 = Color3.fromRGB(55, 80, 130)
CopyButton.BorderSizePixel = 0
CopyButton.Text = "COPIAR TUDO"
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.TextSize = 12
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Parent = Main

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 6)
CopyCorner.Parent = CopyButton

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -150, 0, 30)
Status.Position = UDim2.new(0, 140, 1, -40)
Status.BackgroundTransparency = 1
Status.Text = "Pronto."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -130)
Scroll.Position = UDim2.new(0, 10, 0, 90)
Scroll.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Main

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 6)
ScrollCorner.Parent = Scroll

local Output = Instance.new("TextLabel")
Output.Size = UDim2.new(1, -15, 0, 0)
Output.Position = UDim2.new(0, 7, 0, 5)
Output.BackgroundTransparency = 1
Output.TextColor3 = Color3.fromRGB(220, 220, 220)
Output.TextSize = 13
Output.Font = Enum.Font.Code
Output.TextXAlignment = Enum.TextXAlignment.Left
Output.TextYAlignment = Enum.TextYAlignment.Top
Output.TextWrapped = false
Output.Text = ""
Output.Parent = Scroll

--==================================================
-- UTIL
--==================================================

local function safeFullName(obj)
    local ok, result = pcall(function()
        return obj:GetFullName()
    end)

    return ok and result or "?"
end

local function safeValue(obj)
    if not obj:IsA("ValueBase") then
        return nil
    end

    local ok, result = pcall(function()
        return obj.Value
    end)

    if ok then
        return result
    end

    return nil
end

local function formatValue(value)
    if value == nil then
        return "nil"
    end

    if typeof(value) == "string" then
        return string.format("%q", value)
    end

    if typeof(value) == "Vector3" then
        return string.format(
            "Vector3(%s, %s, %s)",
            tostring(value.X),
            tostring(value.Y),
            tostring(value.Z)
        )
    end

    if typeof(value) == "Color3" then
        return string.format(
            "Color3(%s, %s, %s)",
            tostring(value.R),
            tostring(value.G),
            tostring(value.B)
        )
    end

    return tostring(value)
end

local function isMatch(name, search)
    return string.find(
        string.lower(name),
        string.lower(search),
        1,
        true
    ) ~= nil
end

local function append(text)
    Output.Text = Output.Text .. text .. "\n"

    task.defer(function()
        Scroll.CanvasSize = UDim2.new(
            0,
            math.max(Output.TextBounds.X + 20, Scroll.AbsoluteSize.X),
            0,
            Output.TextBounds.Y + 20
        )
    end)
end

local function getAttributes(obj)
    local ok, attrs = pcall(function()
        return obj:GetAttributes()
    end)

    if not ok or next(attrs) == nil then
        return "Nenhum"
    end

    local result = {}

    for name, value in pairs(attrs) do
        table.insert(
            result,
            tostring(name) .. " = " .. formatValue(value)
        )
    end

    table.sort(result)

    return table.concat(result, "\n    ")
end

local function getTags(obj)
    local ok, tags = pcall(function()
        return CollectionService:GetTags(obj)
    end)

    if not ok or #tags == 0 then
        return "Nenhuma"
    end

    table.sort(tags)

    return table.concat(tags, ", ")
end

--==================================================
-- JSON
--==================================================

local HttpService

pcall(function()
    HttpService = game:GetService("HttpService")
end)

local function tryDecodeJSON(value)
    if not HttpService or typeof(value) ~= "string" then
        return nil
    end

    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(value)
    end)

    if ok then
        return decoded
    end

    return nil
end

local function prettyTable(value, indent, lines)
    indent = indent or 0
    lines = lines or {}

    local prefix = string.rep("    ", indent)

    if typeof(value) ~= "table" then
        table.insert(lines, prefix .. formatValue(value))
        return lines
    end

    for key, val in pairs(value) do
        if typeof(val) == "table" then
            table.insert(lines, prefix .. tostring(key) .. " = {")

            prettyTable(val, indent + 1, lines)

            table.insert(lines, prefix .. "}")
        else
            table.insert(
                lines,
                prefix .. tostring(key) .. " = " .. formatValue(val)
            )
        end
    end

    return lines
end

--==================================================
-- OBJECT DETAIL
--==================================================

local function scanObject(obj, index)
    append("")
    append("========================================")
    append("OBJETO #" .. tostring(index))
    append("========================================")

    append("Nome: " .. obj.Name)
    append("Classe: " .. obj.ClassName)
    append("Path: " .. safeFullName(obj))

    -- VALUEBASE
    if obj:IsA("ValueBase") then
        local value = safeValue(obj)

        append("")
        append(">>> VALUE <<<")
        append("Tipo: " .. typeof(value))
        append("Valor: " .. formatValue(value))

        -- tenta interpretar StringValue como JSON
        if typeof(value) == "string" then
            local decoded = tryDecodeJSON(value)

            if decoded then
                append("")
                append(">>> JSON DECODIFICADO <<<")

                local lines = prettyTable(decoded)

                for _, line in ipairs(lines) do
                    append(line)
                end
            end
        end
    end

    -- POSITION
    if obj:IsA("BasePart") then
        append("")
        append(">>> BASEPART <<<")

        append(
            "Position: " ..
            tostring(obj.Position)
        )

        append(
            "Transparency: " ..
            tostring(obj.Transparency)
        )

        append(
            "Anchored: " ..
            tostring(obj.Anchored)
        )

        append(
            "CanCollide: " ..
            tostring(obj.CanCollide)
        )

        append(
            "CanTouch: " ..
            tostring(obj.CanTouch)
        )

        append(
            "CanQuery: " ..
            tostring(obj.CanQuery)
        )
    end

    append("")
    append("Attributes:")
    append("    " .. getAttributes(obj))

    append("")
    append("Tags:")
    append("    " .. getTags(obj))

    -- CHILDREN
    local children = obj:GetChildren()

    if #children > 0 then
        append("")
        append(">>> FILHOS DIRETOS (" .. #children .. ") <<<")

        table.sort(children, function(a, b)
            return a.Name:lower() < b.Name:lower()
        end)

        for _, child in ipairs(children) do
            local extra = ""

            if child:IsA("ValueBase") then
                extra = " | Value=" .. formatValue(safeValue(child))
            elseif child:IsA("ProximityPrompt") then
                extra =
                    " | Enabled=" ..
                    tostring(child.Enabled) ..
                    " | ActionText=" ..
                    tostring(child.ActionText)
            end

            append(
                "    [" ..
                child.ClassName ..
                "] " ..
                child.Name ..
                extra
            )
        end
    else
        append("")
        append("Filhos diretos: Nenhum")
    end

    -- VALUE DESCENDANTS
    local values = {}

    for _, descendant in ipairs(obj:GetDescendants()) do
        if descendant:IsA("ValueBase") then
            table.insert(values, descendant)
        end
    end

    if #values > 0 then
        append("")
        append(">>> VALUES NOS DESCENDENTES (" .. #values .. ") <<<")

        for _, valueObj in ipairs(values) do
            append(
                "    [" ..
                valueObj.ClassName ..
                "] " ..
                safeFullName(valueObj) ..
                " = " ..
                formatValue(safeValue(valueObj))
            )
        end
    end

    -- PROMPTS
    local prompts = {}

    for _, descendant in ipairs(obj:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            table.insert(prompts, descendant)
        end
    end

    if #prompts > 0 then
        append("")
        append(">>> PROXIMITY PROMPTS (" .. #prompts .. ") <<<")

        for _, prompt in ipairs(prompts) do
            append(
                "    " ..
                safeFullName(prompt) ..
                " | Enabled=" ..
                tostring(prompt.Enabled) ..
                " | ActionText=" ..
                tostring(prompt.ActionText) ..
                " | ObjectText=" ..
                tostring(prompt.ObjectText)
            )
        end
    end
end

--==================================================
-- LIVE GAME CONFIG
--==================================================

local function scanLiveGameConfig(search)
    append("")
    append("########################################")
    append("LIVE GAME CONFIG")
    append("########################################")

    local replication =
        ReplicatedStorage:FindFirstChild("Replication")

    if not replication then
        append("Replication não encontrado.")
        return
    end

    local config =
        replication:FindFirstChild("LiveGameConfig")

    if not config then
        append("LiveGameConfig não encontrado.")
        return
    end

    local found = {}

    for _, obj in ipairs(config:GetDescendants()) do
        if obj:IsA("ValueBase") and isMatch(obj.Name, search) then
            table.insert(found, obj)
        end
    end

    -- também verifica o próprio LiveGameConfig
    if config:IsA("ValueBase") and isMatch(config.Name, search) then
        table.insert(found, config)
    end

    append("")
    append("Pesquisa: " .. search)
    append("Valores encontrados: " .. #found)

    if #found == 0 then
        append("Nenhum Value correspondente.")
        return
    end

    for i, obj in ipairs(found) do
        append("")
        append("----------------------------------------")
        append("CONFIG #" .. i)
        append("----------------------------------------")

        append("Nome: " .. obj.Name)
        append("Classe: " .. obj.ClassName)
        append("Path: " .. safeFullName(obj))
        append("Valor: " .. formatValue(safeValue(obj)))

        if typeof(safeValue(obj)) == "string" then
            local decoded = tryDecodeJSON(safeValue(obj))

            if decoded then
                append("")
                append("JSON:")

                local lines = prettyTable(decoded)

                for _, line in ipairs(lines) do
                    append("    " .. line)
                end
            end
        end
    end
end

--==================================================
-- REPLICATED EGGS
--==================================================

local function scanReplicatedEggs(search)
    append("")
    append("########################################")
    append("REPLICATED STORAGE / EGGS")
    append("########################################")

    local eggsFolder =
        ReplicatedStorage:FindFirstChild("Eggs")

    if not eggsFolder then
        append("ReplicatedStorage.Eggs não encontrado.")
        return
    end

    local found = {}

    for _, obj in ipairs(eggsFolder:GetDescendants()) do
        if isMatch(obj.Name, search) then
            table.insert(found, obj)
        end
    end

    append("Encontrados: " .. #found)

    for i, obj in ipairs(found) do
        append(
            "[" ..
            i ..
            "] " ..
            obj.Name ..
            " | " ..
            obj.ClassName ..
            " | " ..
            safeFullName(obj)
        )
    end
end

--==================================================
-- TAG EGG
--==================================================

local function scanEggTags(search)
    append("")
    append("########################################")
    append("OBJETOS COM TAG 'Egg'")
    append("########################################")

    local tagged = CollectionService:GetTagged("Egg")

    append("Quantidade: " .. #tagged)

    local matching = {}

    for _, obj in ipairs(tagged) do
        if isMatch(obj.Name, search) then
            table.insert(matching, obj)
        end
    end

    append("Correspondentes: " .. #matching)

    for i, obj in ipairs(matching) do
        append(
            "[" ..
            i ..
            "] " ..
            obj.Name ..
            " | " ..
            obj.ClassName ..
            " | " ..
            safeFullName(obj)
        )
    end
end

--==================================================
-- SCAN GERAL
--==================================================

local LastOutput = ""

local function performScan()
    local search = SearchBox.Text

    if not search or search:gsub("%s", "") == "" then
        Status.Text = "Digite algo para pesquisar."
        return
    end

    -- limpa resultado anterior automaticamente
    Output.Text = ""
    Scroll.CanvasPosition = Vector2.new(0, 0)

    Status.Text = "Pesquisando..."

    append("########################################")
    append("EGG SCANNER V4")
    append("########################################")
    append("")
    append("Pesquisa: " .. search)

    --==============================================
    -- TODOS OS DESCENDANTS
    --==============================================

    local matches = {}

    for _, obj in ipairs(game:GetDescendants()) do
        if isMatch(obj.Name, search) then
            table.insert(matches, obj)
        end
    end

    append("")
    append("Objetos encontrados: " .. #matches)

    if #matches > 0 then
        append("")
        append("########################################")
        append("RESULTADOS DETALHADOS")
        append("########################################")

        for i, obj in ipairs(matches) do
            scanObject(obj, i)
        end
    end

    --==============================================
    -- EGG TAG
    --==============================================

    scanEggTags(search)

    --==============================================
    -- LIVE GAME CONFIG
    --==============================================

    scanLiveGameConfig(search)

    --==============================================
    -- REPLICATED EGGS
    --==============================================

    scanReplicatedEggs(search)

    --==============================================
    -- FINAL
    --==============================================

    append("")
    append("########################################")
    append("FIM DA PESQUISA")
    append("########################################")

    LastOutput = Output.Text

    Status.Text =
        "Concluído. " ..
        tostring(#matches) ..
        " objetos encontrados."

    task.defer(function()
        Scroll.CanvasPosition = Vector2.new(
            0,
            math.max(0, Scroll.AbsoluteCanvasSize.Y)
        )
    end)
end

--==================================================
-- APAGAR
--==================================================

ClearButton.MouseButton1Click:Connect(function()
    Output.Text = ""
    LastOutput = ""

    Scroll.CanvasPosition = Vector2.new(0, 0)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    Status.Text = "Dados apagados."

    task.wait(0.8)

    Status.Text = "Pronto para nova pesquisa."
end)

--==================================================
-- COPIAR TUDO
--==================================================

CopyButton.MouseButton1Click:Connect(function()
    local text = Output.Text

    if not text or text == "" then
        Status.Text = "Nada para copiar."
        return
    end

    if typeof(setclipboard) == "function" then
        local ok = pcall(function()
            setclipboard(text)
        end)

        if ok then
            Status.Text = "✓ Tudo copiado para a área de transferência!"

            local oldText = CopyButton.Text
            CopyButton.Text = "✓ COPIADO"

            task.wait(1.2)

            CopyButton.Text = oldText
            Status.Text = "Pronto."
        else
            Status.Text = "Erro ao copiar."
        end
    else
        Status.Text = "Seu executor não possui setclipboard()."
    end
end)

--==================================================
-- SCAN
--==================================================

ScanButton.MouseButton1Click:Connect(function()
    task.spawn(performScan)
end)

SearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        task.spawn(performScan)
    end
end)

--==================================================
-- DRAG
--==================================================

local dragging = false
local dragStart
local startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

Status.Text = "Pronto para pesquisar."
