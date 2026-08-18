--[[
    CollieLib - Cute, Cartoon & Clean UI Library (Versão Corrigida)
    Estética: Pastel Blue / Aesthetic UI
    Animações: TweenService com respostas elásticas e suaves
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local CollieLib = {}
CollieLib.__index = CollieLib

-- Paleta de Cores Pastel / Aesthetic
local Theme = {
    MainBg = Color3.fromRGB(180, 210, 235),       -- Azul pastel médio
    CardBg = Color3.fromRGB(240, 248, 255),       -- Azul/Branco muito claro
    Active = Color3.fromRGB(130, 200, 255),       -- Azul-bebê brilhante
    Text = Color3.fromRGB(70, 90, 120),           -- Azul escuro suave
    SubText = Color3.fromRGB(120, 145, 175),      -- Texto secundário
    Stroke = Color3.fromRGB(210, 230, 250),       -- Borda cartoon
    
    -- Tags
    Tag_NEW = Color3.fromRGB(125, 210, 255),
    Tag_BETA = Color3.fromRGB(185, 160, 240),
    Tag_RELEASE = Color3.fromRGB(150, 230, 180),
    Tag_UPDATING = Color3.fromRGB(255, 215, 130)
}

-- Helpers Internos
local function CreateTween(object, info, properties)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

local function ApplyCartoonStyle(instance, cornerRadius, strokeColor)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = cornerRadius or UDim.new(0, 12)
    corner.Parent = instance

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = strokeColor or Theme.Stroke
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance

    return corner, stroke
end

local function AddMicroInteractions(button)
    local uiScale = button:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
    uiScale.Parent = button

    local scaleInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local clickInfo = TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

    button.MouseEnter:Connect(function()
        CreateTween(uiScale, scaleInfo, {Scale = 1.03})
    end)

    button.MouseLeave:Connect(function()
        CreateTween(uiScale, scaleInfo, {Scale = 1.0})
    end)

    button.MouseButton1Down:Connect(function()
        CreateTween(uiScale, clickInfo, {Scale = 0.95})
    end)

    button.MouseButton1Up:Connect(function()
        CreateTween(uiScale, clickInfo, {Scale = 1.03})
    end)
end

-- ==========================================
-- CONSTRUTOR PRINCIPAL DA JANELA
-- ==========================================
function CollieLib:CreateWindow(title, subtitle)
    local self = setmetatable({}, CollieLib)
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CollieLib_UI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui

    -- Frame Principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 520, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    mainFrame.BackgroundColor3 = Theme.MainBg
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = true
    mainFrame.Parent = screenGui

    ApplyCartoonStyle(mainFrame, UDim.new(0, 20), Theme.Stroke)

    -- Animação de Entrada
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    CreateTween(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 520, 0, 380),
        Position = UDim2.new(0.5, -260, 0.5, -190)
    })

    -- Cabeçalho
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    header.Visible = true
    header.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 0, 25)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.Text = title or "CollieLib"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Visible = true
    titleLabel.Parent = header

    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Size = UDim2.new(0, 200, 0, 15)
    subTitleLabel.Position = UDim2.new(0, 20, 0, 32)
    subTitleLabel.Text = subtitle or "Cartoon & Clean UI"
    subTitleLabel.TextColor3 = Theme.SubText
    subTitleLabel.TextSize = 12
    subTitleLabel.Font = Enum.Font.GothamBold
    subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Visible = true
    subTitleLabel.Parent = header

    -- Container do Menu Lateral (Abas)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 130, 1, -65)
    tabContainer.Position = UDim2.new(0, 15, 0, 55)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = Theme.Active
    tabContainer.Visible = true
    tabContainer.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = tabContainer

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 4)
    tabPadding.PaddingLeft = UDim.new(0, 4)
    tabPadding.PaddingRight = UDim.new(0, 4)
    tabPadding.Parent = tabContainer

    -- Container do Conteúdo Principal
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -170, 1, -65)
    contentContainer.Position = UDim2.new(0, 155, 0, 55)
    contentContainer.BackgroundColor3 = Theme.CardBg
    contentContainer.ClipsDescendants = true
    contentContainer.Visible = true
    contentContainer.Parent = mainFrame

    ApplyCartoonStyle(contentContainer, UDim.new(0, 16), Theme.Stroke)

    self.ScreenGui = screenGui
    self.MainFrame = mainFrame
    self.TabContainer = tabContainer
    self.ContentContainer = contentContainer
    self.Tabs = {}
    self.ActiveTab = nil

    return self
end

-- ==========================================
-- CRIAÇÃO DE ABAS
-- ==========================================
function CollieLib:CreateTab(tabName)
    -- Botão da Aba no Menu Lateral
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "_TabButton"
    tabButton.Size = UDim2.new(1, -8, 0, 36)
    tabButton.BackgroundColor3 = Theme.CardBg
    tabButton.Text = tabName
    tabButton.TextColor3 = Theme.Text
    tabButton.Font = Enum.Font.FredokaOne
    tabButton.TextSize = 14
    tabButton.Visible = true
    tabButton.Parent = self.TabContainer

    ApplyCartoonStyle(tabButton, UDim.new(0, 10), Theme.Stroke)
    AddMicroInteractions(tabButton)

    -- Página da Aba (ScrollingFrame)
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = tabName .. "_Page"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Theme.Active
    tabContent.Visible = false
    tabContent.Parent = self.ContentContainer

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tabContent

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.Parent = tabContent

    -- Auto-redimensionamento do Canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)

    local tabObj = {
        Button = tabButton,
        Content = tabContent
    }

    -- Clique na Aba
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in ipairs(self.Tabs) do
            tab.Content.Visible = false
            CreateTween(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBg})
        end
        tabContent.Visible = true
        self.ActiveTab = tabObj
        CreateTween(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Active})
    end)

    -- Ativa a primeira aba criada por padrão
    if #self.Tabs == 0 then
        tabContent.Visible = true
        tabButton.BackgroundColor3 = Theme.Active
        self.ActiveTab = tabObj
    end

    table.insert(self.Tabs, tabObj)
    return tabObj
end

-- Helper de Card Base para Elementos
local function CreateElementCard(parentContainer, height)
    local card = Instance.new("Frame")
    card.Name = "ElementCard"
    card.Size = UDim2.new(1, -10, 0, height or 42)
    card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    card.Visible = true
    card.Parent = parentContainer

    ApplyCartoonStyle(card, UDim.new(0, 10), Theme.Stroke)
    return card
end

-- Helper para Resolver a Aba Ativa
local function ResolveTab(self, targetTab)
    if typeof(targetTab) == "table" and targetTab.Content then
        return targetTab.Content
    elseif targetTab and targetTab:IsA("GuiObject") then
        return targetTab
    elseif self.ActiveTab then
        return self.ActiveTab.Content
    elseif #self.Tabs > 0 then
        return self.Tabs[1].Content
    end
    return nil
end

-- ==========================================
-- ELEMENTOS DE INTERFACE
-- ==========================================

-- Toggle (Switch On/Off)
function CollieLib:CreateToggle(targetTab, text, default, callback)
    local parentContent = ResolveTab(self, targetTab)
    if not parentContent then return end

    local card = CreateElementCard(parentContent, 42)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = text or "Toggle"
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Visible = true
    label.Parent = card

    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 46, 0, 24)
    switchBg.Position = UDim2.new(1, -58, 0.5, -12)
    switchBg.BackgroundColor3 = default and Theme.Active or Theme.MainBg
    switchBg.Visible = true
    switchBg.Parent = card

    ApplyCartoonStyle(switchBg, UDim.new(1, 0), Theme.Stroke)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Visible = true
    circle.Parent = switchBg

    ApplyCartoonStyle(circle, UDim.new(1, 0), Color3.fromRGB(255, 255, 255))

    local state = default or false
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Visible = true
    clickBtn.Parent = card

    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetColor = state and Theme.Active or Theme.MainBg

        CreateTween(circle, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos})
        CreateTween(switchBg, TweenInfo.new(0.25), {BackgroundColor3 = targetColor})

        if callback then callback(state) end
    end)
end

-- Botão
function CollieLib:CreateButton(targetTab, text, callback)
    local parentContent = ResolveTab(self, targetTab)
    if not parentContent then return end

    local card = CreateElementCard(parentContent, 40)
    card.BackgroundColor3 = Theme.Active

    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(1, 0, 1, 0)
    btnText.Text = text or "Botão"
    btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnText.Font = Enum.Font.FredokaOne
    btnText.TextSize = 14
    btnText.BackgroundTransparency = 1
    btnText.Visible = true
    btnText.Parent = card

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Visible = true
    clickBtn.Parent = card

    AddMicroInteractions(card)

    clickBtn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- Slider (Barra de Ajuste)
function CollieLib:CreateSlider(targetTab, text, min, max, default, callback)
    local parentContent = ResolveTab(self, targetTab)
    if not parentContent then return end

    local card = CreateElementCard(parentContent, 52)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.Text = text or "Slider"
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Visible = true
    label.Parent = card

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.4, 0, 0, 20)
    valLabel.Position = UDim2.new(0.6, -12, 0, 6)
    valLabel.Text = tostring(default or min)
    valLabel.TextColor3 = Theme.SubText
    valLabel.Font = Enum.Font.FredokaOne
    valLabel.TextSize = 13
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.BackgroundTransparency = 1
    valLabel.Visible = true
    valLabel.Parent = card

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -24, 0, 10)
    sliderTrack.Position = UDim2.new(0, 12, 0, 32)
    sliderTrack.BackgroundColor3 = Theme.MainBg
    sliderTrack.Visible = true
    sliderTrack.Parent = card

    ApplyCartoonStyle(sliderTrack, UDim.new(1, 0), Theme.Stroke)

    local startFactor = math.clamp(((default or min) - min) / (max - min), 0, 1)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(startFactor, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Active
    fill.Visible = true
    fill.Parent = sliderTrack

    ApplyCartoonStyle(fill, UDim.new(1, 0), Theme.Active)

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)

        CreateTween(fill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)})
        valLabel.Text = tostring(value)

        if callback then callback(value) end
    end

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input)
        end
    end)
end

return CollieLib
