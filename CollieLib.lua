--[[
    ================================================================
    CollieLib - Modular & Aesthetic UI Library
    Style: Pastel Light Blue / Cute & Minimalist
    ================================================================
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")

local CollieLib = {}
CollieLib.__index = CollieLib

-- Paleta de Cores (Pastel / Aesthetic)
local Theme = {
    Background = Color3.fromRGB(215, 230, 245),       -- Azul-pastel médio/escuro
    CardBackground = Color3.fromRGB(242, 247, 255),   -- Azul-claro suave
    CardForeground = Color3.fromRGB(255, 255, 255),   -- Branco puríssimo
    Accent = Color3.fromRGB(150, 205, 255),           -- Azul-bebê brilhante
    TextPrimary = Color3.fromRGB(60, 80, 105),        -- Azul escuro suave
    TextSecondary = Color3.fromRGB(120, 145, 175),    -- Cinza-azul pastel
    Stroke = Color3.fromRGB(195, 215, 235),           -- Borda suave
    
    -- Tags
    Tags = {
        NEW = Color3.fromRGB(120, 190, 255),          -- Azul-brilhante
        BETA = Color3.fromRGB(185, 155, 240),         -- Roxo-pastel
        RELEASE = Color3.fromRGB(145, 220, 165),      -- Verde-pastel
        REMOVED = Color3.fromRGB(255, 140, 140),      -- Vermelho-pastel
        UPDATING = Color3.fromRGB(255, 210, 120)      -- Amarelo-pastel
    }
}

-- Configurações de Animação
local TweenInfoFast = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TweenInfoBounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

----------------------------------------------------------------
-- FUNÇÕES AUXILIARES & UTILITÁRIOS
----------------------------------------------------------------

local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, val in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = val
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function ApplyCorner(instance, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 12),
        Parent = instance
    })
end

local function ApplyStroke(instance, color, thickness)
    return Create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = instance
    })
end

local function GetScreenGui()
    local gui = CoreGui:FindFirstChild("CollieLibGui")
    if not gui then
        gui = Create("ScreenGui", {
            Name = "CollieLibGui",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = CoreGui
        })
    end
    return gui
end

----------------------------------------------------------------
-- 0. MÓDULO DE NOTIFICAÇÕES FLUTUANTES
----------------------------------------------------------------

function CollieLib:ShowLoginNotification(username, plan_type)
    local screen = GetScreenGui()
    
    local notifContainer = screen:FindFirstChild("NotifContainer")
    if not notifContainer then
        notifContainer = Create("Frame", {
            Name = "NotifContainer",
            Size = UDim2.new(0, 280, 1, 0),
            Position = UDim2.new(1, -290, 0, 20),
            BackgroundTransparency = 1,
            Parent = screen
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Top,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Parent = notifContainer
        })
    end

    local notifCard = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundColor3 = Theme.CardForeground,
        Position = UDim2.new(1, 300, 0, 0),
        Parent = notifContainer
    })
    ApplyCorner(notifCard, 14)
    ApplyStroke(notifCard, Theme.Stroke, 1.5)

    local title = Create("TextLabel", {
        Text = "Bem-vindo de volta, " .. username .. "!",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.TextPrimary,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 12, 0, 10),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifCard
    })

    local planTag = Create("TextLabel", {
        Text = "Plano Atual: " .. tostring(plan_type):upper(),
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Theme.Accent,
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 12, 0, 32),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifCard
    })

    -- Animação de Entrada e Saída
    notifCard.BackgroundTransparency = 1
    title.TextTransparency = 1
    planTag.TextTransparency = 1

    TweenService:Create(notifCard, TweenInfoFast, {BackgroundTransparency = 0}):Play()
    TweenService:Create(title, TweenInfoFast, {TextTransparency = 0}):Play()
    TweenService:Create(planTag, TweenInfoFast, {TextTransparency = 0}):Play()

    task.delay(4, function()
        local hide = TweenService:Create(notifCard, TweenInfoFast, {BackgroundTransparency = 1})
        TweenService:Create(title, TweenInfoFast, {TextTransparency = 1}):Play()
        TweenService:Create(planTag, TweenInfoFast, {TextTransparency = 1}):Play()
        hide:Play()
        hide.Completed:Connect(function()
            notifCard:Destroy()
        end)
    end)
end

----------------------------------------------------------------
-- 0. MÓDULO INICIALIZADOR DE VERSÕES (LOADER HUB)
----------------------------------------------------------------

function CollieLib:CreateLoader(hub_name)
    local screen = GetScreenGui()

    local loaderFrame = Create("Frame", {
        Name = "CollieLoader",
        Size = UDim2.new(0, 420, 0, 480),
        Position = UDim2.new(0.5, -210, 0.5, -240),
        BackgroundColor3 = Theme.Background,
        Parent = screen
    })
    ApplyCorner(loaderFrame, 20)
    ApplyStroke(loaderFrame, Theme.Accent, 2)

    -- Sombra Suave
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Theme.TextPrimary,
        ImageTransparency = 0.85,
        ZIndex = 0,
        Parent = loaderFrame
    })

    -- Cabeçalho
    local header = Create("TextLabel", {
        Text = hub_name or "Collie Loader Hub",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Theme.TextPrimary,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = loaderFrame
    })

    -- Container Scroll
    local scroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, -40, 1, -80),
        Position = UDim2.new(0, 20, 0, 65),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        Parent = loaderFrame
    })
    
    local list = Create("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scroll
    })

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)

    local loaderObj = {}

    function loaderObj:AddVersionCard(version_name, status, description, is_premium, discord_shop_link, callback)
        local card = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 100),
            BackgroundColor3 = Theme.CardForeground,
            Parent = scroll
        })
        ApplyCorner(card, 14)
        local cardStroke = ApplyStroke(card, Theme.Stroke, 1.5)

        local vTitle = Create("TextLabel", {
            Text = version_name,
            Font = Enum.Font.GothamBold,
            TextSize = 15,
            TextColor3 = Theme.TextPrimary,
            Size = UDim2.new(0.7, 0, 0, 22),
            Position = UDim2.new(0, 15, 0, 12),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = card
        })

        local vDesc = Create("TextLabel", {
            Text = description or "",
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Theme.TextSecondary,
            Size = UDim2.new(1, -30, 0, 30),
            Position = UDim2.new(0, 15, 0, 34),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = card
        })

        -- Ações
        if is_premium then
            -- Ícone de Cadeado Animado
            local lockIcon = Create("ImageLabel", {
                Image = "rbxassetid://6031082533", -- Cadeado
                ImageColor3 = Theme.Accent,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -35, 0, 12),
                BackgroundTransparency = 1,
                Parent = card
            })

            -- Animação de Pulso (Hover)
            card.MouseEnter:Connect(function()
                TweenService:Create(cardStroke, TweenInfoFast, {Color = Theme.Accent}):Play()
                TweenService:Create(lockIcon, TweenInfoBounce, {Size = UDim2.new(0, 24, 0, 24)}):Play()
            end)
            card.MouseLeave:Connect(function()
                TweenService:Create(cardStroke, TweenInfoFast, {Color = Theme.Stroke}):Play()
                TweenService:Create(lockIcon, TweenInfoFast, {Size = UDim2.new(0, 20, 0, 20)}):Play()
            end)

            -- Botão Discord
            local discordBtn = Create("TextButton", {
                Text = "Acessar Loja Discord",
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundColor3 = Color3.fromRGB(114, 137, 218),
                Size = UDim2.new(1, -30, 0, 24),
                Position = UDim2.new(0, 15, 1, -32),
                AutoButtonColor = false,
                Parent = card
            })
            ApplyCorner(discordBtn, 8)

            discordBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(discord_shop_link)
                    discordBtn.Text = "Link Copiado!"
                    task.wait(1.5)
                    discordBtn.Text = "Acessar Loja Discord"
                end
            end)
        else
            -- Botão Normal de Inicialização
            local launchBtn = Create("TextButton", {
                Text = "Carregar Versão",
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = Theme.TextPrimary,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new(1, -30, 0, 24),
                Position = UDim2.new(0, 15, 1, -32),
                AutoButtonColor = false,
                Parent = card
            })
            ApplyCorner(launchBtn, 8)

            launchBtn.MouseButton1Click:Connect(function()
                loaderFrame:Destroy()
                if callback then callback() end
            end)
        end
    end

    return loaderObj
end

----------------------------------------------------------------
-- 1 & 3. ESTRUTURA DA JANELA PRINCIPAL E COMPONENTES DE UI
----------------------------------------------------------------

function CollieLib:CreateWindow(title, subtitle)
    local screen = GetScreenGui()

    local mainFrame = Create("Frame", {
        Name = "CollieMainWindow",
        Size = UDim2.new(0, 620, 0, 400),
        Position = UDim2.new(0.5, -310, 0.5, -200),
        BackgroundColor3 = Theme.Background,
        Parent = screen
    })
    ApplyCorner(mainFrame, 18)
    ApplyStroke(mainFrame, Theme.Stroke, 2)

    -- Cabeçalho Principal
    local headerBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local windowTitle = Create("TextLabel", {
        Text = title or "CollieLib UI",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.TextPrimary,
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 20, 0, 12),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = headerBar
    })

    local windowSub = Create("TextLabel", {
        Text = subtitle or "Pastel Aesthetic Edition",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Theme.TextSecondary,
        Size = UDim2.new(0, 200, 0, 15),
        Position = UDim2.new(0, 20, 0, 28),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = headerBar
    })

    -- Barra de Pesquisa
    local searchBoxFrame = Create("Frame", {
        Size = UDim2.new(0, 180, 0, 28),
        Position = UDim2.new(1, -210, 0, 11),
        BackgroundColor3 = Theme.CardForeground,
        Visible = false,
        Parent = headerBar
    })
    ApplyCorner(searchBoxFrame, 8)
    ApplyStroke(searchBoxFrame, Theme.Stroke, 1)

    local searchInput = Create("TextBox", {
        Text = "",
        PlaceholderText = "Pesquisar...",
        PlaceholderColor3 = Theme.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = Theme.TextPrimary,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = searchBoxFrame
    })

    -- Botão Fechar
    local closeBtn = Create("TextButton", {
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Theme.TextSecondary,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -38, 0, 11),
        BackgroundTransparency = 1,
        Parent = headerBar
    })
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame:Destroy()
    end)

    -- Container Lateral (Abas) e Conteúdo
    local tabContainer = Create("Frame", {
        Size = UDim2.new(0, 140, 1, -60),
        Position = UDim2.new(0, 15, 0, 50),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local tabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = tabContainer
    })

    local contentContainer = Create("Frame", {
        Size = UDim2.new(1, -180, 1, -65),
        Position = UDim2.new(0, 165, 0, 55),
        BackgroundColor3 = Theme.CardBackground,
        Parent = mainFrame
    })
    ApplyCorner(contentContainer, 14)

    local windowObj = {
        Tabs = {},
        ActiveTab = nil,
        FavoritesList = {}
    }

    function windowObj:EnableSearchBar()
        searchBoxFrame.Visible = true
    end

    ------------------------------------------------------------
    -- CRIADOR DE ABAS
    ------------------------------------------------------------
    function windowObj:CreateTab(tab_name, icon_id)
        local tabBtn = Create("TextButton", {
            Text = "   " .. tab_name,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextColor3 = Theme.TextSecondary,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.CardForeground,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = tabContainer
        })
        ApplyCorner(tabBtn, 10)

        local tabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            Parent = contentContainer
        })
        
        local contentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)

        local tabObj = { Page = tabContent }

        local function Select()
            for _, t in pairs(windowObj.Tabs) do
                t.Button.BackgroundTransparency = 1
                t.Button.TextColor3 = Theme.TextSecondary
                t.Page.Visible = false
            end
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Theme.TextPrimary
            tabContent.Visible = true
            windowObj.ActiveTab = tabObj
        end

        tabBtn.MouseButton1Click:Connect(Select)
        tabObj.Button = tabBtn

        table.insert(windowObj.Tabs, tabObj)
        if #windowObj.Tabs == 1 then Select() end

        --------------------------------------------------------
        -- SISTEMA DE TAGS E ELEMENTOS
        --------------------------------------------------------
        local function ApplyTag(parentInstance, tagType)
            if tagType and Theme.Tags[tagType] then
                local tagFrame = Create("Frame", {
                    Size = UDim2.new(0, 50, 0, 16),
                    Position = UDim2.new(1, -60, 0.5, -8),
                    BackgroundColor3 = Theme.Tags[tagType],
                    Parent = parentInstance
                })
                ApplyCorner(tagFrame, 6)

                Create("TextLabel", {
                    Text = tagType,
                    Font = Enum.Font.GothamBold,
                    TextSize = 8,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = tagFrame
                })
            end
        end

        function tabObj:CreateSection(section_title)
            local secFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Parent = tabContent
            })
            
            Create("TextLabel", {
                Text = section_title:upper(),
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextColor3 = Theme.TextSecondary,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = secFrame
            })
        end

        function tabObj:CreateButton(text, callback, tag)
            local btn = Create("TextButton", {
                Text = "  " .. text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = Theme.TextPrimary,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.CardForeground,
                AutoButtonColor = false,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = tabContent
            })
            ApplyCorner(btn, 8)
            ApplyStroke(btn, Theme.Stroke, 1)
            ApplyTag(btn, tag)

            btn.MouseButton1Click:Connect(function()
                -- Efeito de Clique Expansivo
                local circle = Create("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = 0.5,
                    Parent = btn
                })
                ApplyCorner(circle, 100)
                
                TweenService:Create(circle, TweenInfoFast, {
                    Size = UDim2.new(1, 10, 2, 0),
                    Position = UDim2.new(-0.05, 0, -0.5, 0),
                    BackgroundTransparency = 1
                }):Play()

                task.delay(0.25, function() circle:Destroy() end)
                if callback then callback() end
            end)
        end

        function tabObj:CreateToggle(text, default, callback, tag)
            local toggleFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.CardForeground,
                Parent = tabContent
            })
            ApplyCorner(toggleFrame, 8)
            ApplyStroke(toggleFrame, Theme.Stroke, 1)
            ApplyTag(toggleFrame, tag)

            Create("TextLabel", {
                Text = "  " .. text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = Theme.TextPrimary,
                Size = UDim2.new(0.6, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleFrame
            })

            local switchBg = Create("Frame", {
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -48, 0.5, -9),
                BackgroundColor3 = default and Theme.Accent or Theme.Stroke,
                Parent = toggleFrame
            })
            ApplyCorner(switchBg, 10)

            local circle = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = Theme.CardForeground,
                Parent = switchBg
            })
            ApplyCorner(circle, 10)

            local state = default or false
            local clickBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = toggleFrame
            })

            clickBtn.MouseButton1Click:Connect(function()
                state = not state
                local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local targetColor = state and Theme.Accent or Theme.Stroke

                TweenService:Create(circle, TweenInfoFast, {Position = targetPos}):Play()
                TweenService:Create(switchBg, TweenInfoFast, {BackgroundColor3 = targetColor}):Play()

                if callback then callback(state) end
            end)
        end

        function tabObj:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = Theme.CardForeground,
                Parent = tabContent
            })
            ApplyCorner(sliderFrame, 8)
            ApplyStroke(sliderFrame, Theme.Stroke, 1)

            local title = Create("TextLabel", {
                Text = "  " .. text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = Theme.TextPrimary,
                Size = UDim2.new(0.7, 0, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })

            local valLabel = Create("TextLabel", {
                Text = tostring(default or min),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = Theme.Accent,
                Size = UDim2.new(0.2, 0, 0, 20),
                Position = UDim2.new(0.8, -10, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = sliderFrame
            })

            local barBg = Create("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 1, -12),
                BackgroundColor3 = Theme.Stroke,
                Parent = sliderFrame
            })
            ApplyCorner(barBg, 4)

            local fill = Create("Frame", {
                Size = UDim2.new((default - min)/(max - min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                Parent = barBg
            })
            ApplyCorner(fill, 4)

            -- Lógica de Arrastar
            local dragging = false
            local function Update(input)
                local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + ((max - min) * pos))
                fill.Size = UDim2.new(pos, 0, 1, 0)
                valLabel.Text = tostring(value)
                if callback then callback(value) end
            end

            barBg.InputBegan:Connect(function(input)
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

        --------------------------------------------------------
        -- 1. CARTÃO VISUAL DE JOGO (MARKETPLACE ASSET INTEGRATION)
        --------------------------------------------------------
        function tabObj:CreateGameCard(game_name, roblox_place_id, callback)
            local card = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 120),
                BackgroundColor3 = Theme.CardForeground,
                ClipsDescendants = true,
                Parent = tabContent
            })
            ApplyCorner(card, 12)
            ApplyStroke(card, Theme.Stroke, 1.5)

            -- Imagem Oficial
            local gameThumb = Create("ImageLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                ScaleType = Enum.ScaleType.Crop,
                Parent = card
            })

            -- Puxa miniatura via ID do jogo
            task.spawn(function()
                pcall(function()
                    gameThumb.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. roblox_place_id .. "&width=768&height=432&format=png"
                end)
            end)

            -- Gradiente
            local overlay = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.4,
                Parent = card
            })

            local nameLabel = Create("TextLabel", {
                Text = game_name,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 12, 1, -40),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = card
            })

            local clickBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = card
            })

            clickBtn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        return tabObj
    end

    -- Criação Nativa da Aba de Favoritos
    local favTab = windowObj:CreateTab("Favoritos", "")
    favTab:CreateSection("Seus Itens Salvos")

    return windowObj
end

return CollieLib
