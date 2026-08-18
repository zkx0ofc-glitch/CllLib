-- ========================================================================
-- COLLIELIB v2.0 - REESCRITA DO ZERO (OOP)
-- Estética Cartoon Pastel com Animações Elásticas
-- ========================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local CollieLib = {}
CollieLib.__index = CollieLib

-- Paleta de Temas
CollieLib.Themes = {
    ["Azul Clássico Collie"] = {
        Background = Color3.fromRGB(180, 210, 245),
        Header = Color3.fromRGB(150, 190, 235),
        Sidebar = Color3.fromRGB(165, 200, 240),
        Card = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(50, 70, 95),
        Accent = Color3.fromRGB(100, 160, 230)
    },
    ["Midnight Pastel"] = {
        Background = Color3.fromRGB(35, 45, 60),
        Header = Color3.fromRGB(25, 35, 50),
        Sidebar = Color3.fromRGB(30, 40, 55),
        Card = Color3.fromRGB(45, 58, 75),
        Text = Color3.fromRGB(220, 235, 245),
        Accent = Color3.fromRGB(80, 180, 210)
    }
}

CollieLib.StatusTags = {
    ["NEW"] = Color3.fromRGB(100, 180, 255),
    ["BETA"] = Color3.fromRGB(180, 140, 245),
    ["RELEASE"] = Color3.fromRGB(120, 220, 150),
    ["REMOVED"] = Color3.fromRGB(230, 100, 110),
    ["UPDATING"] = Color3.fromRGB(245, 200, 90)
}

local function ElasticTween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function LinearTween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

-- ------------------------------------------------------------------------
-- JANELA PRINCIPAL (WINDOW)
-- ------------------------------------------------------------------------
function CollieLib:CreateWindow(title, subtitle)
    local Window = setmetatable({}, CollieLib)
    Window.Theme = CollieLib.Themes["Azul Clássico Collie"]
    Window.Tabs = {}
    Window.ActiveTab = nil

    -- Gui Principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CollieLib_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    Window.ScreenGui = ScreenGui

    -- Frame Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Window.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Window.MainFrame = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Animação Pop de Abertura
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    ElasticTween(MainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.45)

    -- Header / Cabeçalho
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Window.Theme.Header
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    Window.Header = Header

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title or "CollieLib"
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Window.Theme.Text
    TitleLabel.Position = UDim2.new(0, 15, 0, 6)
    TitleLabel.Size = UDim2.new(0, 200, 0, 18)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Text = subtitle or "v2.0 UI"
    SubLabel.Font = Enum.Font.SourceSansBold
    SubLabel.TextSize = 12
    SubLabel.TextColor3 = Window.Theme.Text
    SubLabel.TextTransparency = 0.3
    SubLabel.Position = UDim2.new(0, 15, 0, 24)
    SubLabel.Size = UDim2.new(0, 200, 0, 14)
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubLabel.BackgroundTransparency = 1
    SubLabel.Parent = Header

    -- Barra Lateral (Sidebar)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.new(0, 10, 0, 52)
    Sidebar.Size = UDim2.new(0, 140, 1, -62)
    Sidebar.BackgroundColor3 = Window.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Window.Sidebar = Sidebar

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 12)
    SideCorner.Parent = Sidebar

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Padding = UDim.new(0, 6)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Parent = Sidebar

    local SidePadding = Instance.new("UIPadding")
    SidePadding.PaddingTop = UDim.new(0, 6)
    SidePadding.Parent = Sidebar

    -- Contêiner do Conteúdo das Abas
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Position = UDim2.new(0, 160, 0, 52)
    ContentHolder.Size = UDim2.new(1, -170, 1, -62)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame
    Window.ContentHolder = ContentHolder

    Window:EnableSmoothDrag()

    return Window
end

-- ------------------------------------------------------------------------
-- CLASSE TAB (ABAS E ELEMENTOS INCLUÍDOS)
-- ------------------------------------------------------------------------
local TabClass = {}
TabClass.__index = TabClass

function CollieLib:CreateTab(tab_name)
    local Tab = setmetatable({}, TabClass)
    Tab.Window = self

    -- ScrollingFrame da Página
    local Page = Instance.new("ScrollingFrame")
    Page.Name = tab_name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = self.Theme.Accent
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = false
    Page.Parent = self.ContentHolder
    Tab.Page = Page

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 4)
    Padding.PaddingLeft = UDim.new(0, 4)
    Padding.PaddingRight = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)
    Padding.Parent = Page

    -- Botão na Sidebar
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 30)
    TabButton.BackgroundColor3 = self.Theme.Card
    TabButton.Text = tab_name
    TabButton.Font = Enum.Font.FredokaOne
    TabButton.TextSize = 12
    TabButton.TextColor3 = self.Theme.Text
    TabButton.Parent = self.Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = TabButton

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
        end
        Tab.Page.Visible = true
        self.ActiveTab = Tab
    end)

    table.insert(self.Tabs, Tab)

    -- Abre a primeira aba automaticamente
    if #self.Tabs == 1 then
        Tab.Page.Visible = true
        self.ActiveTab = Tab
    end

    return Tab
end

-- ------------------------------------------------------------------------
-- COMPONENTES DAS ABAS
-- ------------------------------------------------------------------------
function TabClass:AttachTag(parent, tag_type)
    if not CollieLib.StatusTags[tag_type] then return end
    local Tag = Instance.new("TextLabel")
    Tag.Size = UDim2.new(0, 48, 0, 16)
    Tag.Position = UDim2.new(1, -52, 0.5, -8)
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

function TabClass:CreateSection(title, tag)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 22)
    Frame.BackgroundTransparency = 1
    Frame.Parent = self.Page

    local Label = Instance.new("TextLabel")
    Label.Text = title
    Label.Font = Enum.Font.FredokaOne
    Label.TextSize = 13
    Label.TextColor3 = self.Window.Theme.Text
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    if tag then self:AttachTag(Frame, tag) end
end

function TabClass:CreateButton(text, callback, tag)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = self.Window.Theme.Card
    Btn.Text = "  " .. text
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 13
    Btn.TextColor3 = self.Window.Theme.Text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    if tag then self:AttachTag(Btn, tag) end

    Btn.MouseButton1Click:Connect(function()
        ElasticTween(Btn, {Size = UDim2.new(1, -6, 0, 28)}, 0.1)
        task.wait(0.1)
        ElasticTween(Btn, {Size = UDim2.new(1, 0, 0, 32)}, 0.15)
        pcall(callback)
    end)
end

function TabClass:CreateToggle(text, default_state, callback)
    local state = default_state or false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = self.Window.Theme.Card
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. text
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextColor3 = self.Window.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 38, 0, 18)
    Switch.Position = UDim2.new(1, -44, 0.5, -9)
    Switch.BackgroundColor3 = state and self.Window.Theme.Accent or Color3.fromRGB(200, 200, 200)
    Switch.Parent = Frame

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
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
        state = not state
        ElasticTween(Dot, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.25)
        LinearTween(Switch, {BackgroundColor3 = state and self.Window.Theme.Accent or Color3.fromRGB(200, 200, 200)}, 0.15)
        pcall(callback, state)
    end)
end

function TabClass:CreateSlider(text, min, max, default, allow_typing, callback)
    local value = default or min

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 42)
    Frame.BackgroundColor3 = self.Window.Theme.Card
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. text
    Label.Position = UDim2.new(0, 0, 0, 2)
    Label.Size = UDim2.new(0.5, 0, 0, 18)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextColor3 = self.Window.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local ValInput = Instance.new("TextBox")
    ValInput.Text = tostring(value)
    ValInput.Position = UDim2.new(1, -45, 0, 2)
    ValInput.Size = UDim2.new(0, 35, 0, 18)
    ValInput.Font = Enum.Font.FredokaOne
    ValInput.TextColor3 = self.Window.Theme.Text
    ValInput.BackgroundTransparency = 1
    ValInput.TextEditable = allow_typing
    ValInput.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.new(0, 10, 0, 26)
    Bar.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    Bar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = self.Window.Theme.Accent
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local dragging = false
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
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

function TabClass:CreateDropdown(text, list_options, is_multi_select, callback)
    local open = false
    local selected = {}

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = self.Window.Theme.Card
    Frame.ClipsDescendants = true
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.Text = "  " .. text .. "  v"
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextColor3 = self.Window.Theme.Text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BackgroundTransparency = 1
    Btn.Parent = Frame

    local OptionHolder = Instance.new("Frame")
    OptionHolder.Position = UDim2.new(0, 0, 0, 32)
    OptionHolder.Size = UDim2.new(1, 0, 0, #list_options * 24)
    OptionHolder.BackgroundTransparency = 1
    OptionHolder.Parent = Frame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 2)
    Layout.Parent = OptionHolder

    for _, opt in ipairs(list_options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, -10, 0, 22)
        OptBtn.Position = UDim2.new(0, 5, 0, 0)
        OptBtn.Text = opt
        OptBtn.Font = Enum.Font.SourceSans
        OptBtn.TextColor3 = self.Window.Theme.Text
        OptBtn.BackgroundColor3 = self.Window.Theme.Background
        OptBtn.Parent = OptionHolder

        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 4)
        OptCorner.Parent = OptBtn

        OptBtn.MouseButton1Click:Connect(function()
            if is_multi_select then
                table.insert(selected, opt)
                pcall(callback, selected)
            else
                Btn.Text = "  " .. text .. " (" .. opt .. ")"
                pcall(callback, opt)
            end
        end)
    end

    Btn.MouseButton1Click:Connect(function()
        open = not open
        ElasticTween(Frame, {Size = UDim2.new(1, 0, 0, open and (36 + #list_options * 24) or 32)}, 0.3)
    end)
end

function TabClass:CreateTextBox(text, place_holder, numbers_only, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = self.Window.Theme.Card
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
    Input.TextColor3 = self.Window.Theme.Text
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
-- MÉTODOS UTILITÁRIOS DA JANELA
-- ------------------------------------------------------------------------
function CollieLib:EnableSmoothDrag()
    local dragging, dragStart, startPos

    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            LinearTween(self.MainFrame, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.08)
        end
    end)
end

function CollieLib:EnableSearchBar()
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(0, 130, 0, 22)
    SearchBox.Position = UDim2.new(1, -145, 0, 11)
    SearchBox.PlaceholderText = "Buscar..."
    SearchBox.Text = ""
    SearchBox.Font = Enum.Font.SourceSans
    SearchBox.TextSize = 12
    SearchBox.BackgroundColor3 = self.Theme.Card
    SearchBox.Parent = self.Header

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SearchBox

    SearchBox.Changed:Connect(function()
        local query = SearchBox.Text:lower()
        if self.ActiveTab then
            for _, item in pairs(self.ActiveTab.Page:GetChildren()) do
                if item:IsA("Frame") or item:IsA("TextButton") then
                    local textLabel = item:FindFirstChildOfClass("TextLabel") or item
                    if textLabel and textLabel.Text then
                        item.Visible = string.find(textLabel.Text:lower(), query) ~= nil
                    end
                end
            end
        end
    end)
end

function CollieLib:Notify(title, text, duration)
    duration = duration or 3
    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(0, 200, 0, 50)
    Toast.Position = UDim2.new(1, -215, 1, -65)
    Toast.BackgroundColor3 = self.Theme.Card
    Toast.Parent = self.ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Toast

    local TTitle = Instance.new("TextLabel")
    TTitle.Text = title
    TTitle.Font = Enum.Font.FredokaOne
    TTitle.TextSize = 13
    TTitle.TextColor3 = self.Theme.Text
    TTitle.Position = UDim2.new(0, 8, 0, 4)
    TTitle.Size = UDim2.new(1, -16, 0, 16)
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.BackgroundTransparency = 1
    TTitle.Parent = Toast

    local TText = Instance.new("TextLabel")
    TText.Text = text
    TText.Font = Enum.Font.SourceSans
    TText.TextSize = 11
    TText.TextColor3 = self.Theme.Text
    TText.Position = UDim2.new(0, 8, 0, 20)
    TText.Size = UDim2.new(1, -16, 0, 24)
    TText.TextWrapped = true
    TText.TextXAlignment = Enum.TextXAlignment.Left
    TText.BackgroundTransparency = 1
    TText.Parent = Toast

    ElasticTween(Toast, {Position = UDim2.new(1, -215, 1, -65)}, 0.3)

    task.delay(duration, function()
        LinearTween(Toast, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        Toast:Destroy()
    end)
end

return CollieLib
