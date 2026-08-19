--[[
    COLLIELIB v1.1 🐾✨
    Design: Cute Cartoon / Blue Gradient Edition
    Tema: Azul Escuro & Azul Claro Pastel
--]]

local CollieLib = {}
CollieLib.__index = CollieLib

-- Serviços do Roblox
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- PALETA DE CORES (AZUL ESCURO & AZUL CLARO CARTOON)
local BLUE_PALETTE = {
    Background = Color3.fromRGB(26, 34, 56),       -- Azul Escuro Noturno
    CardBackground = Color3.fromRGB(38, 49, 78),   -- Azul Escuro Médio (Cards)
    Primary = Color3.fromRGB(79, 172, 254),        -- Azul Bebê Vibrante
    PrimaryDark = Color3.fromRGB(0, 242, 254),     -- Azul Ciano Pastel
    Secondary = Color3.fromRGB(142, 197, 252),     -- Azul Claro Pastel
    TextLight = Color3.fromRGB(240, 245, 255),     -- Texto Claro
    TextMuted = Color3.fromRGB(160, 180, 210),     -- Texto Secundário Azulado
    Border = Color3.fromRGB(60, 80, 120),          -- Borda Suave
    AccentBadge = Color3.fromRGB(255, 183, 178)    -- Destaque Pastel
}

-- Auxiliar de Animação (Tween)
local function Tween(instance, info, properties)
    local tween = TweenService:Create(instance, TweenInfo.new(unpack(info)), properties)
    tween:Play()
    return tween
end

-- Auxiliar de Canto Arredondado (Cartoon)
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 16)
    corner.Parent = parent
    return corner
end

-- Auxiliar de Gradiente Azul
local function AddBlueGradient(parent, colorStart, colorEnd, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colorStart or BLUE_PALETTE.Primary),
        ColorSequenceKeypoint.new(1, colorEnd or BLUE_PALETTE.PrimaryDark)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

-- MAPA DE CORES DAS TAGS
local TAG_COLORS = {
    BETA = Color3.fromRGB(255, 183, 178),
    ATUALIZANDO = Color3.fromRGB(181, 234, 215),
    REMOVIDO = Color3.fromRGB(199, 206, 234),
    BLOQUEADO = Color3.fromRGB(255, 154, 162),
    NOVO = Color3.fromRGB(160, 231, 229)
}

-- Auxiliar para Criar Tag Visual (Badge Cartoon)
local function CreateBadge(parent, tagType, position, anchorPoint)
    tagType = string.upper(tostring(tagType or ""))
    local tagColor = TAG_COLORS[tagType] or BLUE_PALETTE.Primary

    local badge = Instance.new("Frame")
    badge.Name = "Badge_" .. tagType
    badge.Size = UDim2.new(0, 0, 0, 18)
    badge.Position = position or UDim2.new(1, -6, 0, 6)
    badge.AnchorPoint = anchorPoint or Vector2.new(1, 0)
    badge.BackgroundColor3 = tagColor
    badge.ZIndex = parent.ZIndex + 5
    badge.Parent = parent

    AddCorner(badge, 12)

    local label = Instance.new("TextLabel")
    label.Text = tagType
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Parent = badge

    local textWidth = #tagType * 7 + 12
    badge.Size = UDim2.new(0, textWidth, 0, 18)
    return badge
end

-- SISTEMA DE NOTIFICAÇÕES (Estilo Card Cartoon Azul)
local NotificationGui
local NotificationContainer

local function InitNotificationSystem()
    if not NotificationGui then
        NotificationGui = Instance.new("ScreenGui")
        NotificationGui.Name = "CollieNotifications"
        NotificationGui.ResetOnSpawn = false
        pcall(function() NotificationGui.Parent = CoreGui end)
        if not NotificationGui.Parent then
            NotificationGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end

        NotificationContainer = Instance.new("Frame")
        NotificationContainer.Name = "Container"
        NotificationContainer.Size = UDim2.new(0, 280, 1, -20)
        NotificationContainer.Position = UDim2.new(1, -290, 0, 10)
        NotificationContainer.BackgroundTransparency = 1
        NotificationContainer.Parent = NotificationGui

        local layout = Instance.new("UIListLayout")
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)
        layout.Parent = NotificationContainer
    end
end

function CollieLib:Notify(config)
    config = config or {}
    InitNotificationSystem()

    local titleText = config.Title or "Collie Notice 🐾"
    local contentText = config.Content or ""
    local duration = config.Duration or 3

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 65)
    card.BackgroundColor3 = BLUE_PALETTE.CardBackground
    card.Position = UDim2.new(1, 320, 0, 0)
    card.Parent = NotificationContainer

    AddCorner(card, 16)

    local stroke = Instance.new("UIStroke")
    stroke.Color = BLUE_PALETTE.Primary
    stroke.Thickness = 2
    stroke.Parent = card

    local title = Instance.new("TextLabel")
    title.Text = "🐾 " .. titleText
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 14
    title.TextColor3 = BLUE_PALETTE.Secondary
    title.Position = UDim2.new(0, 12, 0, 8)
    title.Size = UDim2.new(1, -24, 0, 18)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = card

    local content = Instance.new("TextLabel")
    content.Text = contentText
    content.Font = Enum.Font.GothamMedium
    content.TextSize = 11
    content.TextColor3 = BLUE_PALETTE.TextLight
    content.Position = UDim2.new(0, 12, 0, 28)
    content.Size = UDim2.new(1, -24, 0, 30)
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextWrapped = true
    content.BackgroundTransparency = 1
    content.Parent = card

    Tween(card, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 0, 0, 0)})

    task.delay(duration, function()
        local tweenOut = Tween(card, {0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In}, {Position = UDim2.new(1, 320, 0, 0)})
        tweenOut.Completed:Connect(function()
            card:Destroy()
        end)
    end)
end

-- CREATOR DA JANELA PRINCIPAL
function CollieLib:CreateWindow(config)
    config = config or {}
    local TitleText = config.Title or "Collie Hub"
    local SubTitleText = config.SubTitle or "Blue Gradient Edition 🐾"
    local ToggleKey = config.ToggleKey or Enum.KeyCode.LeftControl

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CollieHub"
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 780, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
    MainFrame.BackgroundColor3 = BLUE_PALETTE.Background
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    AddCorner(MainFrame, 20)

    -- Borda Externa Fofa com Gradiente
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = BLUE_PALETTE.Secondary
    MainStroke.Thickness = 3
    MainStroke.Parent = MainFrame

    -- Efeito Hover para Botões Cartoon
    local function AddCuteHover(button)
        button.MouseEnter:Connect(function()
            Tween(button, {0.15, Enum.EasingStyle.Quad}, {Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale, button.Size.Y.Offset + 2)})
        end)
        button.MouseLeave:Connect(function()
            Tween(button, {0.15, Enum.EasingStyle.Quad}, {Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale, button.Size.Y.Offset - 2)})
        end)
    end

    -- Sistema de Arrastar (Drag)
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

    -- Toggle Visibilidade
    local IsVisible = true
    local function SetUIVisibility(visible)
        IsVisible = visible
        MainFrame.Visible = IsVisible
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == ToggleKey then
            SetUIVisibility(not IsVisible)
        end
    end)

    -- Sidebar (Painel Esquerdo)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 190, 1, 0)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local HubTitle = Instance.new("TextLabel")
    HubTitle.Text = "🐾 " .. TitleText
    HubTitle.Font = Enum.Font.FredokaOne
    HubTitle.TextSize = 18
    HubTitle.TextColor3 = BLUE_PALETTE.Secondary
    HubTitle.Position = UDim2.new(0, 18, 0, 25)
    HubTitle.Size = UDim2.new(1, -20, 0, 22)
    HubTitle.TextXAlignment = Enum.TextXAlignment.Left
    HubTitle.BackgroundTransparency = 1
    HubTitle.Parent = Sidebar

    local HubSub = Instance.new("TextLabel")
    HubSub.Text = SubTitleText
    HubSub.Font = Enum.Font.GothamMedium
    HubSub.TextSize = 11
    HubSub.TextColor3 = BLUE_PALETTE.TextMuted
    HubSub.Position = UDim2.new(0, 18, 0, 48)
    HubSub.Size = UDim2.new(1, -20, 0, 15)
    HubSub.TextXAlignment = Enum.TextXAlignment.Left
    HubSub.BackgroundTransparency = 1
    HubSub.Parent = Sidebar

    local NavContainer = Instance.new("Frame")
    NavContainer.Size = UDim2.new(1, -24, 1, -100)
    NavContainer.Position = UDim2.new(0, 12, 0, 80)
    NavContainer.BackgroundTransparency = 1
    NavContainer.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 8)
    NavLayout.Parent = NavContainer

    -- Conteúdo Principal (Lado Direito)
    local MainContent = Instance.new("Frame")
    MainContent.Size = UDim2.new(1, -210, 1, -30)
    MainContent.Position = UDim2.new(0, 200, 0, 15)
    MainContent.BackgroundTransparency = 1
    MainContent.Parent = MainFrame

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(0, 250, 0, 30)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = "Menu"
    SectionTitle.TextColor3 = BLUE_PALETTE.TextLight
    SectionTitle.TextSize = 20
    SectionTitle.Font = Enum.Font.FredokaOne
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = MainContent

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(0, 200, 0, 32)
    SearchBox.Position = UDim2.new(1, -200, 0, 0)
    SearchBox.BackgroundColor3 = BLUE_PALETTE.CardBackground
    SearchBox.PlaceholderText = "Pesquisar... ✨"
    SearchBox.PlaceholderColor3 = BLUE_PALETTE.TextMuted
    SearchBox.TextColor3 = BLUE_PALETTE.TextLight
    SearchBox.TextSize = 12
    SearchBox.Font = Enum.Font.GothamMedium
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = MainContent
    AddCorner(SearchBox, 12)

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = BLUE_PALETTE.Border
    SearchStroke.Thickness = 1.5
    SearchStroke.Parent = SearchBox

    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingLeft = UDim.new(0, 10)
    SearchPadding.Parent = SearchBox

    local DisplayViews = Instance.new("Frame")
    DisplayViews.Size = UDim2.new(1, 0, 1, -45)
    DisplayViews.Position = UDim2.new(0, 0, 0, 45)
    DisplayViews.BackgroundTransparency = 1
    DisplayViews.Parent = MainContent

    local WindowObj = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Tabs = {},
        ActiveTab = nil,
        SetToggleKey = function(self, newKey) ToggleKey = newKey end,
        ToggleUI = function(self) SetUIVisibility(not IsVisible) end,
        Destroy = function(self) ScreenGui:Destroy() end
    }

    -- CRIADOR DE ABAS (CreateTab)
    function WindowObj:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Aba"
        local IsHorizontalGrid = tabConfig.HorizontalGrid or false
        local Hidden = tabConfig.Hidden or false
        local TabTag = tabConfig.Tag or nil

        local NavBtn = Instance.new("TextButton")
        NavBtn.Size = UDim2.new(1, 0, 0, 36)
        NavBtn.BackgroundColor3 = BLUE_PALETTE.CardBackground
        NavBtn.BackgroundTransparency = 0.3
        NavBtn.Text = "  " .. TabName
        NavBtn.TextColor3 = BLUE_PALETTE.TextMuted
        NavBtn.TextSize = 13
        NavBtn.Font = Enum.Font.FredokaOne
        NavBtn.TextXAlignment = Enum.TextXAlignment.Left
        NavBtn.Visible = not Hidden
        NavBtn.Parent = NavContainer
        AddCorner(NavBtn, 12)

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = BLUE_PALETTE.Border
        TabStroke.Thickness = 1
        TabStroke.Parent = NavBtn

        local isDisabled = false
        if TabTag then
            local upperTag = string.upper(TabTag)
            CreateBadge(NavBtn, upperTag, UDim2.new(1, -8, 0.5, -9), Vector2.new(1, 0))
            if upperTag == "BLOQUEADO" or upperTag == "REMOVIDO" then
                isDisabled = true
                NavBtn.AutoButtonColor = false
            end
        end

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = "Page_" .. TabName
        TabPage.Visible = false
        TabPage.BackgroundTransparency = 1
        TabPage.Parent = DisplayViews

        if IsHorizontalGrid then
            TabPage.Size = UDim2.new(1, -10, 0, 180)
            TabPage.Position = UDim2.new(0, 5, 0, 5)
            TabPage.ScrollBarThickness = 4
            TabPage.ScrollBarImageColor3 = BLUE_PALETTE.Secondary
            TabPage.ScrollingDirection = Enum.ScrollingDirection.X
            TabPage.ClipsDescendants = true

            local containerFrame = Instance.new("Frame")
            containerFrame.Size = UDim2.new(0, 0, 1, 0)
            containerFrame.Parent = TabPage
            containerFrame.BackgroundTransparency = 1

            local horizontalLayout = Instance.new("UIListLayout")
            horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
            horizontalLayout.Padding = UDim.new(0, 15)
            horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
            horizontalLayout.Parent = containerFrame

            horizontalLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                containerFrame.Size = UDim2.new(0, horizontalLayout.AbsoluteContentSize.X, 1, 0)
                TabPage.CanvasSize = UDim2.new(0, horizontalLayout.AbsoluteContentSize.X + 20, 0, 0)
            end)
        else
            TabPage.Size = UDim2.new(1, 0, 1, 0)
            TabPage.ScrollBarThickness = 4
            TabPage.ScrollBarImageColor3 = BLUE_PALETTE.Secondary
            TabPage.ScrollingDirection = Enum.ScrollingDirection.Y

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 10)
            listLayout.Parent = TabPage

            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabPage.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 15)
            end)
        end

        local TabObj = { Page = TabPage, Button = NavBtn, Name = TabName, SearchItems = {} }

        function TabObj:Select()
            if isDisabled then
                CollieLib:Notify({ Title = "Ops!", Content = "Esta aba está " .. string.upper(TabTag) .. " 🐾", Duration = 2 })
                return
            end

            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                Tween(t.Button, {0.2}, {BackgroundColor3 = BLUE_PALETTE.CardBackground, BackgroundTransparency = 0.3, TextColor3 = BLUE_PALETTE.TextMuted})
            end

            TabPage.Visible = true
            SectionTitle.Text = TabName
            Tween(NavBtn, {0.2}, {BackgroundColor3 = BLUE_PALETTE.Primary, BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)})
            WindowObj.ActiveTab = TabObj
        end

        NavBtn.MouseButton1Click:Connect(function() TabObj:Select() end)
        table.insert(WindowObj.Tabs, TabObj)

        if #WindowObj.Tabs == 1 and not Hidden and not isDisabled then TabObj:Select() end

        -- Pesquisa
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            if WindowObj.ActiveTab == TabObj then
                local cleanText = string.lower(SearchBox.Text)
                for _, item in ipairs(TabObj.SearchItems) do
                    item.Instance.Visible = (cleanText == "" or string.find(string.lower(item.Name), cleanText) ~= nil)
                end
            end
        end)

        -- COMPONENTES DA ABA

        -- CARD DE JOGO (Gradiente Azul Fofo)
        function TabObj:CreateGameCard(cardConfig)
            cardConfig = cardConfig or {}
            local Name = cardConfig.Name or "Jogo"
            local Callback = cardConfig.Callback or function() end
            local CardTag = cardConfig.Tag or nil
            local IsFavorite = cardConfig.Favorite or false

            local parentFrame = TabPage:FindFirstChildOfClass("Frame") or TabPage

            local card = Instance.new("TextButton")
            card.Name = Name
            card.Size = UDim2.new(0, 110, 0, 140)
            card.BackgroundColor3 = BLUE_PALETTE.CardBackground
            card.Text = ""
            card.LayoutOrder = IsFavorite and 0 or 10
            card.Parent = parentFrame
            AddCorner(card, 16)

            local cardGradient = AddBlueGradient(card, BLUE_PALETTE.CardBackground, Color3.fromRGB(48, 62, 98), 45)

            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = BLUE_PALETTE.Border
            cardStroke.Thickness = 1.5
            cardStroke.Parent = card

            AddCuteHover(card)

            local cardDisabled = false
            if CardTag then
                local upperTag = string.upper(CardTag)
                CreateBadge(card, upperTag, UDim2.new(0, 6, 0, 6), Vector2.new(0, 0))
                if upperTag == "BLOQUEADO" or upperTag == "REMOVIDO" then cardDisabled = true end
            end

            -- Botão Favorito
            local FavBtn = Instance.new("TextButton")
            FavBtn.Size = UDim2.new(0, 22, 0, 22)
            FavBtn.Position = UDim2.new(1, -24, 0, 4)
            FavBtn.BackgroundTransparency = 1
            FavBtn.Text = IsFavorite and "💙" or "🤍"
            FavBtn.TextSize = 14
            FavBtn.Parent = card

            FavBtn.MouseButton1Click:Connect(function()
                IsFavorite = not IsFavorite
                FavBtn.Text = IsFavorite and "💙" or "🤍"
                card.LayoutOrder = IsFavorite and 0 or 10
                CollieLib:Notify({ Title = "Favoritos", Content = IsFavorite and (Name .. " adicionado aos favoritos! 🐾") or (Name .. " removido!"), Duration = 2 })
            end)

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -12, 0, 40)
            title.Position = UDim2.new(0, 6, 0.5, 15)
            title.BackgroundTransparency = 1
            title.Text = Name
            title.TextColor3 = BLUE_PALETTE.TextLight
            title.TextSize = 11
            title.Font = Enum.Font.FredokaOne
            title.TextWrapped = true
            title.Parent = card

            card.MouseButton1Click:Connect(function()
                if cardDisabled then
                    CollieLib:Notify({ Title = "Ops!", Content = "Este jogo está " .. string.upper(CardTag) .. "!", Duration = 2 })
                    return
                end
                task.spawn(Callback)
            end)

            table.insert(TabObj.SearchItems, { Name = Name, Instance = card })
            return { Card = card }
        end

        -- SEÇÃO
        function TabObj:CreateSection(secConfig)
            local titleText = type(secConfig) == "string" and secConfig or (secConfig.Name or "Seção")
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -15, 0, 22)
            Label.BackgroundTransparency = 1
            Label.Text = "✨ " .. titleText
            Label.TextColor3 = BLUE_PALETTE.Secondary
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TabPage
            return Label
        end

        -- TOGGLE
        function TabObj:CreateToggle(tglConfig)
            tglConfig = tglConfig or {}
            local Name = tglConfig.Name or "Toggle"
            local State = tglConfig.Default or false
            local Callback = tglConfig.Callback or function() end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 42)
            Frame.BackgroundColor3 = BLUE_PALETTE.CardBackground
            Frame.Parent = TabPage
            AddCorner(Frame, 14)

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Color = BLUE_PALETTE.Border
            FrameStroke.Thickness = 1.5
            FrameStroke.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Name
            Label.TextColor3 = BLUE_PALETTE.TextLight
            Label.TextSize = 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 38, 0, 20)
            Switch.Position = UDim2.new(1, -48, 0.5, -10)
            Switch.BackgroundColor3 = State and BLUE_PALETTE.Primary or Color3.fromRGB(50, 60, 85)
            Switch.Text = ""
            Switch.Parent = Frame
            AddCorner(Switch, 10)

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 14, 0, 14)
            Indicator.Position = State and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Parent = Switch
            AddCorner(Indicator, 7)

            local function SetState(val)
                State = val
                Tween(Indicator, {0.2, Enum.EasingStyle.Back}, {Position = State and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)})
                Tween(Switch, {0.2}, {BackgroundColor3 = State and BLUE_PALETTE.Primary or Color3.fromRGB(50, 60, 85)})
                task.spawn(Callback, State)
            end

            Switch.MouseButton1Click:Connect(function() SetState(not State) end)
            table.insert(TabObj.SearchItems, { Name = Name, Instance = Frame })
            return { Set = SetState, Get = function() return State end }
        end

        -- BOTÃO COM GRADIENTE AZUL
        function TabObj:CreateButton(btnConfig)
            btnConfig = btnConfig or {}
            local Name = btnConfig.Name or "Botão"
            local Callback = btnConfig.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 38)
            Btn.BackgroundColor3 = BLUE_PALETTE.Primary
            Btn.Text = Name .. " 🐾"
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.Parent = TabPage
            AddCorner(Btn, 14)

            AddBlueGradient(Btn, BLUE_PALETTE.Primary, BLUE_PALETTE.PrimaryDark, 90)
            AddCuteHover(Btn)

            Btn.MouseButton1Click:Connect(function() task.spawn(Callback) end)
            table.insert(TabObj.SearchItems, { Name = Name, Instance = Btn })
            return Btn
        end

        -- SLIDER
        function TabObj:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local Name = sliderConfig.Name or "Slider"
            local Min = sliderConfig.Min or 0
            local Max = sliderConfig.Max or 100
            local Default = sliderConfig.Default or Min
            local Callback = sliderConfig.Callback or function() end

            local Value = math.clamp(Default, Min, Max)

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 48)
            Frame.BackgroundColor3 = BLUE_PALETTE.CardBackground
            Frame.Parent = TabPage
            AddCorner(Frame, 14)

            local FrameStroke = Instance.new("UIStroke")
            FrameStroke.Color = BLUE_PALETTE.Border
            FrameStroke.Thickness = 1.5
            FrameStroke.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 0, 18)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = Name
            Label.TextColor3 = BLUE_PALETTE.TextLight
            Label.TextSize = 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 18)
            ValueLabel.Position = UDim2.new(1, -72, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Value)
            ValueLabel.TextColor3 = BLUE_PALETTE.Secondary
            ValueLabel.TextSize = 11
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Frame

            local SliderTrack = Instance.new("TextButton")
            SliderTrack.Size = UDim2.new(1, -24, 0, 8)
            SliderTrack.Position = UDim2.new(0, 12, 0, 30)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(28, 36, 58)
            SliderTrack.Text = ""
            SliderTrack.Parent = Frame
            AddCorner(SliderTrack, 4)

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = BLUE_PALETTE.Primary
            SliderFill.Parent = SliderTrack
            AddCorner(SliderFill, 4)

            AddBlueGradient(SliderFill, BLUE_PALETTE.Primary, BLUE_PALETTE.PrimaryDark, 0)

            local function UpdateSlider(input)
                local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + (Max - Min) * percent)
                ValueLabel.Text = tostring(Value)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                task.spawn(Callback, Value)
            end

            local isDragging = false
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
            end)

            table.insert(TabObj.SearchItems, { Name = Name, Instance = Frame })
            return { Get = function() return Value end }
        end

        return TabObj
    end

    return WindowObj
end

return CollieLib
