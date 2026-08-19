--[[
    ========================================================================
    CollieLib v3.0 - Paradise & Basic Hub Edition
    ========================================================================
    Inspirado no visual Collie Hub (Basic Edition / Paradise Edition).
    Suporta:
    - Temas Dinâmicos ("Basic" / "Paradise")
    - Profile Card na Sidebar (Avatar + Status)
    - Game Cards (Miniautras, Títulos, Subtítulos, Badges de Status)
    - Feature Banners / Top Widgets
    - Rodapé Promocional
    - Notificações, Elementos OOP e Animações Fluidas
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local CollieLib = {}
CollieLib.__index = CollieLib

-- Paletas de Cores Oficiais da Imagem
local Palettes = {
    Basic = {
        MainBgStart = Color3.fromRGB(110, 185, 255),
        MainBgEnd = Color3.fromRGB(40, 120, 220),
        SidebarBg = Color3.fromRGB(80, 150, 230),
        ContentBg = Color3.fromRGB(25, 75, 140),
        CardBg = Color3.fromRGB(35, 90, 160),
        Accent = Color3.fromRGB(80, 190, 255),
        AccentActive = Color3.fromRGB(40, 150, 230),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 215, 255),
        Stroke = Color3.fromRGB(140, 210, 255),
        Badge = Color3.fromRGB(60, 160, 240),
        White = Color3.fromRGB(255, 255, 255)
    },
    Paradise = {
        MainBgStart = Color3.fromRGB(15, 15, 35),
        MainBgEnd = Color3.fromRGB(5, 5, 15),
        SidebarBg = Color3.fromRGB(12, 12, 28),
        ContentBg = Color3.fromRGB(8, 10, 22),
        CardBg = Color3.fromRGB(16, 18, 38),
        Accent = Color3.fromRGB(130, 60, 240),
        AccentActive = Color3.fromRGB(170, 80, 255),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(160, 165, 200),
        Stroke = Color3.fromRGB(80, 50, 160),
        Badge = Color3.fromRGB(180, 40, 200),
        Gold = Color3.fromRGB(255, 200, 50),
        White = Color3.fromRGB(255, 255, 255)
    }
}

local TweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenInfoElastic = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Função para arrastar a janela
local function MakeDraggable(guiObject, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or guiObject

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(guiObject, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

------------------------------------------------------------------------
-- 1. WINDOW (CreateWindow)
------------------------------------------------------------------------
function CollieLib:CreateWindow(options)
    options = options or {}
    local themeName = options.Theme or "Paradise"
    local Palette = Palettes[themeName] or Palettes.Paradise

    local Window = {}
    setmetatable(Window, CollieLib)
    Window.Palette = Palette
    Window.Theme = themeName

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CollieHub_UI"
    ScreenGui.ResetOnSpawn = false

    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end

    -- Frame Principal (Tamanho Proporcional ao Mockup)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 750, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -375, 0.5, -240)
    MainFrame.BackgroundColor3 = Palette.MainBgStart
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 24)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Palette.Stroke
    MainStroke.Thickness = 2.5
    MainStroke.Parent = MainFrame

    -- Gradiente de Fundo
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Palette.MainBgStart),
        ColorSequenceKeypoint.new(1, Palette.MainBgEnd)
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = MainFrame

    -- Header / Barra Superior
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    MakeDraggable(MainFrame, Header)

    -- Info de Boas-Vindas no Header
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "HeaderTitle"
    TitleLabel.Size = UDim2.new(0, 300, 0, 22)
    TitleLabel.Position = UDim2.new(0, 180, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = (options.Title or "Collie Hub") .. " <font color='#" .. Palette.Badge:ToHex() .. "'>" .. (options.Edition or string.upper(themeName)) .. "</font>"
    TitleLabel.RichText = true
    TitleLabel.TextColor3 = Palette.TextPrimary
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 300, 0, 16)
    SubtitleLabel.Position = UDim2.new(0, 180, 0, 30)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = options.Subtitle or "Bem-vindo de volta, Collie! 👑"
    SubtitleLabel.TextColor3 = Palette.TextSecondary
    SubtitleLabel.TextSize = 11
    SubtitleLabel.Font = Enum.Font.FredokaOne
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = Header

    -- Botão Fechar Janela
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -34, 0, 12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 90)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Palette.White
    CloseBtn.Font = Enum.Font.FredokaOne
    CloseBtn.TextSize = 11
    CloseBtn.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfoFast, {Size = UDim2.new(0, 0, 0, 0)}).Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    -- Sidebar (Barra Lateral)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -20)
    Sidebar.Position = UDim2.new(0, 10, 0, 10)
    Sidebar.BackgroundColor3 = Palette.SidebarBg
    Sidebar.BackgroundTransparency = 0.2
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 18)
    SidebarCorner.Parent = Sidebar

    -- Perfil do Usuário na Sidebar
    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Name = "ProfileFrame"
    ProfileFrame.Size = UDim2.new(1, 0, 0, 60)
    ProfileFrame.BackgroundTransparency = 1
    ProfileFrame.Parent = Sidebar

    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Size = UDim2.new(0, 44, 0, 44)
    AvatarImage.Position = UDim2.new(0.5, -22, 0, 8)
    AvatarImage.BackgroundColor3 = Palette.Accent
    AvatarImage.Image = options.UserImage or "rbxassetid://6031075931" -- Placeholder
    AvatarImage.Parent = ProfileFrame

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = AvatarImage

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 10, 0, 10)
    StatusDot.Position = UDim2.new(1, -12, 1, -12)
    StatusDot.BackgroundColor3 = Color3.fromRGB(100, 230, 120)
    StatusDot.Parent = AvatarImage

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot

    -- Container das Abas da Sidebar
    local NavContainer = Instance.new("ScrollingFrame")
    NavContainer.Name = "NavContainer"
    NavContainer.Size = UDim2.new(1, -10, 1, -130)
    NavContainer.Position = UDim2.new(0, 5, 0, 70)
    NavContainer.BackgroundTransparency = 1
    NavContainer.ScrollBarThickness = 0
    NavContainer.Parent = Sidebar

    local NavList = Instance.new("UIListLayout")
    NavList.Padding = UDim.new(0, 6)
    NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NavList.Parent = NavContainer

    -- Card Inferior da Edição (Basic / Paradise Badge na Sidebar)
    local EditionCard = Instance.new("Frame")
    EditionCard.Size = UDim2.new(1, -16, 0, 45)
    EditionCard.Position = UDim2.new(0, 8, 1, -53)
    EditionCard.BackgroundColor3 = Palette.CardBg
    EditionCard.Parent = Sidebar

    local EdCorner = Instance.new("UICorner")
    EdCorner.CornerRadius = UDim.new(0, 12)
    EdCorner.Parent = EditionCard

    local EdTitle = Instance.new("TextLabel")
    EdTitle.Size = UDim2.new(1, 0, 0, 18)
    EdTitle.Position = UDim2.new(0, 0, 0, 6)
    EdTitle.BackgroundTransparency = 1
    EdTitle.Text = (options.Edition or string.upper(themeName)) .. " EDITION"
    EdTitle.TextColor3 = Palette.Badge
    EdTitle.Font = Enum.Font.FredokaOne
    EdTitle.TextSize = 11
    EdTitle.Parent = EditionCard

    local EdSub = Instance.new("TextLabel")
    EdSub.Size = UDim2.new(1, 0, 0, 14)
    EdSub.Position = UDim2.new(0, 0, 0, 22)
    EdSub.BackgroundTransparency = 1
    EdSub.Text = themeName == "Paradise" and "● Acesso Completo" or "🔒 Acesso Limitado"
    EdSub.TextColor3 = Palette.TextSecondary
    EdSub.Font = Enum.Font.FredokaOne
    EdSub.TextSize = 9
    EdSub.Parent = EditionCard

    -- Container Central de Conteúdo
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -185, 1, -65)
    ContentContainer.Position = UDim2.new(0, 175, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    -- Animação de Entrada
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfoElastic, {Size = UDim2.new(0, 750, 0, 480)}):Play()

    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.NavContainer = NavContainer
    Window.ContentContainer = ContentContainer
    Window.Tabs = {}
    Window.ActiveTab = nil

    return Window
end

------------------------------------------------------------------------
-- SISTEMA DE ABAS (:CreateTab)
------------------------------------------------------------------------
function CollieLib:CreateTab(tab_name, icon_id)
    local Tab = {}
    local Window = self
    local Palette = Window.Palette

    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = "TabBtn_" .. tab_name
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = Palette.Accent
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = (icon_id and "  " or "") .. tab_name
    TabBtn.TextColor3 = Palette.TextSecondary
    TabBtn.Font = Enum.Font.FredokaOne
    TabBtn.TextSize = 12
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = Window.NavContainer

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Name = "Page_" .. tab_name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Palette.Accent
    Page.Visible = false
    Page.Parent = Window.ContentContainer

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 10)
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Parent = Page

    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
    end)

    Tab.Page = Page
    Tab.Button = TabBtn
    Tab.Window = Window

    local function SelectTab()
        for _, t in pairs(Window.Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Button, TweenInfoFast, {BackgroundTransparency = 1, TextColor3 = Palette.TextSecondary}):Play()
        end
        Page.Visible = true
        Window.ActiveTab = Tab
        TweenService:Create(TabBtn, TweenInfoFast, {BackgroundTransparency = 0, TextColor3 = Palette.White}):Play()
    end

    TabBtn.MouseButton1Click:Connect(SelectTab)
    table.insert(Window.Tabs, Tab)

    if #Window.Tabs == 1 then SelectTab() end

    setmetatable(Tab, {__index = CollieLib})
    return Tab
end

------------------------------------------------------------------------
-- WIDGET DE DESTAQUE / BANNER TOP (:CreateHeaderWidgets)
------------------------------------------------------------------------
function CollieLib:CreateHeaderWidgets(widgetsData)
    local GridFrame = Instance.new("Frame")
    GridFrame.Size = UDim2.new(1, -10, 0, 50)
    GridFrame.BackgroundTransparency = 1
    GridFrame.Parent = self.Page

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = GridFrame

    local count = #widgetsData
    for _, item in ipairs(widgetsData) do
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1 / count, -((count - 1) * 8 / count), 1, 0)
        Card.BackgroundColor3 = self.Window.Palette.CardBg
        Card.Parent = GridFrame

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = Card

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -10, 0, 18)
        Title.Position = UDim2.new(0, 8, 0, 8)
        Title.BackgroundTransparency = 1
        Title.Text = item.Title or ""
        Title.TextColor3 = self.Window.Palette.TextPrimary
        Title.Font = Enum.Font.FredokaOne
        Title.TextSize = 11
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Card

        local Sub = Instance.new("TextLabel")
        Sub.Size = UDim2.new(1, -10, 0, 14)
        Sub.Position = UDim2.new(0, 8, 0, 26)
        Sub.BackgroundTransparency = 1
        Sub.Text = item.Sub or ""
        Sub.TextColor3 = self.Window.Palette.TextSecondary
        Sub.Font = Enum.Font.FredokaOne
        Sub.TextSize = 9
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.Parent = Card
    end
end

------------------------------------------------------------------------
-- GRADE DE JOGOS (:CreateGameGrid & :AddGameCard)
------------------------------------------------------------------------
function CollieLib:CreateGameGrid()
    local Container = Instance.new("Frame")
    Container.Name = "GameGrid"
    Container.Size = UDim2.new(1, -10, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = self.Page

    local Grid = Instance.new("UIGridLayout")
    Grid.CellSize = UDim2.new(0, 130, 0, 140)
    Grid.CellPadding = UDim2.new(0, 10, 0, 10)
    Grid.SortOrder = Enum.SortOrder.LayoutOrder
    Grid.Parent = Container

    Grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.Size = UDim2.new(1, -10, 0, Grid.AbsoluteContentSize.Y)
    end)

    local GridObj = {Container = Container, Window = self.Window}

    function GridObj:AddGameCard(title, accessText, tagText, imageId, callback)
        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = GridObj.Window.Palette.CardBg
        Card.Parent = Container

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Card

        local Img = Instance.new("ImageLabel")
        Img.Size = UDim2.new(1, 0, 0, 75)
        Img.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Img.Image = imageId or "rbxassetid://6031075931"
        Img.ClipsDescendants = true
        Img.Parent = Card

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 12)
        ImgCorner.Parent = Img

        local GTitle = Instance.new("TextLabel")
        GTitle.Size = UDim2.new(1, -10, 0, 16)
        GTitle.Position = UDim2.new(0, 6, 0, 80)
        GTitle.BackgroundTransparency = 1
        GTitle.Text = title
        GTitle.TextColor3 = GridObj.Window.Palette.TextPrimary
        GTitle.Font = Enum.Font.FredokaOne
        GTitle.TextSize = 11
        GTitle.TextXAlignment = Enum.TextXAlignment.Left
        GTitle.Parent = Card

        local GAcc = Instance.new("TextLabel")
        GAcc.Size = UDim2.new(1, -10, 0, 12)
        GAcc.Position = UDim2.new(0, 6, 0, 96)
        GAcc.BackgroundTransparency = 1
        GAcc.Text = accessText or "Acesso: Completo"
        GAcc.TextColor3 = GridObj.Window.Palette.TextSecondary
        GAcc.Font = Enum.Font.FredokaOne
        GAcc.TextSize = 9
        GAcc.TextXAlignment = Enum.TextXAlignment.Left
        GAcc.Parent = Card

        local Badge = Instance.new("TextButton")
        Badge.Size = UDim2.new(0, 70, 0, 18)
        Badge.Position = UDim2.new(0, 6, 0, 114)
        Badge.BackgroundColor3 = GridObj.Window.Palette.Badge
        Badge.Text = tagText or "PARADISE"
        Badge.TextColor3 = GridObj.Window.Palette.White
        Badge.Font = Enum.Font.FredokaOne
        Badge.TextSize = 9
        Badge.Parent = Card

        local BadgeCorner = Instance.new("UICorner")
        BadgeCorner.CornerRadius = UDim.new(1, 0)
        BadgeCorner.Parent = Badge

        Badge.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
    end

    return GridObj
end

------------------------------------------------------------------------
-- ELEMENTOS PADRÃO (Toggle, Button, Slider)
------------------------------------------------------------------------
function CollieLib:CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 36)
    Btn.BackgroundColor3 = self.Window.Palette.Accent
    Btn.Text = text
    Btn.TextColor3 = self.Window.Palette.White
    Btn.Font = Enum.Font.FredokaOne
    Btn.TextSize = 12
    Btn.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

function CollieLib:CreateToggle(text, default, callback)
    local state = default or false
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 36)
    Frame.BackgroundColor3 = self.Window.Palette.CardBg
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = self.Window.Palette.TextPrimary
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, -10)
    Switch.BackgroundColor3 = state and self.Window.Palette.Accent or Color3.fromRGB(60, 60, 80)
    Switch.Text = ""
    Switch.Parent = Frame

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    Switch.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Switch, TweenInfoFast, {BackgroundColor3 = state and self.Window.Palette.Accent or Color3.fromRGB(60, 60, 80)}):Play()
        if callback then callback(state) end
    end)
end

return CollieLib
