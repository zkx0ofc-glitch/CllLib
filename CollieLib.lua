-- ========================================================================
-- COLLIELIB v2.0 - CARTOON PASTEL UI LIBRARY (OOP)
-- ========================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local CollieLib = {}
CollieLib.__index = CollieLib

-- ------------------------------------------------------------------------
-- DEFINIÇÃO DE TEMAS E PALETAS PASTEL
-- ------------------------------------------------------------------------
CollieLib.Themes = {
    ["Azul Clássico Collie"] = {
        Background = Color3.fromRGB(180, 210, 245),
        Header = Color3.fromRGB(150, 190, 235),
        Sidebar = Color3.fromRGB(165, 200, 240),
        Card = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(50, 70, 95),
        Accent = Color3.fromRGB(100, 160, 230),
        Tag = Color3.fromRGB(130, 180, 240)
    },
    ["Midnight Pastel"] = {
        Background = Color3.fromRGB(35, 45, 60),
        Header = Color3.fromRGB(25, 35, 50),
        Sidebar = Color3.fromRGB(30, 40, 55),
        Card = Color3.fromRGB(45, 58, 75),
        Text = Color3.fromRGB(220, 235, 245),
        Accent = Color3.fromRGB(80, 180, 210),
        Tag = Color3.fromRGB(60, 130, 160)
    },
    ["Algodão Doce"] = {
        Background = Color3.fromRGB(245, 205, 225),
        Header = Color3.fromRGB(235, 185, 210),
        Sidebar = Color3.fromRGB(240, 195, 218),
        Card = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(90, 60, 80),
        Accent = Color3.fromRGB(180, 210, 255),
        Tag = Color3.fromRGB(240, 160, 190)
    },
    ["Menta Fresca"] = {
        Background = Color3.fromRGB(180, 235, 220),
        Header = Color3.fromRGB(155, 220, 200),
        Sidebar = Color3.fromRGB(168, 228, 210),
        Card = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(45, 80, 70),
        Accent = Color3.fromRGB(100, 200, 190),
        Tag = Color3.fromRGB(120, 210, 180)
    }
}

CollieLib.StatusTags = {
    ["NEW"] = Color3.fromRGB(100, 180, 255),
    ["BETA"] = Color3.fromRGB(180, 140, 245),
    ["RELEASE"] = Color3.fromRGB(120, 220, 150),
    ["REMOVED"] = Color3.fromRGB(230, 100, 110),
    ["UPDATING"] = Color3.fromRGB(245, 200, 90)
}

-- ------------------------------------------------------------------------
-- FUNÇÕES AUXILIARES & UTILS
-- ------------------------------------------------------------------------
local function ElasticTween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or 0.4,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function LinearTween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ------------------------------------------------------------------------
-- CONSTRUTOR PRINCIPAL DA JANELA (WINDOW CLASS)
-- ------------------------------------------------------------------------
function CollieLib:CreateWindow(title, subtitle)
    local WindowObj = {}
    setmetatable(WindowObj, {__index = CollieLib})

    WindowObj.CurrentTheme = CollieLib.Themes["Azul Clássico Collie"]
    WindowObj.Tabs = {}
    WindowObj.ActiveTab = nil
    WindowObj.Favorites = {}
    WindowObj.IsLocked = false

    -- ScreenGui Principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CollieLib_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    WindowObj.ScreenGui = ScreenGui

    -- Container Principal (Janela)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 620, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
    MainFrame.BackgroundColor3 = WindowObj.CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui
    WindowObj.MainFrame = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 18)
    MainCorner.Parent = MainFrame

    -- Efeito Bubble POP na abertura
    MainFrame.ScaleScale = 0
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    ElasticTween(MainFrame, {Size = UDim2.new(0, 620, 0, 420)}, 0.5)

    -- Sombra Projetada (DropShadow)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "DropShadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    Shadow.Size = UDim2.new(1, 24, 1, 24)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.75
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    WindowObj.Shadow = Shadow

    -- Header / Barra Superior
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = WindowObj.CurrentTheme.Header
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    WindowObj.Header = Header

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 18)
    HeaderCorner.Parent = Header

    -- Título e Subtítulo
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title or "CollieLib"
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = WindowObj.CurrentTheme.Text
    TitleLabel.Position = UDim2.new(0, 20, 0, 8)
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header
    WindowObj.TitleLabel = TitleLabel

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Text = subtitle or "Cartoon Hub"
    SubLabel.Font = Enum.Font.SourceSansBold
    SubLabel.TextSize = 13
    SubLabel.TextColor3 = WindowObj.CurrentTheme.Text
    SubLabel.TextTransparency = 0.3
    SubLabel.Position = UDim2.new(0, 20, 0, 28)
    SubLabel.Size = UDim2.new(0, 200, 0, 14)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.BackgroundTransparency = 1
    SubLabel.Parent = Header

    -- Container da Barra Lateral (Sidebar Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.new(0, 10, 0, 60)
    Sidebar.Size = UDim2.new(0, 150, 1, -70)
    Sidebar.BackgroundColor3 = WindowObj.CurrentTheme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    WindowObj.Sidebar = Sidebar

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 14)
    SideCorner.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = Sidebar

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.Parent = Sidebar

    -- Container de Páginas de Conteúdo
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Position = UDim2.new(0, 170, 0, 60)
    ContentHolder.Size = UDim2.new(1, -180, 1, -70)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame
    WindowObj.ContentHolder = ContentHolder

    -- Ativar Drag Elástico por padrão
    WindowObj:EnableSmoothDrag()

    -- Ativar Partículas de Fundo
    WindowObj:InitBackgroundParticles()

    -- Ativar Aba de Favoritos Dinâmica
    WindowObj:CreateFavoritesSystem()

    return WindowObj
end

-- ------------------------------------------------------------------------
-- CATEGORIA 1: SISTEMA CORE, TEMAS E FILTROS VISUAIS
-- ------------------------------------------------------------------------
function CollieLib:SetTheme(theme_name)
    local theme = CollieLib.Themes[theme_name]
    if not theme then return end
    self.CurrentTheme = theme

    LinearTween(self.MainFrame, {BackgroundColor3 = theme.Background})
    LinearTween(self.Header, {BackgroundColor3 = theme.Header})
    LinearTween(self.Sidebar, {BackgroundColor3 = theme.Sidebar})
    LinearTween(self.TitleLabel, {TextColor3 = theme.Text})
end

function CollieLib:SetAcrylicBlur(enabled)
    if enabled then
        local Blur = Instance.new("DepthOfFieldEffect")
        Blur.Name = "CollieBlur"
        Blur.FarIntensity = 0.5
        Blur.FocusDistance = 0
        Blur.InFocusRadius = 0
        Blur.NearIntensity = 0.8
        Blur.Parent = game:GetService("Lighting")
    else
        local old = game:GetService("Lighting"):FindFirstChild("CollieBlur")
        if old then old:Destroy() end
    end
end

function CollieLib:SetDropShadow(enabled)
    self.Shadow.Visible = enabled
end

function CollieLib:SetWatermark(enabled, config)
    if not enabled then
        if self.WatermarkFrame then self.WatermarkFrame:Destroy() end
        return
    end

    local Frame = Instance.new("Frame")
    Frame.Name = "Watermark"
    Frame.Size = UDim2.new(0, 320, 0, 26)
    Frame.Position = UDim2.new(0, 15, 0, 15)
    Frame.BackgroundColor3 = self.CurrentTheme.Header
    Frame.Parent = self.ScreenGui
    self.WatermarkFrame = Frame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 5, 0, 0)
    Label.Font = Enum.Font.FredokaOne
    Label.TextSize = 12
    Label.TextColor3 = self.CurrentTheme.Text
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    RunService.RenderStepped:Connect(function(fps)
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        local user = game.Players.LocalPlayer.Name
        Label.Text = string.format("CollieLib | %s | FPS: %d | Ping: %dms", user, math.floor(1/fps), ping)
    end)
end

-- ------------------------------------------------------------------------
-- CATEGORIA 2: ENGENHARIA DE ARRASTAR E RENDERIZAÇÃO
-- ------------------------------------------------------------------------
function CollieLib:EnableSmoothDrag()
    local dragging = false
    local dragInput, dragStart, startPos

    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    self.Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            LinearTween(self.MainFrame, {Position = targetPos}, 0.1)
        end
    end)
end

function CollieLib:ApplyAutoLayout(container)
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = container

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 6)
    Padding.PaddingLeft = UDim.new(0, 6)
    Padding.PaddingRight = UDim.new(0, 6)
    Padding.PaddingBottom = UDim.new(0, 6)
    Padding.Parent = container

    return Layout
end

function CollieLib:SetAutomaticScrolling(scrollingFrame)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
end

-- ------------------------------------------------------------------------
-- CATEGORIA 3: CONVERSÃO VISUAL, NOTIFICAÇÕES E STATUS
-- ------------------------------------------------------------------------
function CollieLib:CheckServerStatus(status_string)
    local colorMap = {
        ["Operacional"] = Color3.fromRGB(100, 220, 130),
        ["Instável"] = Color3.fromRGB(240, 200, 80),
        ["Manutenção"] = Color3.fromRGB(230, 90, 90)
    }

    if status_string == "Manutenção" then
        self.IsLocked = true
        self:Notify("Aviso de Sistema", "Painel bloqueado para manutenção temporária.", 5, "REMOVED")
    else
        self.IsLocked = false
    end

    if not self.StatusIndicator then
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 12, 0, 12)
        Indicator.Position = UDim2.new(1, -25, 0, 19)
        Indicator.BackgroundColor3 = colorMap[status_string] or Color3.fromRGB(200, 200, 200)
        Indicator.Parent = self.Header

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(1, 0)
        Corner.Parent = Indicator
        self.StatusIndicator = Indicator
    else
        self.StatusIndicator.BackgroundColor3 = colorMap[status_string]
    end
end

function CollieLib:Notify(title, text, duration, notification_type)
    duration = duration or 4
    if not self.NotificationHolder then
        local Holder = Instance.new("Frame")
        Holder.Name = "NotificationHolder"
        Holder.Position = UDim2.new(1, -230, 1, -20)
        Holder.Size = UDim2.new(0, 210, 1, 0)
        Holder.AnchorPoint = Vector2.new(0, 1)
        Holder.BackgroundTransparency = 1
        Holder.Parent = self.ScreenGui

        self:ApplyAutoLayout(Holder)
        self.NotificationHolder = Holder
    end

    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(1, 0, 0, 60)
    Toast.BackgroundColor3 = self.CurrentTheme.Card
    Toast.Parent = self.NotificationHolder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Toast

    local ToastTitle = Instance.new("TextLabel")
    ToastTitle.Text = title
    ToastTitle.Font = Enum.Font.FredokaOne
    ToastTitle.TextSize = 14
    ToastTitle.TextColor3 = self.CurrentTheme.Text
    ToastTitle.Position = UDim2.new(0, 10, 0, 6)
    ToastTitle.Size = UDim2.new(1, -20, 0, 16)
    ToastTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToastTitle.BackgroundTransparency = 1
    ToastTitle.Parent = Toast

    local ToastText = Instance.new("TextLabel")
    ToastText.Text = text
    ToastText.Font = Enum.Font.SourceSans
    ToastText.TextSize = 12
    ToastText.TextColor3 = self.CurrentTheme.Text
    ToastText.Position = UDim2.new(0, 10, 0, 22)
    ToastText.Size = UDim2.new(1, -20, 0, 28)
    ToastText.TextWrapped = true
    ToastText.TextXAlignment = Enum.TextXAlignment.Left
    ToastText.BackgroundTransparency = 1
    ToastText.Parent = Toast

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, 0, 0, 4)
    ProgressBar.Position = UDim2.new(0, 0, 1, -4)
    ProgressBar.BackgroundColor3 = CollieLib.StatusTags[notification_type] or self.CurrentTheme.Accent
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = Toast

    ElasticTween(Toast, {Size = UDim2.new(1, 0, 0, 60)}, 0.3)
    LinearTween(ProgressBar, {Size = UDim2.new(0, 0, 0, 4)}, duration)

    task.delay(duration, function()
        LinearTween(Toast, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        Toast:Destroy()
    end)
end

-- ------------------------------------------------------------------------
-- CATEGORIA 4: ELEMENTOS AVANÇADOS DE NAVEGAÇÃO E BUSCA
-- ------------------------------------------------------------------------
function CollieLib:CreateTab(tab_name, icon_id)
    local TabObj = {}
    TabObj.Name = tab_name
    TabObj.Page = Instance.new("ScrollingFrame")

    TabObj.Page.Name = tab_name .. "_Page"
    TabObj.Page.Size = UDim2.new(1, 0, 1, 0)
    TabObj.Page.BackgroundTransparency = 1
    TabObj.Page.ScrollBarThickness = 4
    TabObj.Page.ScrollBarImageColor3 = self.CurrentTheme.Accent
    TabObj.Page.Visible = false
    TabObj.Page.Parent = self.ContentHolder

    self:ApplyAutoLayout(TabObj.Page)
    self:SetAutomaticScrolling(TabObj.Page)

    -- Botão na Sidebar
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 32)
    TabButton.BackgroundColor3 = self.CurrentTheme.Card
    TabButton.Text = tab_name
    TabButton.Font = Enum.Font.FredokaOne
    TabButton.TextSize = 13
    TabButton.TextColor3 = self.CurrentTheme.Text
    TabButton.Parent = self.Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = TabButton

    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Page.Visible = false
        end
        TabObj.Page.Visible = true
        self.ActiveTab = TabObj
    end)

    table.insert(self.Tabs, TabObj)

    -- Abre a primeira aba por padrão
    if #self.Tabs == 1 then
        TabObj.Page.Visible = true
        self.ActiveTab = TabObj
    end

    return setmetatable(TabObj, {__index = function(_, key) return self[key] or TabObj end})
end

function CollieLib:CreateSubTab(sub_tab_name)
    local SubTabFrame = Instance.new("Frame")
    SubTabFrame.Size = UDim2.new(1, 0, 0, 30)
    SubTabFrame.BackgroundTransparency = 1
    SubTabFrame.Parent = self.Page or self.ContentHolder

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = SubTabFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 80, 1, 0)
    Btn.BackgroundColor3 = self.CurrentTheme.Accent
    Btn.Text = sub_tab_name
    Btn.Font = Enum.Font.FredokaOne
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Parent = SubTabFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
end

function CollieLib:EnableSearchBar()
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBar"
    SearchBox.Size = UDim2.new(0, 150, 0, 24)
    SearchBox.Position = UDim2.new(1, -180, 0, 13)
    SearchBox.PlaceholderText = "Buscar..."
    SearchBox.Text = ""
    SearchBox.Font = Enum.Font.SourceSans
    SearchBox.TextSize = 12
    SearchBox.BackgroundColor3 = self.CurrentTheme.Card
    SearchBox.Parent = self.Header

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SearchBox

    SearchBox.Changed:Connect(function()
        local query = SearchBox.Text:lower()
        if self.ActiveTab then
            for _, item in pairs(self.ActiveTab.Page:GetChildren()) do
                if item:IsA("Frame") or item:IsA("TextButton") then
                    local label = item:FindFirstChildOfClass("TextLabel") or item
                    if label and label.Text then
                        item.Visible = string.find(label.Text:lower(), query) ~= nil
                    end
                end
            end
        end
    end)
end

function CollieLib:CreateFavoritesSystem()
    local FavTab = self:CreateTab("★ Favoritos")
    self.FavoritesTab = FavTab
end

-- ------------------------------------------------------------------------
-- CATEGORIA 5: COMPONENTES DE INTERAÇÃO COMPLETA (INPUTS)
-- ------------------------------------------------------------------------
function CollieLib:AttachTag(parent, tag_type)
    if not CollieLib.StatusTags[tag_type] then return end
    local Tag = Instance.new("TextLabel")
    Tag.Size = UDim2.new(0, 50, 0, 16)
    Tag.Position = UDim2.new(1, -55, 0, 6)
    Tag.BackgroundColor3 = CollieLib.StatusTags[tag_type]
    Tag.Text = tag_type
    Tag.Font = Enum.Font.FredokaOne
    Tag.TextSize = 9
    Tag.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tag.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Tag
end

function CollieLib:CreateSection(title, has_tag)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, -12, 0, 24)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = self.Page

    local Label = Instance.new("TextLabel")
    Label.Text = title
    Label.Font = Enum.Font.FredokaOne
    Label.TextSize = 13
    Label.TextColor3 = self.CurrentTheme.Text
    Label.Position = UDim2.new(0, 4, 0, 0)
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = SectionFrame

    if has_tag then self:AttachTag(SectionFrame, has_tag) end
end

function CollieLib:CreateTitle(text, alignment_type)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -12, 0, 20)
    Label.Text = text
    Label.Font = Enum.Font.FredokaOne
    Label.TextSize = 14
    Label.TextColor3 = self.CurrentTheme.Text
    Label.TextXAlignment = alignment_type or Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = self.Page
end

function CollieLib:CreateButton(text, callback, tag)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -12, 0, 32)
    Btn.BackgroundColor3 = self.CurrentTheme.Card
    Btn.Text = "  " .. text
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 13
    Btn.TextColor3 = self.CurrentTheme.Text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    if tag then self:AttachTag(Btn, tag) end

    Btn.MouseButton1Click:Connect(function()
        if self.IsLocked then return end
        ElasticTween(Btn, {Size = UDim2.new(1, -16, 0, 28)}, 0.1)
        task.wait(0.1)
        ElasticTween(Btn, {Size = UDim2.new(1, -12, 0, 32)}, 0.2)
        pcall(callback)
    end)
end

function CollieLib:CreateToggle(text, default_state, callback)
    local state = default_state or false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -12, 0, 32)
    Frame.BackgroundColor3 = self.CurrentTheme.Card
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextColor3 = self.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = state and self.CurrentTheme.Accent or Color3.fromRGB(200, 200, 200)
    Switch.Parent = Frame

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = Switch

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = Frame

    Btn.MouseButton1Click:Connect(function()
        if self.IsLocked then return end
        state = not state
        ElasticTween(Dot, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.3)
        LinearTween(Switch, {BackgroundColor3 = state and self.CurrentTheme.Accent or Color3.fromRGB(200, 200, 200)}, 0.2)
        pcall(callback, state)
    end)
end

function CollieLib:CreateSlider(text, min, max, default, allow_typing, callback)
    local value = default or min

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -12, 0, 45)
    Frame.BackgroundColor3 = self.CurrentTheme.Card
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.Size = UDim2.new(0.5, 0, 0, 18)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextColor3 = self.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local ValInput = Instance.new("TextBox")
    ValInput.Text = tostring(value)
    ValInput.Position = UDim2.new(1, -50, 0, 4)
    ValInput.Size = UDim2.new(0, 40, 0, 18)
    ValInput.Font = Enum.Font.FredokaOne
    ValInput.TextColor3 = self.CurrentTheme.Text
    ValInput.BackgroundTransparency = 1
    ValInput.TextEditable = allow_typing
    ValInput.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -20, 0, 8)
    Bar.Position = UDim2.new(0, 10, 0, 28)
    Bar.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    Bar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = self.CurrentTheme.Accent
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    -- Lógica de Arraste do Slider
    local dragging = false
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * pct)
            ValInput.Text = tostring(value)
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            pcall(callback, value)
        end
    end)
end

function CollieLib:CreateDropdown(text, list_options, is_multi_select, callback)
    local open = false
    local selected = {}

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -12, 0, 32)
    Frame.BackgroundColor3 = self.CurrentTheme.Card
    Frame.ClipsDescendants = true
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.Text = "  " .. text .. " v"
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextColor3 = self.CurrentTheme.Text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BackgroundTransparency = 1
    Btn.Parent = Frame

    local OptionHolder = Instance.new("Frame")
    OptionHolder.Position = UDim2.new(0, 0, 0, 32)
    OptionHolder.Size = UDim2.new(1, 0, 0, #list_options * 24)
    OptionHolder.BackgroundTransparency = 1
    OptionHolder.Parent = Frame

    self:ApplyAutoLayout(OptionHolder)

    for _, opt in ipairs(list_options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, -12, 0, 20)
        OptBtn.Text = opt
        OptBtn.Font = Enum.Font.SourceSans
        OptBtn.TextColor3 = self.CurrentTheme.Text
        OptBtn.BackgroundColor3 = self.CurrentTheme.Background
        OptBtn.Parent = OptionHolder

        OptBtn.MouseButton1Click:Connect(function()
            if is_multi_select then
                table.insert(selected, opt)
                pcall(callback, selected)
            else
                selected = {opt}
                Btn.Text = "  " .. text .. " (" .. opt .. ")"
                pcall(callback, opt)
            end
        end)
    end

    Btn.MouseButton1Click:Connect(function()
        open = not open
        ElasticTween(Frame, {Size = UDim2.new(1, -12, 0, open and (36 + #list_options * 26) or 32)}, 0.3)
    end)
end

function CollieLib:CreateColorpicker(text, default_color, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -12, 0, 32)
    Frame.BackgroundColor3 = self.CurrentTheme.Card
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextColor3 = self.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Preview = Instance.new("TextButton")
    Preview.Size = UDim2.new(0, 24, 0, 24)
    Preview.Position = UDim2.new(1, -34, 0.5, -12)
    Preview.BackgroundColor3 = default_color or Color3.fromRGB(255, 255, 255)
    Preview.Text = ""
    Preview.Parent = Frame

    local PrevCorner = Instance.new("UICorner")
    PrevCorner.CornerRadius = UDim.new(0, 6)
    PrevCorner.Parent = Preview

    Preview.MouseButton1Click:Connect(function()
        local randomColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        Preview.BackgroundColor3 = randomColor
        pcall(callback, randomColor)
    end)
end

function CollieLib:CreateHotkey(text, default_key, callback)
    local currentKey = default_key or Enum.KeyCode.E

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -12, 0, 32)
    Frame.BackgroundColor3 = self.CurrentTheme.Card
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextColor3 = self.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0, 60, 0, 20)
    KeyBtn.Position = UDim2.new(1, -70, 0.5, -10)
    KeyBtn.BackgroundColor3 = self.CurrentTheme.Accent
    KeyBtn.Text = currentKey.Name
    KeyBtn.Font = Enum.Font.FredokaOne
    KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBtn.Parent = Frame

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 6)
    KeyCorner.Parent = KeyBtn

    KeyBtn.MouseButton1Click:Connect(function()
        KeyBtn.Text = "..."
        local input = UserInputService.InputBegan:Wait()
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            currentKey = input.KeyCode
            KeyBtn.Text = currentKey.Name
            pcall(callback, currentKey)
        end
    end)
end

function CollieLib:CreateShortcut(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 90, 0, 26)
    Btn.BackgroundColor3 = self.CurrentTheme.Accent
    Btn.Text = text
    Btn.Font = Enum.Font.FredokaOne
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

function CollieLib:CreateTextBox(text, place_holder, numbers_only, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -12, 0, 32)
    Frame.BackgroundColor3 = self.CurrentTheme.Card
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -20, 1, 0)
    Input.Position = UDim2.new(0, 10, 0, 0)
    Input.PlaceholderText = place_holder or text
    Input.Text = ""
    Input.Font = Enum.Font.SourceSans
    Input.TextColor3 = self.CurrentTheme.Text
    Input.TextXAlignment = Enum.TextXAlignment.Left
    Input.BackgroundTransparency = 1
    Input.Parent = Frame

    Input.FocusLost:Connect(function()
        if numbers_only and not tonumber(Input.Text) then
            Input.Text = ""
            return
        end
        pcall(callback, Input.Text)
    end)
end

-- ------------------------------------------------------------------------
-- CATEGORIA 6: SISTEMA DE CONFIGURAÇÕES, UTILITÁRIOS E FEEDBACK
-- ------------------------------------------------------------------------
function CollieLib:CreateSaveProfileSystem(file_name)
    local save_data = {
        Theme = "Azul Clássico Collie",
        Configs = {}
    }

    if writefile then
        writefile(file_name .. ".json", HttpService:JSONEncode(save_data))
        self:Notify("Perfil Salvo", "Configurações gravadas com sucesso!", 3, "RELEASE")
    end
end

function CollieLib:CreateConsoleLog(window_title)
    local ConsoleFrame = Instance.new("Frame")
    ConsoleFrame.Size = UDim2.new(0, 300, 0, 180)
    ConsoleFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    ConsoleFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    ConsoleFrame.Parent = self.ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = ConsoleFrame

    local Title = Instance.new("TextLabel")
    Title.Text = window_title or "Console Log"
    Title.Size = UDim2.new(1, 0, 0, 22)
    Title.Font = Enum.Font.FredokaOne
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Parent = ConsoleFrame

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -10, 1, -30)
    Scroll.Position = UDim2.new(0, 5, 0, 25)
    Scroll.BackgroundTransparency = 1
    Scroll.Parent = ConsoleFrame

    self:ApplyAutoLayout(Scroll)
    self:SetAutomaticScrolling(Scroll)
end

function CollieLib:InitBackgroundParticles()
    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.ClipsDescendants = true
    ParticleContainer.ZIndex = 0
    ParticleContainer.Parent = self.MainFrame

    task.spawn(function()
        while task.wait(1.5) do
            local Particle = Instance.new("Frame")
            Particle.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10))
            Particle.Position = UDim2.new(math.random(), 0, 1, 0)
            Particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Particle.BackgroundTransparency = 0.6
            Particle.Parent = ParticleContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1, 0)
            Corner.Parent = Particle

            LinearTween(Particle, {
                Position = UDim2.new(Particle.Position.X.Scale, 0, 0, -20),
                BackgroundTransparency = 1
            }, 4)

            task.delay(4, function() Particle:Destroy() end)
        end
    end)
end

return CollieLib
