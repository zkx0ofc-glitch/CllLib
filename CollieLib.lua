--[[
    ========================================================================
    CollieLib - UI Library (Pastel / Cartoon / Clean Edition)
    ========================================================================
    Desenvolvida para Roblox UI (ScreenGui, Frame, UICorner, UIStroke, TweenService).
    Estética: Pastel Blue, Cantos Arredondados, Animações Elásticas e Smooth.
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local CollieLib = {}
CollieLib.__index = CollieLib

-- Palette de Cores Pastel / Aesthetic
local Palette = {
    MainBg = Color3.fromRGB(180, 210, 240),        -- Azul pastel médio
    ContentBg = Color3.fromRGB(240, 248, 255),     -- Azul-claro suave / Quase branco
    SidebarBg = Color3.fromRGB(160, 195, 230),     -- Azul ligeiramente mais escuro para a barra lateral
    Accent = Color3.fromRGB(120, 180, 245),        -- Azul-bebê brilhante
    AccentActive = Color3.fromRGB(80, 150, 235),   -- Azul ativado
    TextPrimary = Color3.fromRGB(50, 70, 90),      -- Texto escuro suave
    TextSecondary = Color3.fromRGB(110, 130, 150),  -- Texto secundário
    Stroke = Color3.fromRGB(210, 230, 250),        -- Bordas suaves
    White = Color3.fromRGB(255, 255, 255),
    
    -- Cores das Tags
    Tags = {
        NEW = Color3.fromRGB(100, 200, 255),
        BETA = Color3.fromRGB(180, 150, 240),
        RELEASE = Color3.fromRGB(130, 220, 150),
        REMOVED = Color3.fromRGB(240, 130, 130),
        UPDATING = Color3.fromRGB(250, 210, 120)
    }
}

-- Configurações Padrão de Animação
local TweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenInfoBounce = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
local TweenInfoElastic = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Função utilitária para aplicar animações de escala e cor (Feedback Animado)
local function AddHoverClickFeedback(guiObject, normalSize, hoverSize, normalColor, hoverColor)
    guiObject.MouseEnter:Connect(function()
        TweenService:Create(guiObject, TweenInfoFast, {
            Size = hoverSize,
            BackgroundColor3 = hoverColor or guiObject.BackgroundColor3
        }):Play()
    end)
    
    guiObject.MouseLeave:Connect(function()
        TweenService:Create(guiObject, TweenInfoFast, {
            Size = normalSize,
            BackgroundColor3 = normalColor or guiObject.BackgroundColor3
        }):Play()
    end)
    
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local clickSize = UDim2.new(normalSize.X.Scale * 0.93, normalSize.X.Offset * 0.93, normalSize.Y.Scale * 0.93, normalSize.Y.Offset * 0.93)
            local tweenClick = TweenService:Create(guiObject, TweenInfoFast, {Size = clickSize})
            tweenClick:Play()
            tweenClick.Completed:Connect(function()
                TweenService:Create(guiObject, TweenInfoElastic, {Size = normalSize}):Play()
            end)
        end
    end)
end

-- Função para Criar Tag Fofinha
local function CreateTagLabel(parent, tagType)
    if not tagType or not Palette.Tags[string.upper(tagType)] then return end
    
    local tagBg = Instance.new("Frame")
    tagBg.Name = "Tag_" .. tagType
    tagBg.Size = UDim2.new(0, 55, 0, 18)
    tagBg.Position = UDim2.new(1, -60, 0.5, -9)
    tagBg.BackgroundColor3 = Palette.Tags[string.upper(tagType)]
    tagBg.BorderSizePixel = 0
    tagBg.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = tagBg
    
    local tagText = Instance.new("TextLabel")
    tagText.Size = UDim2.new(1, 0, 1, 0)
    tagText.BackgroundTransparency = 1
    tagText.Text = string.upper(tagType)
    tagText.TextColor3 = Palette.White
    tagText.TextSize = 10
    tagText.Font = Enum.Font.FredokaOne
    tagText.Parent = tagBg
end

------------------------------------------------------------------------
-- 1. WINDOW (CreateWindow)
------------------------------------------------------------------------
function CollieLib:CreateWindow(title, subtitle)
    local Window = {}
    setmetatable(Window, CollieLib)
    
    -- Criando ScreenGui Principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CollieLib_UI"
    ScreenGui.ResetOnSpawn = false
    
    -- Proteção de montagem
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Janela Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Palette.MainBg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Palette.Stroke
    MainStroke.Thickness = 3
    MainStroke.Parent = MainFrame

    -- Barra Superior (Header)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 300, 0, 25)
    TitleLabel.Position = UDim2.new(0, 20, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = (title or "CollieLib") .. " <font color='#80B0F0'>" .. (subtitle or "v1.0") .. "</font>"
    TitleLabel.RichText = true
    TitleLabel.TextColor3 = Palette.TextPrimary
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    -- Botões Fofos de Fechar e Ocultar
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -36, 0, 10)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 140)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Palette.White
    CloseBtn.Font = Enum.Font.FredokaOne
    CloseBtn.TextSize = 12
    CloseBtn.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn
    
    AddHoverClickFeedback(CloseBtn, UDim2.new(0, 26, 0, 26), UDim2.new(0, 28, 0, 28), Color3.fromRGB(255, 140, 140), Color3.fromRGB(255, 100, 100))
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfoFast, {Size = UDim2.new(0, 0, 0, 0)}).Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Barra Lateral Left (Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -55)
    Sidebar.Position = UDim2.new(0, 12, 0, 45)
    Sidebar.BackgroundColor3 = Palette.SidebarBg
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 16)
    SidebarCorner.Parent = Sidebar
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 6)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    -- Container Central (Conteúdo)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -186, 1, -55)
    ContentContainer.Position = UDim2.new(0, 172, 0, 45)
    ContentContainer.BackgroundColor3 = Palette.ContentBg
    ContentContainer.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 16)
    ContentCorner.Parent = ContentContainer

    -- Animação de Entrada
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfoElastic, {Size = UDim2.new(0, 580, 0, 380)}):Play()

    -- Referências do objeto
    Window.MainFrame = MainFrame
    Window.Sidebar = Sidebar
    Window.ContentContainer = ContentContainer
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Sistema de Favoritos Integrado
    Window:CreateFavorites()
    
    return Window
end

------------------------------------------------------------------------
-- 12. SEARCH BAR (EnableSearchBar)
------------------------------------------------------------------------
function CollieLib:EnableSearchBar()
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchBar"
    SearchFrame.Size = UDim2.new(0, 180, 0, 26)
    SearchFrame.Position = UDim2.new(1, -220, 0, 10)
    SearchFrame.BackgroundColor3 = Palette.White
    SearchFrame.Parent = self.MainFrame:FindFirstChild("Header")
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = SearchFrame
    
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, -20, 1, 0)
    Box.Position = UDim2.new(0, 10, 0, 0)
    Box.BackgroundTransparency = 1
    Box.PlaceholderText = "Pesquisar..."
    Box.Text = ""
    Box.TextColor3 = Palette.TextPrimary
    Box.Font = Enum.Font.FredokaOne
    Box.TextSize = 12
    Box.TextXAlignment = Enum.TextXAlignment.Left
    Box.Parent = SearchFrame
    
    Box:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(Box.Text)
        if self.ActiveTab then
            for _, item in ipairs(self.ActiveTab.Page:GetChildren()) do
                if item:IsA("Frame") and item:FindFirstChild("Title") then
                    local titleText = string.lower(item.Title.Text)
                    item.Visible = string.find(titleText, query) ~= nil
                end
            end
        end
    end)
end

------------------------------------------------------------------------
-- 2. TABS (CreateTab)
------------------------------------------------------------------------
function CollieLib:CreateTab(tab_name, icon_id)
    local Tab = {}
    local Window = self
    
    -- Botão da Aba
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = "TabBtn_" .. tab_name
    TabBtn.Size = UDim2.new(0, 130, 0, 32)
    TabBtn.BackgroundColor3 = Palette.White
    TabBtn.BackgroundTransparency = 0.5
    TabBtn.Text = (icon_id and "  " or "") .. tab_name
    TabBtn.TextColor3 = Palette.TextPrimary
    TabBtn.Font = Enum.Font.FredokaOne
    TabBtn.TextSize = 13
    TabBtn.Parent = Window.Sidebar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = TabBtn
    
    -- Página da Aba (Container com UIListLayout Seguro)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = "Page_" .. tab_name
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Palette.Accent
    Page.Visible = false
    Page.Parent = Window.ContentContainer
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Parent = Page
    
    -- Ajuste Automático de Tamanho do Scroll
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 15)
    end)
    
    Tab.Page = Page
    Tab.Button = TabBtn
    Tab.Window = Window
    
    local function SelectTab()
        for _, t in pairs(Window.Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Button, TweenInfoFast, {BackgroundTransparency = 0.5, BackgroundColor3 = Palette.White}):Play()
        end
        Page.Visible = true
        Window.ActiveTab = Tab
        TweenService:Create(TabBtn, TweenInfoFast, {BackgroundTransparency = 0, BackgroundColor3 = Palette.Accent}):Play()
    end
    
    TabBtn.MouseButton1Click:Connect(SelectTab)
    
    table.insert(Window.Tabs, Tab)
    
    -- Seleciona a primeira aba por padrão
    if #Window.Tabs == 1 then
        SelectTab()
    end
    
    setmetatable(Tab, {__index = CollieLib})
    return Tab
end

------------------------------------------------------------------------
-- 11. FAVORITES SYSTEM (CreateFavorites)
------------------------------------------------------------------------
function CollieLib:CreateFavorites()
    if self.FavoritesTab then return end
    self.FavoritesTab = self:CreateTab("★ Favoritos")
end

local function AttachFavoriteStar(elementFrame, pageContainer, window)
    local StarBtn = Instance.new("TextButton")
    StarBtn.Name = "StarBtn"
    StarBtn.Size = UDim2.new(0, 20, 0, 20)
    StarBtn.Position = UDim2.new(1, -26, 0, 6)
    StarBtn.BackgroundTransparency = 1
    StarBtn.Text = "☆"
    StarBtn.TextColor3 = Palette.AccentActive
    StarBtn.Font = Enum.Font.FredokaOne
    StarBtn.TextSize = 16
    StarBtn.Parent = elementFrame

    local isFav = false
    StarBtn.MouseButton1Click:Connect(function()
        isFav = not isFav
        StarBtn.Text = isFav and "★" or "☆"
        
        if isFav and window.FavoritesTab then
            elementFrame.Parent = window.FavoritesTab.Page
        else
            elementFrame.Parent = pageContainer
        end
    end)
end

------------------------------------------------------------------------
-- 3. SUBTABS (CreateSubTab)
------------------------------------------------------------------------
function CollieLib:CreateSubTab(sub_tab_name)
    local SubContainer = self.Page:FindFirstChild("SubTabNav")
    if not SubContainer then
        SubContainer = Instance.new("Frame")
        SubContainer.Name = "SubTabNav"
        SubContainer.Size = UDim2.new(1, 0, 0, 30)
        SubContainer.BackgroundTransparency = 1
        SubContainer.Parent = self.Page
        
        local SubList = Instance.new("UIListLayout")
        SubList.FillDirection = Enum.FillDirection.Horizontal
        SubList.Padding = UDim.new(0, 6)
        SubList.Parent = SubContainer
    end
    
    local SubBtn = Instance.new("TextButton")
    SubBtn.Size = UDim2.new(0, 80, 0, 24)
    SubBtn.BackgroundColor3 = Palette.Accent
    SubBtn.Text = sub_tab_name
    SubBtn.TextColor3 = Palette.White
    SubBtn.Font = Enum.Font.FredokaOne
    SubBtn.TextSize = 11
    SubBtn.Parent = SubContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = SubBtn
end

------------------------------------------------------------------------
-- 4. SECTION (CreateSection)
------------------------------------------------------------------------
function CollieLib:CreateSection(section_title, tag)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "Section"
    SectionFrame.Size = UDim2.new(1, 0, 0, 25)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = self.Page
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 150, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = string.upper(section_title)
    Title.TextColor3 = Palette.TextSecondary
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = SectionFrame
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, -160, 0, 2)
    Line.Position = UDim2.new(0, 155, 0.5, -1)
    Line.BackgroundColor3 = Palette.Stroke
    Line.BorderSizePixel = 0
    Line.Parent = SectionFrame
    
    CreateTagLabel(SectionFrame, tag)
end

------------------------------------------------------------------------
-- 5. TOGGLE (CreateToggle)
------------------------------------------------------------------------
function CollieLib:CreateToggle(text, default, callback, tag)
    local state = default or false
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Palette.White
    Frame.Parent = self.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = Palette.TextPrimary
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame
    
    -- Switch
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 42, 0, 22)
    Switch.Position = UDim2.new(1, -75, 0.5, -11)
    Switch.BackgroundColor3 = state and Palette.Accent or Color3.fromRGB(220, 225, 230)
    Switch.Text = ""
    Switch.Parent = Frame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Knob.BackgroundColor3 = Palette.White
    Knob.Parent = Switch
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    local function Toggle()
        state = not state
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local targetColor = state and Palette.Accent or Color3.fromRGB(220, 225, 230)
        
        TweenService:Create(Knob, TweenInfoFast, {Position = targetPos}):Play()
        TweenService:Create(Switch, TweenInfoFast, {BackgroundColor3 = targetColor}):Play()
        
        if callback then callback(state) end
    end
    
    Switch.MouseButton1Click:Connect(Toggle)
    AttachFavoriteStar(Frame, self.Page, self.Window)
    CreateTagLabel(Frame, tag)
end

------------------------------------------------------------------------
-- 6. BUTTON (CreateButton)
------------------------------------------------------------------------
function CollieLib:CreateButton(text, callback, tag)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundTransparency = 1
    Frame.Parent = self.Page
    
    local Btn = Instance.new("TextButton")
    Btn.Name = "Title"
    Btn.Size = UDim2.new(1, -35, 1, 0)
    Btn.BackgroundColor3 = Palette.Accent
    Btn.Text = text
    Btn.TextColor3 = Palette.White
    Btn.Font = Enum.Font.FredokaOne
    Btn.TextSize = 13
    Btn.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Btn
    
    AddHoverClickFeedback(Btn, UDim2.new(1, -35, 1, 0), UDim2.new(1, -30, 1, 2), Palette.Accent, Palette.AccentActive)
    
    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    AttachFavoriteStar(Frame, self.Page, self.Window)
    CreateTagLabel(Frame, tag)
end

------------------------------------------------------------------------
-- 7. SLIDER (CreateSlider)
------------------------------------------------------------------------
function CollieLib:CreateSlider(text, min, max, default, callback)
    local Value = default or min
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Palette.White
    Frame.Parent = self.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.5, 0, 0, 20)
    Title.Position = UDim2.new(0, 12, 0, 4)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = Palette.TextPrimary
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -85, 0, 4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(Value)
    ValueLabel.TextColor3 = Palette.TextSecondary
    ValueLabel.Font = Enum.Font.FredokaOne
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame
    
    local BarBg = Instance.new("TextButton")
    BarBg.Size = UDim2.new(1, -60, 0, 8)
    BarBg.Position = UDim2.new(0, 12, 0, 28)
    BarBg.BackgroundColor3 = Color3.fromRGB(220, 225, 230)
    BarBg.Text = ""
    BarBg.Parent = Frame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BarBg
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Value - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Palette.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        Value = math.floor(min + ((max - min) * pos))
        ValueLabel.Text = tostring(Value)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        if callback then callback(Value) end
    end
    
    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
    end)
    
    AttachFavoriteStar(Frame, self.Page, self.Window)
end

------------------------------------------------------------------------
-- 8. DROPDOWN (CreateDropdown)
------------------------------------------------------------------------
function CollieLib:CreateDropdown(text, options, callback)
    local expanded = false
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Palette.White
    Frame.ClipsDescendants = true
    Frame.Parent = self.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Title"
    ToggleBtn.Size = UDim2.new(1, 0, 0, 36)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = "  " .. text
    ToggleBtn.TextColor3 = Palette.TextPrimary
    ToggleBtn.Font = Enum.Font.FredokaOne
    ToggleBtn.TextSize = 13
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.Parent = Frame
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -55, 0, 8)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Palette.TextSecondary
    Arrow.Font = Enum.Font.FredokaOne
    Arrow.Parent = ToggleBtn
    
    local OptContainer = Instance.new("Frame")
    OptContainer.Size = UDim2.new(1, -20, 0, #options * 24)
    OptContainer.Position = UDim2.new(0, 10, 0, 36)
    OptContainer.BackgroundTransparency = 1
    OptContainer.Parent = Frame
    
    local OptList = Instance.new("UIListLayout")
    OptList.Padding = UDim.new(0, 2)
    OptList.Parent = OptContainer
    
    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 22)
        OptBtn.BackgroundColor3 = Palette.ContentBg
        OptBtn.Text = opt
        OptBtn.TextColor3 = Palette.TextPrimary
        OptBtn.Font = Enum.Font.FredokaOne
        OptBtn.TextSize = 11
        OptBtn.Parent = OptContainer
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 6)
        OptCorner.Parent = OptBtn
        
        OptBtn.MouseButton1Click:Connect(function()
            ToggleBtn.Text = "  " .. text .. " (" .. opt .. ")"
            expanded = false
            TweenService:Create(Frame, TweenInfoFast, {Size = UDim2.new(1, 0, 0, 36)}):Play()
            Arrow.Text = "▼"
            if callback then callback(opt) end
        end)
    end
    
    ToggleBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        local targetSize = expanded and UDim2.new(1, 0, 0, 40 + (#options * 26)) or UDim2.new(1, 0, 0, 36)
        TweenService:Create(Frame, TweenInfoFast, {Size = targetSize}):Play()
        Arrow.Text = expanded and "▲" or "▼"
    end)
    
    AttachFavoriteStar(Frame, self.Page, self.Window)
end

------------------------------------------------------------------------
-- 9. HOTKEY (CreateHotkey)
------------------------------------------------------------------------
function CollieLib:CreateHotkey(text, defaultKey, callback)
    local currentKey = defaultKey or Enum.KeyCode.E
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Palette.White
    Frame.Parent = self.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = Palette.TextPrimary
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame
    
    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0, 60, 0, 22)
    KeyBtn.Position = UDim2.new(1, -95, 0.5, -11)
    KeyBtn.BackgroundColor3 = Palette.Accent
    KeyBtn.Text = currentKey.Name
    KeyBtn.TextColor3 = Palette.White
    KeyBtn.Font = Enum.Font.FredokaOne
    KeyBtn.TextSize = 11
    KeyBtn.Parent = Frame
    
    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 6)
    KeyCorner.Parent = KeyBtn
    
    local listening = false
    KeyBtn.MouseButton1Click:Connect(function()
        listening = true
        KeyBtn.Text = "..."
    end)
    
    UserInputService.InputBegan:Connect(function(input, gpe)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            currentKey = input.KeyCode
            KeyBtn.Text = currentKey.Name
            if callback then callback(currentKey) end
        end
    end)
    
    AttachFavoriteStar(Frame, self.Page, self.Window)
end

------------------------------------------------------------------------
-- 10. SHORTCUT (CreateShortcut)
------------------------------------------------------------------------
function CollieLib:CreateShortcut(text, callback)
    self:CreateButton("⚡ " .. text, callback)
end

return CollieLib
