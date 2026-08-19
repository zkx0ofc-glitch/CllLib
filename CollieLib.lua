--[[
    COLLIELIB v2.0 - ULTIMATE REDESIGN 🐾✨
    Style: Soft Pastel Dark/Light Blue (No Text Outlines)
    Features: Interactive Trail Effects, Custom Config Manager & Smooth Animations
--]]

local CollieLib = {}
CollieLib.__index = CollieLib

-- Serviços do Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- PALETA DE CORES FOFA (AZUL PASTEL & ESCURO)
local THEME = {
    Background = Color3.fromRGB(18, 24, 38),       -- Azul Noturno Profundo
    Card = Color3.fromRGB(28, 38, 58),             -- Azul Escuro Suave
    CardHover = Color3.fromRGB(36, 48, 72),        -- Card em Foco
    Accent = Color3.fromRGB(92, 180, 255),         -- Azul Pastel Vibrante
    AccentSecondary = Color3.fromRGB(125, 230, 255),-- Ciano Claro Fofo
    TextMain = Color3.fromRGB(240, 246, 255),      -- Texto Principal
    TextSub = Color3.fromRGB(140, 165, 200),       -- Texto Secundário
    Success = Color3.fromRGB(120, 220, 180),       -- Verde Pastel
    Disabled = Color3.fromRGB(50, 60, 80)          -- Desativado
}

-- BANCO DE DADOS DE CONFIGURAÇÕES (SISTEMA DE PROFILES)
CollieLib.Flags = {}
CollieLib.ConfigFolder = "CollieLib_Configs"

-- Garantir que a pasta de configs exista localmente
if writefile and isfolder and not isfolder(CollieLib.ConfigFolder) then
    makefolder(CollieLib.ConfigFolder)
end

-- HELPER: Tween Rápido
local function Tween(instance, info, properties)
    local tween = TweenService:Create(instance, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

-- HELPER: Cantos Arredondados Fofos
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 18)
    corner.Parent = parent
    return corner
end

-- HELPER: Gradiente Azul
local function AddBlueGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.Accent),
        ColorSequenceKeypoint.new(1, THEME.AccentSecondary)
    })
    gradient.Rotation = 45
    gradient.Parent = parent
    return gradient
end

---------------------------------------------------------
-- EFEITO INTERATIVO DE TRILHA DE MOUSE (BUBBLE TRAIL)
---------------------------------------------------------
local function SpawnMouseParticle(container)
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(6, 12), 0, math.random(6, 12))
    particle.Position = UDim2.new(0, Mouse.X - container.AbsolutePosition.X + math.random(-5, 5), 0, Mouse.Y - container.AbsolutePosition.Y + math.random(-5, 5))
    particle.BackgroundColor3 = THEME.AccentSecondary
    particle.BackgroundTransparency = 0.3
    particle.ZIndex = 100
    particle.Parent = container
    AddCorner(particle, 20)

    local targetSize = particle.Size.X.Offset * 1.8
    local tween = Tween(particle, {0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {
        Size = UDim2.new(0, targetSize, 0, targetSize),
        BackgroundTransparency = 1,
        Position = particle.Position + UDim2.new(0, math.random(-15, 15), 0, math.random(-20, -5))
    })

    tween.Completed:Connect(function()
        particle:Destroy()
    end)
end

---------------------------------------------------------
-- SISTEMA DE NOTIFICAÇÕES FOFEIRAS
---------------------------------------------------------
local NotificationGui
local NotificationContainer

local function InitNotifications()
    if not NotificationGui then
        NotificationGui = Instance.new("ScreenGui")
        NotificationGui.Name = "CollieNotifications_v2"
        NotificationGui.ResetOnSpawn = false
        pcall(function() NotificationGui.Parent = CoreGui end)
        if not NotificationGui.Parent then NotificationGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

        NotificationContainer = Instance.new("Frame")
        NotificationContainer.Size = UDim2.new(0, 260, 1, -20)
        NotificationContainer.Position = UDim2.new(1, -270, 0, 10)
        NotificationContainer.BackgroundTransparency = 1
        NotificationContainer.Parent = NotificationGui

        local layout = Instance.new("UIListLayout")
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.Parent = NotificationContainer
    end
end

function CollieLib:Notify(config)
    config = config or {}
    InitNotifications()

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 58)
    card.BackgroundColor3 = THEME.Card
    card.Position = UDim2.new(1, 300, 0, 0)
    card.Parent = NotificationContainer
    AddCorner(card, 16)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 5, 0.6, 0)
    bar.Position = UDim2.new(0, 10, 0.2, 0)
    bar.BackgroundColor3 = THEME.Accent
    bar.Parent = card
    AddCorner(bar, 10)

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Collie Notification 🐾"
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 13
    title.TextColor3 = THEME.AccentSecondary
    title.Position = UDim2.new(0, 24, 0, 10)
    title.Size = UDim2.new(1, -30, 0, 16)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = card

    local content = Instance.new("TextLabel")
    content.Text = config.Content or ""
    content.Font = Enum.Font.GothamMedium
    content.TextSize = 11
    content.TextColor3 = THEME.TextMain
    content.Position = UDim2.new(0, 24, 0, 28)
    content.Size = UDim2.new(1, -30, 0, 20)
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.BackgroundTransparency = 1
    content.Parent = card

    Tween(card, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 0, 0, 0)})

    task.delay(config.Duration or 3, function()
        local tw = Tween(card, {0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In}, {Position = UDim2.new(1, 300, 0, 0)})
        tw.Completed:Connect(function() card:Destroy() end)
    end)
end

---------------------------------------------------------
-- JANELA PRINCIPAL (MAIN WINDOW)
---------------------------------------------------------
function CollieLib:CreateWindow(config)
    config = config or {}
    local TitleText = config.Title or "Collie Hub"
    local SubTitleText = config.SubTitle or "v2.0 Soft Blue Edition 🐾"
    local ToggleKey = config.ToggleKey or Enum.KeyCode.LeftControl

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CollieHub_v2"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 750, 0, 460)
    MainFrame.Position = UDim2.new(0.5, -375, 0.5, -230)
    MainFrame.BackgroundColor3 = THEME.Background
    MainFrame.Active = true
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 22)

    -- Trilha do Mouse na Interface
    local lastParticle = 0
    MainFrame.MouseMovement:Connect(function()
        if tick() - lastParticle > 0.04 then
            lastParticle = tick()
            SpawnMouseParticle(MainFrame)
        end
    end)

    -- Sistema de Arrastar (Drag System)
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Atalho para Ocultar/Exibir
    local IsVisible = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == ToggleKey then
            IsVisible = not IsVisible
            MainFrame.Visible = IsVisible
        end
    end)

    -- BARRA LATERAL (SIDEBAR)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 190, 1, 0)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local LogoTitle = Instance.new("TextLabel")
    LogoTitle.Text = "🐾 " .. TitleText
    LogoTitle.Font = Enum.Font.FredokaOne
    LogoTitle.TextSize = 18
    LogoTitle.TextColor3 = THEME.AccentSecondary
    LogoTitle.Position = UDim2.new(0, 20, 0, 22)
    LogoTitle.Size = UDim2.new(1, -20, 0, 22)
    LogoTitle.TextXAlignment = Enum.TextXAlignment.Left
    LogoTitle.BackgroundTransparency = 1
    LogoTitle.Parent = Sidebar

    local LogoSub = Instance.new("TextLabel")
    LogoSub.Text = SubTitleText
    LogoSub.Font = Enum.Font.GothamMedium
    LogoSub.TextSize = 11
    LogoSub.TextColor3 = THEME.TextSub
    LogoSub.Position = UDim2.new(0, 20, 0, 44)
    LogoSub.Size = UDim2.new(1, -20, 0, 16)
    LogoSub.TextXAlignment = Enum.TextXAlignment.Left
    LogoSub.BackgroundTransparency = 1
    LogoSub.Parent = Sidebar

    local NavContainer = Instance.new("Frame")
    NavContainer.Size = UDim2.new(1, -24, 1, -80)
    NavContainer.Position = UDim2.new(0, 12, 0, 70)
    NavContainer.BackgroundTransparency = 1
    NavContainer.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 8)
    NavLayout.Parent = NavContainer

    -- ÁREA PRINCIPAL
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -205, 1, -24)
    ContentArea.Position = UDim2.new(0, 195, 0, 12)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local WindowObj = {
        Tabs = {},
        ActiveTab = nil,
        Destroy = function() ScreenGui:Destroy() end
    }

    ---------------------------------------------------------
    -- SISTEMA DE CONFIGURAÇÕES LOCAL (SALVAR / CARREGAR)
    ---------------------------------------------------------
    function WindowObj:SaveConfig(profileName)
        profileName = profileName or "default"
        if writefile then
            local filePath = CollieLib.ConfigFolder .. "/" .. profileName .. ".json"
            local data = HttpService:JSONEncode(CollieLib.Flags)
            writefile(filePath, data)
            CollieLib:Notify({ Title = "Perfil Salvo!", Content = "Perfil '" .. profileName .. "' gravado com sucesso! 💾", Duration = 3 })
        else
            CollieLib:Notify({ Title = "Erro", Content = "Seu executor não suporta salvamento local.", Duration = 3 })
        end
    end

    function WindowObj:LoadConfig(profileName)
        profileName = profileName or "default"
        if readfile and isfile then
            local filePath = CollieLib.ConfigFolder .. "/" .. profileName .. ".json"
            if isfile(filePath) then
                local rawData = readfile(filePath)
                local decoded = HttpService:JSONDecode(rawData)
                for flag, value in pairs(decoded) do
                    if CollieLib.Flags[flag] and CollieLib.Flags[flag].Set then
                        CollieLib.Flags[flag].Set(value)
                    end
                end
                CollieLib:Notify({ Title = "Perfil Carregado!", Content = "Perfil '" .. profileName .. "' aplicado com sucesso! 📂", Duration = 3 })
            else
                CollieLib:Notify({ Title = "Aviso", Content = "Perfil '" .. profileName .. "' não encontrado.", Duration = 3 })
            end
        end
    end

    -- CRIADOR DE ABAS
    function WindowObj:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Aba"

        local NavBtn = Instance.new("TextButton")
        NavBtn.Size = UDim2.new(1, 0, 0, 38)
        NavBtn.BackgroundColor3 = THEME.Card
        NavBtn.Text = "  " .. TabName
        NavBtn.TextColor3 = THEME.TextSub
        NavBtn.TextSize = 13
        NavBtn.Font = Enum.Font.FredokaOne
        NavBtn.TextXAlignment = Enum.TextXAlignment.Left
        NavBtn.Parent = NavContainer
        AddCorner(NavBtn, 14)

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.Visible = false
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = THEME.Accent
        TabPage.Parent = ContentArea

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 10)
        ListLayout.Parent = TabPage

        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 15)
        end)

        local TabObj = { Page = TabPage, Button = NavBtn }

        function TabObj:Select()
            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                Tween(t.Button, {0.2}, {BackgroundColor3 = THEME.Card, TextColor3 = THEME.TextSub})
            end
            TabPage.Visible = true
            Tween(NavBtn, {0.2}, {BackgroundColor3 = THEME.Accent, TextColor3 = Color3.fromRGB(255, 255, 255)})
            WindowObj.ActiveTab = TabObj
        end

        NavBtn.MouseButton1Click:Connect(function() TabObj:Select() end)
        table.insert(WindowObj.Tabs, TabObj)

        if #WindowObj.Tabs == 1 then TabObj:Select() end

        ---------------------------------------------------------
        -- ELEMENTOS DA ABA (COMPONENTES)
        ---------------------------------------------------------

        -- SEÇÃO
        function TabObj:CreateSection(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 24)
            Label.BackgroundTransparency = 1
            Label.Text = "✨ " .. text
            Label.TextColor3 = THEME.AccentSecondary
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabPage
            return Label
        end

        -- BUTTON (COM ANIMAÇÃO DE PULSAÇÃO)
        function TabObj:CreateButton(btnConfig)
            btnConfig = btnConfig or {}
            local Name = btnConfig.Name or "Botão"
            local Callback = btnConfig.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.BackgroundColor3 = THEME.Accent
            Btn.Text = Name .. " 🐾"
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.Parent = TabPage
            AddCorner(Btn, 14)
            AddBlueGradient(Btn)

            Btn.MouseButton1Down:Connect(function()
                Tween(Btn, {0.1, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -16, 0, 36)})
            end)

            Btn.MouseButton1Up:Connect(function()
                Tween(Btn, {0.1, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, -10, 0, 40)})
                task.spawn(Callback)
            end)

            return Btn
        end

        -- TOGGLE (COM SALVAMENTO DE STATE)
        function TabObj:CreateToggle(tglConfig)
            tglConfig = tglConfig or {}
            local Name = tglConfig.Name or "Toggle"
            local Flag = tglConfig.Flag or Name
            local State = tglConfig.Default or false
            local Callback = tglConfig.Callback or function() end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 42)
            Frame.BackgroundColor3 = THEME.Card
            Frame.Parent = TabPage
            AddCorner(Frame, 14)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 14, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Name
            Label.TextColor3 = THEME.TextMain
            Label.TextSize = 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 40, 0, 22)
            Switch.Position = UDim2.new(1, -50, 0.5, -11)
            Switch.BackgroundColor3 = State and THEME.Accent or THEME.Disabled
            Switch.Text = ""
            Switch.Parent = Frame
            AddCorner(Switch, 12)

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = State and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = Switch
            AddCorner(Knob, 10)

            local function SetState(val)
                State = val
                Tween(Knob, {0.2, Enum.EasingStyle.Back}, {Position = State and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
                Tween(Switch, {0.2}, {BackgroundColor3 = State and THEME.Accent or THEME.Disabled})
                CollieLib.Flags[Flag] = { Value = State, Set = SetState }
                task.spawn(Callback, State)
            end

            Switch.MouseButton1Click:Connect(function() SetState(not State) end)
            CollieLib.Flags[Flag] = { Value = State, Set = SetState }

            return { Set = SetState }
        end

        -- SLIDER (COM SALVAMENTO DE STATE)
        function TabObj:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local Name = sliderConfig.Name or "Slider"
            local Flag = sliderConfig.Flag or Name
            local Min = sliderConfig.Min or 0
            local Max = sliderConfig.Max or 100
            local Default = sliderConfig.Default or Min
            local Callback = sliderConfig.Callback or function() end

            local Value = math.clamp(Default, Min, Max)

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 48)
            Frame.BackgroundColor3 = THEME.Card
            Frame.Parent = TabPage
            AddCorner(Frame, 14)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 0, 20)
            Label.Position = UDim2.new(0, 14, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = Name
            Label.TextColor3 = THEME.TextMain
            Label.TextSize = 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Position = UDim2.new(1, -74, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Value)
            ValueLabel.TextColor3 = THEME.AccentSecondary
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Frame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -28, 0, 8)
            Track.Position = UDim2.new(0, 14, 0, 32)
            Track.BackgroundColor3 = THEME.Background
            Track.Text = ""
            Track.Parent = Frame
            AddCorner(Track, 6)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = THEME.Accent
            Fill.Parent = Track
            AddCorner(Fill, 6)
            AddBlueGradient(Fill)

            local function SetValue(newVal)
                Value = math.clamp(math.floor(newVal), Min, Max)
                ValueLabel.Text = tostring(Value)
                Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
                CollieLib.Flags[Flag] = { Value = Value, Set = SetValue }
                task.spawn(Callback, Value)
            end

            local isDragging = false
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    local pct = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    SetValue(Min + (Max - Min) * pct)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    SetValue(Min + (Max - Min) * pct)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
            end)

            CollieLib.Flags[Flag] = { Value = Value, Set = SetValue }
            return { Set = SetValue }
        end

        return TabObj
    end

    return WindowObj
end

return CollieLib
