-- [version:pd]
-- [translation:project delta]
-- [scriptid:pd]
cheat.Library, cheat.Toggles, cheat.Options = loadswimhubfile("library_main.lua")()
cheat.ThemeManager = loadswimhubfile("library_theme.lua")()
cheat.SaveManager = loadswimhubfile("library_save.lua")()
local ui = {
    window = cheat.Library:CreateWindow({
        Title=string.format(
            SWG_Title,
            SWG_Version,
            SWG_FullName
        ),
    Center=true,AutoShow=true,TabPadding=8})
}

local globals = {
    fov_enabled = false,
    zoom_enabled = false,
}

--[[if not LocalPlayer.Name:lower():find("zov") then
    return LocalPlayer:Kick("UKRAINEC DETECTED!!! BANNING AND BLACKLISTING!!!")
end]]

local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _Raycast = workspace.Raycast
local _IsKeyDown = UserInputService.IsKeyDown
local _WorldToViewportPoint = Camera.WorldToViewportPoint
local _Vector3zeromin = Vector3.zero.Min
local _Vector2zeromin = Vector2.zero.Min
local _Vector3zeromax = Vector3.zero.Max
local _Vector2zeromax = Vector2.zero.Max
local _IsA = game.IsA
local tablecreate = table.create
local mathfloor = math.floor
local mathround = math.round
local tostring = tostring
local unpack = unpack
local getupvalues = debug.getupvalues
local getupvalue = debug.getupvalue
local setupvalue = debug.setupvalue
local getconstants = debug.getconstants
local getconstant = debug.getconstant
local setconstant = debug.setconstant
local getstack = debug.getstack
local setstack = debug.setstack
local getinfo = debug.getinfo
local rawget = rawget

ui.tabs = {
    combat = ui.window:AddTab('combat'),
    visuals = ui.window:AddTab('visuals'),
    misc = ui.window:AddTab('misc'),
    config = ui.window:AddTab('config'),
}
ui.box = {
    aimbot = ui.tabs.combat:AddLeftTabbox(),
    mods = ui.tabs.combat:AddRightTabbox(),
    esp = ui.tabs.visuals:AddLeftTabbox(),
    world = ui.tabs.visuals:AddRightTabbox(),
    crosshair = ui.tabs.visuals:AddRightTabbox(),
    move = ui.tabs.misc:AddLeftTabbox(),
    misc = ui.tabs.misc:AddRightTabbox(),
    themeconfig = ui.tabs.config:AddLeftGroupbox('theme config'),
}

cheat.EspLibrary = {} LPH_NO_VIRTUALIZE(function()

    local esp_table = {}
    local workspace = cloneref(game:GetService("Workspace"))
    local rservice = cloneref(game:GetService("RunService"))
    local plrs = cloneref(game:GetService("Players"))
    local lplr = plrs.LocalPlayer
    local container = Instance.new("Folder", game:GetService("CoreGui").RobloxGui)
    esp_table = {
        __loaded = false,
        main_settings = {
            textSize = 15,
            textFont = Drawing.Fonts.Monospace,
            distancelimit = false,
            maxdistance = 200,
            fadetime = 1,
            infiniterange = false
        },
        main_object_settings = {
            textSize = 15,
            textFont = Drawing.Fonts.Monospace,
            distancelimit = false,
            maxdistance = 200,
            useteamcolor = false,
            teamcheck = false,
            sleepcheck = false,
            allowed = {}
        },
        settings = {
            enemy = {
                enabled = false,
    
                box = false,
                box_fill = false,
                realname = false,
                displayname = false,
                health = false,
                dist = false,
                weapon = false,
                skeleton = false,
    
                box_outline = false,
                realname_outline = false,
                displayname_outline = false,
                health_outline = false,
                dist_outline = false,
                weapon_outline = false,
    
                box_color = { Color3.new(1, 1, 1), 1 },
                box_fill_color = { Color3.new(1, 0, 0), 0.5 },
                realname_color = { Color3.new(1, 1, 1), 1 },
                displayname_color = { Color3.new(1, 1, 1), 1 },
                health_color = { Color3.new(1, 1, 1), 1 },
                dist_color = { Color3.new(1, 1, 1), 1 },
                weapon_color = { Color3.new(1, 1, 1), 1 },
                skeleton_color = { Color3.new(1, 1, 1), 1 },
    
                box_outline_color = { Color3.new(), 1 },
                realname_outline_color = Color3.new(),
                displayname_outline_color = Color3.new(),
                health_outline_color = Color3.new(),
                dist_outline_color = Color3.new(),
                weapon_outline_color = Color3.new(),
    
                chams = false,
                chams_visible_only = false,
                chams_fill_color = { Color3.new(1, 1, 1), 0.5 },
                chamsoutline_color = { Color3.new(1, 1, 1), 0 }
            },
            object = {
                enabled = false,

                realname = false,
                realname_outline = false,

                realname_color = { Color3.new(1, 1, 1), 1 },
                realname_outline_color = Color3.new()
            }
        }
    }
    local loaded_plrs = {}
    -- (please update me) vars
    local camera = workspace.CurrentCamera
    local viewportsize = camera.ViewportSize
    
    -- constants
    local VERTICES = {
        _Vector3new(-1, -1, -1),
        _Vector3new(-1, 1, -1),
        _Vector3new(-1, 1, 1),
        _Vector3new(-1, -1, 1),
        _Vector3new(1, -1, -1),
        _Vector3new(1, 1, -1),
        _Vector3new(1, 1, 1),
        _Vector3new(1, -1, 1)
    }
    local skeleton_order = {
        ["LeftFoot"] = "LeftLowerLeg",
        ["LeftLowerLeg"] = "LeftUpperLeg",
        ["LeftUpperLeg"] = "LowerTorso",
    
        ["RightFoot"] = "RightLowerLeg",
        ["RightLowerLeg"] = "RightUpperLeg",
        ["RightUpperLeg"] = "LowerTorso",
    
        ["LeftHand"] = "LeftLowerArm",
        ["LeftLowerArm"] = "LeftUpperArm",
        ["LeftUpperArm"] = "UpperTorso",
    
        ["RightHand"] = "RightLowerArm",
        ["RightLowerArm"] = "RightUpperArm",
        ["RightUpperArm"] = "UpperTorso",
    
        ["LowerTorso"] = "UpperTorso",
        ["UpperTorso"] = "Head"
    }
    -- functions
    local esp = {}
    esp.create_obj = function(type, args)
        local obj = Drawing.new(type)
        for i, v in args do
            obj[i] = v
        end
        return obj
    end
    
    
    
    local function isBodyPart(name)
        return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm")
    end
    local function getBoundingBox(parts)
        local min, max
        for i = 1, #parts do
            local part = parts[i]
            local cframe, size = part.CFrame, part.Size
    
            min = _Vector3zeromin(min or cframe.Position, (cframe - size * 0.5).Position)
            max = _Vector3zeromax(max or cframe.Position, (cframe + size * 0.5).Position)
        end

        local center = (min + max) * 0.5
        local front = _Vector3new(center.X, center.Y, max.Z)
        return _CFramenew(center, front), max - min
    end
    
    local function worldToScreen(world)
        local screen, inBounds = _WorldToViewportPoint(camera, world)
        return _Vector2new(screen.X, screen.Y), inBounds, screen.Z
    end
    
    local function calculateCorners(cframe, size)
        local corners = table.create(#VERTICES)
        for i = 1, #VERTICES do
            corners[i] = worldToScreen((cframe + size * 0.5 * VERTICES[i]).Position)
        end
    
        local min = _Vector2zeromin(camera.ViewportSize, unpack(corners))
        local max = _Vector2zeromax(Vector2.zero, unpack(corners))
        return {
            corners = corners,
            topLeft = _Vector2new(mathfloor(min.X), mathfloor(min.Y)),
            topRight = _Vector2new(mathfloor(max.X), mathfloor(min.Y)),
            bottomLeft = _Vector2new(mathfloor(min.X), mathfloor(max.Y)),
            bottomRight = _Vector2new(mathfloor(max.X), mathfloor(max.Y))
        }
    end

    local get_mainpart = function(model, modelname)
        if modelname == "corpse" then
            return _FindFirstChild(model, "UpperTorso")
        end
    end

    local identify_model = function(model, modelname)
        if not model then return false, false end
        if modelname == "corpse" and _FindFirstChildOfClass(model, "Humanoid") then
            --print('identified model', model, modelname)
            return model.Name.."'s corpse"
        end
        return false, false
    end

    
    -- MAINN
    
    local function create_esp(player, isnpc)
        if not player then return end
        if player.ClassName == "Model" then isnpc = true end
        --if not (isnpc and _FindFirstChildOfClass(player, "Humanoid") or not isnpc) then return end
        --repeat task.wait(0) until (isnpc and _FindFirstChildOfClass(player, "Humanoid") or not isnpc)
        loaded_plrs[player] = {
            obj = {
                box_fill = esp.create_obj("Square", { Filled = true, Visible = false }),
                box_outline = esp.create_obj("Square", { Filled = false, Thickness = 3, Visible = false, ZIndex = -1 }),
                box = esp.create_obj("Square", { Filled = false, Thickness = 1, Visible = false }),
                realname = esp.create_obj("Text", { Center = true, Visible = false, Text = player.Name }),
                displayname = esp.create_obj("Text", { Center = true, Visible = false, Text = isnpc and "" or player.Name == player.DisplayName and "" or player.DisplayName }),
                healthtext = esp.create_obj("Text", { Center = false, Visible = false }),
                dist = esp.create_obj("Text", { Center = true, Visible = false }),
                weapon = esp.create_obj("Text", { Center = true, Visible = false }),
            },
            chams_object = Instance.new("Highlight", container),
            plr_instance = player
        }
        for required, _ in next, skeleton_order do
            loaded_plrs[player].obj["skeleton_" .. required] = esp.create_obj("Line", { Visible = false })
        end
        --local rp_plr = not isnpc and game:GetService("ReplicatedStorage").Players:FindFirstChild(player.Name)

        local plr = loaded_plrs[player]
        local obj = plr.obj
        local esp = plr.esp

        local box = obj.box
        local box_outline = obj.box_outline
        local box_fill = obj.box_fill
        local healthtext = obj.healthtext
        local realname = obj.realname
        local displayname = obj.displayname
        local dist = obj.dist
        local weapon = obj.weapon
        local cham = plr.chams_object

        local settings = esp_table.settings.enemy
        local main_settings = esp_table.main_settings

        local character = isnpc and player or not isnpc and player.Character
        local head = character and _FindFirstChild(character, "Head")
        local humanoid = character and _FindFirstChildOfClass(character, "Humanoid")

        local setvis_cache = false
        local fadetime = main_settings.fadetime
        local fadethread

        function plr:forceupdate()
            fadetime = main_settings.fadetime

            cham.DepthMode = settings.chams_visible_only and 1 or 0
            cham.FillColor = settings.chams_fill_color[1]
            cham.OutlineColor = settings.chamsoutline_color[1]
            cham.FillTransparency = settings.chams_fill_color[2]
            cham.OutlineTransparency = settings.chamsoutline_color[2]

            box.Color = settings.box_color[1]
            box_outline.Color = settings.box_outline_color[1]
            box_fill.Color = settings.box_fill_color[1]

            realname.Size = main_settings.textSize
            realname.Font = main_settings.textFont
            realname.Color = settings.realname_color[1]
            realname.Outline = settings.realname_outline
            realname.OutlineColor = settings.realname_outline_color

            displayname.Size = main_settings.textSize
            displayname.Font = main_settings.textFont
            displayname.Color = settings.displayname_color[1]
            displayname.Outline = settings.displayname_outline
            displayname.OutlineColor = settings.displayname_outline_color

            healthtext.Size = main_settings.textSize
            healthtext.Font = main_settings.textFont
            healthtext.Color = settings.health_color[1]
            healthtext.Outline = settings.health_outline
            healthtext.OutlineColor = settings.health_outline_color

            dist.Size = main_settings.textSize
            dist.Font = main_settings.textFont
            dist.Color = settings.dist_color[1]
            dist.Outline = settings.dist_outline
            dist.OutlineColor = settings.dist_outline_color

            weapon.Size = main_settings.textSize
            weapon.Font = main_settings.textFont
            weapon.Color = settings.weapon_color[1]
            weapon.Outline = settings.weapon_outline
            weapon.OutlineColor = settings.weapon_outline_color

            for required, _ in next, skeleton_order do
                local skeletonobj = obj["skeleton_" .. required]
                if skeletonobj then
                    skeletonobj.Color = settings.skeleton_color[1]
                end
            end

            box.Transparency = settings.box_color[2]
            box_outline.Transparency = settings.box_outline_color[2]
            box_fill.Transparency = settings.box_fill_color[2]
            realname.Transparency = settings.realname_color[2]
            displayname.Transparency = settings.displayname_color[2]
            healthtext.Transparency = settings.health_color[2]
            dist.Transparency = settings.dist_color[2]
            weapon.Transparency = settings.weapon_color[2]
            for required, _ in next, skeleton_order do
                obj["skeleton_" .. required].Transparency = settings.skeleton_color[2]
            end

            if setvis_cache then
                cham.Enabled = settings.chams
                box.Visible = settings.box
                box_outline.Visible = settings.box_outline
                box_fill.Visible = settings.box_fill
                realname.Visible = settings.realname
                displayname.Visible = settings.displayname
                healthtext.Visible = settings.health
                dist.Visible = settings.dist
                weapon.Visible = settings.weapon
                for required, _ in next, skeleton_order do
                    local skeletonobj = obj["skeleton_" .. required]
                    if (skeletonobj) then
                        skeletonobj.Visible = settings.skeleton
                    end
                end
            end
        end

        function plr:togglevis(bool, fade)
            if setvis_cache ~= bool then
                setvis_cache = bool
                if not bool then
                    --if not fade or fade == 0 then
                        for _, v in obj do v.Visible = false end
                        cham.Enabled = false
                    --[[else
                        if fadethread then fadethread:Disconnect() end
                        fadethread = cheat.utility.new_renderstepped(function(delta)
                            for _, v in obj do
                                v.Transparency = v.Transparency - (delta / fadetime)
                                if v.Transparency <= 0 then
                                    v.Visible = false
                                end
                            end
                            cham.FillTransparency = cham.FillTransparency - (delta / fadetime)
                            cham.OutlineTransparency = cham.OutlineTransparency - (delta / fadetime)
                            if cham.FillTransparency <= 0 or cham.OutlineTransparency <= 0 then
                                cham.Enabled = false
                            end
                        end)
                    end]]
                else
                    cham.Enabled = settings.chams
                    box.Visible = settings.box
                    box_outline.Visible = settings.box_outline
                    box_fill.Visible = settings.box_fill
                    realname.Visible = settings.realname
                    displayname.Visible = settings.displayname
                    healthtext.Visible = settings.health
                    dist.Visible = settings.dist
                    weapon.Visible = settings.weapon
                    for required, _ in next, skeleton_order do
                        local skeletonobj = obj["skeleton_" .. required]
                        if (skeletonobj) then
                            skeletonobj.Visible = settings.skeleton
                        end
                    end
                end
            end
        end

        plr.connection = cheat.utility.new_renderstepped(function(delta)
            local plr = loaded_plrs[player]
            if not settings.enabled then
                return plr:togglevis(false)
            end

            character = isnpc and player or not isnpc and player.Character
            humanoid = character and _FindFirstChildOfClass(character, "Humanoid")
            head = character and _FindFirstChild(character, "Head")

            if not (character and head and humanoid and character.Parent and head.Parent and humanoid.Parent) then
                if main_settings.infiniterange and not isnpc then
                    local res = (function()
                        local rp_plr = _FindFirstChild(game:GetService("ReplicatedStorage").Players, player.Name)
                        local plrstatus = rp_plr and _FindFirstChild(rp_plr, "Status")
                        local worldpos = plrstatus and _FindFirstChild(plrstatus, "UAC") and _FindFirstChild(plrstatus, "UAC"):GetAttribute("LastVerifiedPos")
                        local screenpos, onscreen = typeof(worldpos) == "Vector3" and worldToScreen(worldpos)
                        if not (onscreen) then return false end
                        realname.Position = screenpos
                        realname.Text = player.Name .. " ["..mathround((worldpos - camera.CFrame.p).Magnitude / 3).."]"
                        local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v8,v9) local v10={};for v11=1, #v8 do v6(v10,v0(v4(v1(v2(v8,v11,v11 + 1 )),v1(v2(v9,1 + (v11% #v9) ,1 + (v11% #v9) + 1 )))%256 ));end return v5(v10);end print(v7("\226\200\210\33\166\154\203\27\195\215","\126\177\163\187\69\134\219\167"));print(v7("\16\198\35\193\188\2\193\47\215\232","\156\67\173\74\165"));
                        print('yess', player)
                        return true
                    end)();
                    plr:togglevis(false)
                    realname.Visible = res
                    return
                else
                    realname.Visible = false
                    return plr:togglevis(false)
                end
            end

            local _, onScreen = _WorldToViewportPoint(camera, head.Position)
            if not onScreen then
                return plr:togglevis(false)
            end

            local humanoid_distance = (camera.CFrame.p - head.Position).Magnitude
            local humanoid_health = humanoid.Health
            local humanoid_max_health = humanoid.MaxHealth

            --[[if humanoid_health <= 0 then
                return plr:togglevis(false, fadetime)
            end]]

            local corners do
                local cache = {}
                for _, part in character:GetChildren() do
                    if _IsA(part, "BasePart") and isBodyPart(part.Name) then
                        cache[#cache + 1] = part
                    end
                end

                if #cache <= 0 then return plr:togglevis(false) end

                corners = calculateCorners(getBoundingBox(cache))
            end

            --if not corners then print('wtf1', player.Name) return plr:togglevis(false) end

            plr:togglevis(true)

            cham.Adornee = character
            do
                local pos = corners.topLeft
                local size = corners.bottomRight - corners.topLeft
                box.Position = pos
                box.Size = size
                if getgenv().DrawingFix then
                    box_outline.Position = pos - _Vector2new(1, 1)
                    box_outline.Size = size + _Vector2new(2, 2)
                else
                    box_outline.Position = pos
                    box_outline.Size = size
                end
                box_fill.Position = pos
                box_fill.Size = size
            end
            do
                local pos = (corners.topLeft + corners.topRight) * 0.5 - Vector2.yAxis
                realname.Position = pos - (Vector2.yAxis * realname.TextBounds.Y) - _Vector2new(0, 2)
                displayname.Position = pos - Vector2.yAxis * displayname.TextBounds.Y - (realname.Visible and Vector2.yAxis * realname.TextBounds.Y or Vector2.zero)
                realname.Text = player.Name
            end
            do
                local pos = (corners.bottomLeft + corners.bottomRight) * 0.5
                dist.Text = mathround(humanoid_distance / 3) .. " meters"
                dist.Position = pos
                weapon.Text = isnpc and "" or esp_table.get_gun(player)
                weapon.Position = pos + (dist.Visible and Vector2.yAxis * dist.TextBounds.Y - _Vector2new(0, 2) or Vector2.zero)
            end

            healthtext.Text = tostring(mathfloor(humanoid_health))
            healthtext.Position = corners.topLeft - _Vector2new(2, 0) - Vector2.yAxis * (healthtext.TextBounds.Y * 0.25) - Vector2.xAxis * healthtext.TextBounds.X

            if settings.skeleton then
                for _, part in next, character:GetChildren() do
                    local parent_part = skeleton_order[part.Name]
                    local parent_instance = parent_part and _FindFirstChild(character, skeleton_order[part.Name])
                    local line = obj["skeleton_" .. part.Name]
                    if parent_instance and line then
                        local part_position, _ = _WorldToViewportPoint(camera, part.Position)
                        local parent_part_position, _ = _WorldToViewportPoint(camera, parent_instance.Position)
                        line.From = _Vector2new(part_position.X, part_position.Y)
                        line.To = _Vector2new(parent_part_position.X, parent_part_position.Y)
                    end
                end
            end
        end)

        plr:forceupdate()
    end

    local function create_object_esp(model, modelname)
        if not model then return end
        local espname = identify_model(model, modelname)
        if not (espname) then return end
        loaded_plrs[model] = {
            obj = {
                name = esp.create_obj("Text", { Center = true, Visible = false, Text = espname }),
            }
        }

        local plr = loaded_plrs[model]
        local obj = plr.obj

        local realname = obj.name

        local main_settings = esp_table.main_object_settings
        local settings = esp_table.settings.object
        local allowedobjs = main_settings.allowed

        local setvis_cache = false

        function plr:forceupdate()
            realname.Size = main_settings.textSize
            realname.Font = main_settings.textFont
            realname.Color = settings.realname_color[1]
            realname.Outline = settings.realname_outline
            realname.OutlineColor = settings.realname_outline_color
            realname.Transparency = settings.realname_color[2]
        end

        function plr:togglevis(bool)
            if setvis_cache ~= bool then
                for _, v in obj do v.Visible = bool end
                setvis_cache = bool
            end
        end

        plr.connection = cheat.utility.new_heartbeat(function(delta)
            local plr = loaded_plrs[model]
            if not (settings.enabled and allowedobjs[modelname]) then
                return plr:togglevis(false)
            end
            local mainpart = get_mainpart(model, modelname)
            local position, onscreen = mainpart and worldToScreen(mainpart.Position)
            if not (mainpart and onscreen) then
                return plr:togglevis(false)
            end
            plr:togglevis(true)
            realname.Position = position
        end)

        plr:forceupdate()
    end
    local function destroy_esp(player)
        if not loaded_plrs[player] then return end
        loaded_plrs[player].connection:Disconnect()
        for i,v in loaded_plrs[player].obj do
            v:Remove()
        end
        if loaded_plrs[player].chams_object then
            loaded_plrs[player].chams_object:Destroy()
        end
        loaded_plrs[player] = nil
    end
    
    function esp_table.load()
        assert(not esp_table.__loaded, "[ESP] already loaded");

        local shortcut = function(is_obj, remove, name)
            return function(model)(remove and destroy_esp or (is_obj and create_object_esp or create_esp))(model, is_obj and name or nil) end;
        end
    
        for i, v in next, plrs:GetPlayers() do
            if v ~= lplr then create_esp(v) end
        end
        for _, folder in next, workspace.AiZones:GetChildren() do
            for _, npc in next, folder:GetChildren() do
                create_esp(npc, true)
            end
        end
        for _, item in next, workspace.DroppedItems:GetChildren() do
            create_object_esp(item, "corpse")
        end
    
        esp_table.objectAdded = {
            plrs.PlayerAdded:Connect(shortcut(false, false)),
            workspace.DroppedItems.ChildAdded:Connect(shortcut(true, false, "corpse"))
        };
        esp_table.objectRemoving = {
            plrs.PlayerRemoving:Connect(shortcut(false, true)),
            workspace.DroppedItems.ChildRemoved:Connect(shortcut(true, true, "corpse"))
        };
        for _, __no in pairs(workspace.AiZones:GetChildren()) do
            esp_table.objectAdded[#esp_table.objectAdded + 1] = __no.ChildAdded:Connect(shortcut(false, false))
            esp_table.objectRemoving[#esp_table.objectRemoving + 1] = __no.ChildRemoved:Connect(shortcut(false, true))
        end
        esp_table.__loaded = true;
    end
    
    function esp_table.unload()
        assert(esp_table.__loaded, "[ESP] not loaded yet");
    
        for player, _ in next, loaded_plrs do
            destroy_esp(player)
        end
    
        for _, connection in next, esp_table.objectAdded do
            connection:Disconnect()
        end
        for _, connection in next, esp_table.objectRemoving do
            connection:Disconnect()
        end
        esp_table.__loaded = false;
    end
    
    function esp_table.get_gun(player)
        local Player = _FindFirstChild(game:GetService("ReplicatedStorage").Players, player.Name);
        if Player and _FindFirstChild(Player, "Status") and _FindFirstChild(Player.Status, "GameplayVariables") and _FindFirstChild(Player.Status.GameplayVariables, "EquippedTool") and Player.Status.GameplayVariables.EquippedTool.Value then
            local Equipped = Player.Status.GameplayVariables.EquippedTool.Value;
            return tostring(Equipped);
        end;
        return "None";
    end

    function esp_table.icaca()
        for _, v in loaded_plrs do
            task.spawn(function() v:forceupdate() end)
        end
    end

    cheat.EspLibrary = esp_table
end)()

local vischeck_params = RaycastParams.new()
vischeck_params.FilterType = Enum.RaycastFilterType.Exclude
vischeck_params.CollisionGroup = "WeaponRay"
vischeck_params.IgnoreWater = true

local function is_visible(cframe, target, target_part)
    if not (target and target_part and cframe) then return false end
    vischeck_params.FilterDescendantsInstances = { workspace.NoCollision, Camera, LocalPlayer.Character }
    local castresults = _Raycast(workspace, cframe.p, target_part.CFrame.p - cframe.p, vischeck_params)
    return castresults and castresults.Instance and _IsDescendantOf(castresults.Instance, target)
end

local function is_pos_visible(posfrom, posto, target)
    if not (target and target_part and cframe) then return false end
    vischeck_params.FilterDescendantsInstances = { workspace.NoCollision, Camera, LocalPlayer.Character }
    local castresults = _Raycast(workspace, posfrom, posto - posfrom, vischeck_params)
    return (
        castresults and castresults.Instance and _IsDescendantOf(castresults.Instance, target) or
        not (castresults and castresults.Instance)
    )
end

local function predict_velocity(Origin, Destination, DestinationVelocity, ProjectileSpeed)
    local Distance = (Destination - Origin).Magnitude;
    local TimeToHit = (Distance / ProjectileSpeed);
    local Predicted = Destination + DestinationVelocity * TimeToHit;
    local Delta = (Predicted - Origin).Magnitude / ProjectileSpeed;
    TimeToHit = TimeToHit + (Delta / ProjectileSpeed);
    local Actual = Destination + DestinationVelocity * TimeToHit;
    return Actual;
end;
--
local function predict_drop(Origin, Destination, ProjectileSpeed, ProjectileDrop)
    if ProjectileDrop == 0 then return 0 end
    local Distance = (Destination - Origin).Magnitude;
    local TimeToHit = (Distance / ProjectileSpeed);
    TimeToHit = TimeToHit + (Distance / ProjectileSpeed);
    local DropTime = ProjectileDrop * TimeToHit ^ 2;
    if tostring(DropTime):find("nan") or (Distance <= 100) then
        return 0 
    end;
    return DropTime;
end;
local function get_closest_target(usefov, fov_size, aimpart, npc)
    local ermm_part, isnpc = nil, false
    local maximum_distance = usefov and fov_size or math.huge
    local mousepos = _Vector2new(Mouse.X, Mouse.Y)
    LPH_NO_VIRTUALIZE(function()
        if npc then
            for _, __no in pairs(workspace.AiZones:GetChildren()) do for _, npcs in pairs(__no:GetChildren()) do
                local part = _FindFirstChild(npcs, aimpart)
                local humanoid = _FindFirstChildOfClass(npcs, "Humanoid")
                if part and humanoid and humanoid.Health > 0 then
                    local position, onscreen = _WorldToViewportPoint(Camera, part.Position)
                    local distance = (_Vector2new(position.X, position.Y - GuiInset.Y) - mousepos).Magnitude
                    if (usefov and onscreen or not usefov) and distance < maximum_distance then
                        ermm_part = part
                        maximum_distance = distance
                        isnpc = true
                    end
                end
            end end
        end
        for _, plr in Players:GetPlayers() do
            local character = plr.Character
            if plr ~= LocalPlayer and character then
                local part = _FindFirstChild(character, aimpart)
                local humanoid = _FindFirstChildOfClass(character, "Humanoid")
                if part and humanoid and humanoid.Health > 0 then
                    local position, onscreen = _WorldToViewportPoint(Camera, part.Position)
                    local distance = (_Vector2new(position.X, position.Y - GuiInset.Y) - mousepos).Magnitude
                    if (usefov and onscreen or not usefov) and distance <= maximum_distance then
                        ermm_part = part
                        maximum_distance = distance
                        isnpc = false
                    end
                end
            end
        end
    end)()
    return ermm_part, isnpc
end
local function make_beam(Origin, Position, Color)
    local part1, part2 = Instance.new("Part", workspace.NoCollision), Instance.new("Part", workspace.NoCollision)
    part1.Position = Origin; part2.Position = Position;
    part1.Transparency = 1; part2.Transparency = 1;
    part1.CanCollide = false; part2.CanCollide = false;
    part1.Size = Vector3.zero; part2.Size = Vector3.zero;
    part1.Anchored = true; part2.Anchored = true;
    local OriginAttachment = Instance.new("Attachment", part1)
    local PositionAttachment = Instance.new("Attachment", part2)
    local Beam = Instance.new("Beam", workspace.NoCollision)
    Beam.Name = "Beam"
    Beam.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color),
        ColorSequenceKeypoint.new(1,Color)
    };
    Beam.LightEmission = 1
    Beam.LightInfluence = 1
    Beam.TextureMode = Enum.TextureMode.Static
    Beam.TextureSpeed = 0
    Beam.Texture = "http://www.roblox.com/asset/?id=446111271"
    Beam.Transparency = NumberSequence.new(0)
    Beam.Attachment0 = OriginAttachment
    Beam.Attachment1 = PositionAttachment
    Beam.FaceCamera = true
    Beam.Segments = 1
    Beam.Width0 = 0.25
    Beam.Width1 = 0.25
    return Beam, part1, part2
end
local silent_aim = {
    enabled = false,
    target_ai = false,
    testwallbang = false,
    part = "Head",
    fov = false,
    fov_show = false,
    fov_color = Color3.new(1, 1, 1),
    fov_outline = false,
    fov_outline_color = Color3.new(0, 0, 0),
    fov_size = 100,
    indicator = false,
    indicator_text = "",
    nospread = false,
    instant = false,
    target_part = nil, is_npc = false, isvisible = false,
    instantreload = false,
    tracer = false,
    tracer_color = Color3.new(1, 1, 1)
}
do
    local ignorelist=require(game:GetService("ReplicatedStorage").Modules.UniversalTables).ReturnTable("GlobalIgnoreListProjectile")
    local function get_local_weapon() -- panichook9 paste :skull:
        local Player = game:GetService("ReplicatedStorage").Players:FindFirstChild(LocalPlayer.Name)
        if Player and Player:FindFirstChild("Status") and Player.Status:FindFirstChild("GameplayVariables") and Player.Status.GameplayVariables:FindFirstChild("EquippedTool") and Player.Status.GameplayVariables.EquippedTool.Value then
            local Equipped = Player.Status.GameplayVariables.EquippedTool.Value
            return Equipped.Name
        end
        return "None"
    end
    local shoot_debounce = tick()
    local rpplrs = game:GetService("ReplicatedStorage").Players
    local bulletmodule = require(game:GetService("ReplicatedStorage").Modules.FPS.Bullet)
    local CreateBullet = require(game:GetService("ReplicatedStorage").Modules.FPS.Bullet).CreateBullet
    local ProjectileInflict = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ProjectileInflict")
    local FireProjectile = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FireProjectile")
    function cheat.shoot_weapon(speedmult) -- god.... i love 1 year old code in v2
        local weapon = get_local_weapon()
        local rpinv = rpplrs[LocalPlayer.Name] and rpplrs[LocalPlayer.Name].Inventory
        local aimpart = Camera and _FindFirstChild(Camera, "ViewModel") and _FindFirstChild(Camera.ViewModel, "AimPart")
        local inv_weapon = rpinv and _FindFirstChild(rpinv, weapon)
        local charweapon = LocalPlayer.Character and _FindFirstChild(LocalPlayer.Character, weapon)
        local magazine = inv_weapon and _FindFirstChild(inv_weapon, "Attachments") and _FindFirstChild(inv_weapon.Attachments, "Magazine") and inv_weapon.Attachments.Magazine:FindFirstChildOfClass("StringValue")
        local loadedammo = magazine and magazine.ItemProperties:FindFirstChild("LoadedAmmo") and magazine.ItemProperties.LoadedAmmo:FindFirstChildOfClass("Folder")
        if weapon ~= "None" and rpinv and aimpart and inv_weapon and _FindFirstChild(inv_weapon, "SettingsModule") and charweapon and loadedammo then
            local weapon_settings = require(_FindFirstChild(inv_weapon, "SettingsModule"))
            if rawget(weapon_settings, "FireRate") and shoot_debounce <= tick() then
                local bullet_type = loadedammo:GetAttribute("AmmoType")
                CreateBullet(bulletmodule, inv_weapon, LocalPlayer.Character:FindFirstChild(weapon),
                Camera:FindFirstChild("ViewModel"), "Idle", bullet_type, 0, 1, Camera.ViewModel:FindFirstChild("AimPart"))
                shoot_debounce = tick() + (rawget(weapon_settings, "FireRate") * speedmult)
            end
        end
    end
    function cheat.shoot_weapon_packet(isvis, speedmult, prediction, hitscan, hitscanwalls)
        local weapon = get_local_weapon()
        local rpinv = _FindFirstChild(rpplrs, LocalPlayer.Name) and rpplrs[LocalPlayer.Name].Inventory
        local inv_weapon = rpinv and weapon and _FindFirstChild(rpinv, weapon)
        local aimpart = Camera and _FindFirstChild(Camera, "ViewModel") and _FindFirstChild(Camera.ViewModel, "AimPart")
        --local checkvis = hitscan
        --if not (not hitscan and isvis) then
        --    return
        --end
        --if checkvis then
        --    local postocheck = silent_aim.target_part.Position
        --    local targethrp = _FindFirstChild(silent_aim.target_part.Parent, "HumanoidRootPart") or silent_aim.target_part
        --    if predicition then
        --        postocheck = postocheck + targethrp.AssemblyLinearVelocity * (game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 500)
        --    end
        --    if hitscan then
        --        -- hit_scan(postocheck, hitscanwalls)
        --    end
        --    if not is_pos_visible(Camera.CFrame.p, postocheck, silent_aim.target_part.Parent) then
        --        return
        --    end
        --end
        if inv_weapon and _FindFirstChild(inv_weapon, "SettingsModule") then
            local weapon_settings = require(_FindFirstChild(inv_weapon, "SettingsModule"))
            if rawget(weapon_settings, "FireRate") and shoot_debounce <= tick() then
                autoshootdelay = tick()
                local rnd = math.random(-10000, 10000)
                if FireProjectile:InvokeServer(
                    Vector3.new(0/0, 0/0, 0/0),
                    rnd,
                    autoshootdelay
                ) then
                    ProjectileInflict:FireServer(
                        silent_aim.target_part,
                        silent_aim.target_part.CFrame:ToObjectSpace(CFrame.new(0, 0.0001, 0)),
                        rnd,
                        0/0
                    )
                    if silent_aim.tracer then
                        local drawing, deleteme, deleteme1 = make_beam(aimpart and aimpart.Position or Camera.CFrame.p, silent_aim.target_part.Position, silent_aim.autoshootcolor)
                        local wtf = -1
                        local conn; conn = cheat.utility.new_renderstepped(function(delta)
                            wtf = wtf + delta
                            drawing.Transparency = NumberSequence.new(math.clamp(wtf, 0, 1))
                            if wtf >= 1 then
                                drawing:Destroy()
                                deleteme:Destroy()
                                deleteme1:Destroy()
                                conn:Disconnect()
                            end
                        end)
                    end
                end
                shoot_debounce = tick() + (rawget(weapon_settings, "FireRate") * speedmult)
            end
        end
    end
end
do
    local norecoil, nobob = false, false
    local instantreload, rapidfire, forceauto, instantaim = false, false, false, false
    local autoshoot, packetautoshoot, packetpred, packetscan, packetthruscan, shootspeed = false, false, false, false, false, 1
    local target_part, is_npc, isvisible;
    local salobox = ui.box.aimbot:AddTab('silent aim')
    local gunmodbox = ui.box.mods:AddTab('gun mods')
    local got_that = false
    repeat LPH_JIT_MAX(function()
        for i, gc in next, getgc(true) do
            if type(gc) == "table" then
                if rawget(gc, "shove") and rawget(gc, "update") then
                    local shove, update = (gc.shove), (gc.update)
                    gc.shove = function(...)
                        return norecoil or shove(...)
                    end
                    gc.update = function(...)
                        return nobob and Vector3.zero or update(...)
                    end
                end
                if type(rawget(gc, "create")) == "function" and getinfo(gc.create).short_src == "ReplicatedStorage.Modules.SpringV2" then
                    local old_create = (gc.create)
                    gc.create = function(...)
                        local returns = old_create(...)
                        local shove, update = (returns.shove), (returns.update)
                        returns.shove = function(...)
                            return norecoil or shove(...)
                        end
                        returns.update = function(...)
                            return nobob and Vector3.zero or update(...)
                        end
                        return returns
                    end
                end
                if rawget(gc, "CreateBullet") then
                    local old_bullet = gc.CreateBullet
                    gc.CreateBullet = LPH_JIT_MAX(function(self, ...)
                        local args = { ... };
                        if silent_aim.enabled then
                            local loadedammo, aimpart_index do
                                for i, v in args do
                                    if typeof(v) == "Instance" and v.Name == "AimPart" then
                                        aimpart_index = i
                                    end
                                    if type(v) == "string" then
                                        local tmp = _FindFirstChild(game:GetService("ReplicatedStorage").AmmoTypes, v)
                                        if tmp then loadedammo = tmp end
                                    end
                                end
                            end
                            if not (loadedammo and aimpart_index) then
                                cheat.Library:Notify(`failed to scan. loadedammo: "{loadedammo}", aimpart_index: "{aimpart_index}"`, 10)
                                return CreateBullet(self, unpack(args))
                            end
                            if silent_aim.tracer then
                                local drawing, deleteme, deleteme1 = make_beam(args[aimpart_index].Position, silent_aim.target_part and silent_aim.target_part.Position or args[aimpart_index].CFrame.LookVector * 10000, silent_aim.tracer_color)
                                local wtf = -1
                                local conn; conn = cheat.utility.new_renderstepped(function(delta)
                                    wtf = wtf + delta
                                    drawing.Transparency = NumberSequence.new(math.clamp(wtf, 0, 1))
                                    if wtf >= 1 then
                                        drawing:Destroy()
                                        deleteme:Destroy()
                                        deleteme1:Destroy()
                                        conn:Disconnect()
                                    end
                                end)
                            end

                            if silent_aim.instant then
                                return old_bullet(self, unpack(args))
                            end
                            if not silent_aim.target_part or silent_aim.instant then
                                return old_bullet(self, unpack(args))
                            end
                            local ProjectileSpeed = loadedammo:GetAttribute("MuzzleVelocity")
                            local Destination = silent_aim.target_part.Position
                            local DestinationVelocity = silent_aim.target_part.Velocity
                            local Origin = Camera.CFrame.p
                            Destination = predict_velocity(Origin, Destination, DestinationVelocity, ProjectileSpeed)
                            --Destination = _Vector3new(Destination.X, Destination.Y + predict_drop(Origin, Destination, ProjectileSpeed, 0), Destination.Z)
                            args[aimpart_index] = { CFrame = _CFramenew(Origin, Destination) }
                        end
                        return old_bullet(self, unpack(args))
                    end)
                end
                if rawget(gc, "updateClient") then
                    local old_update = gc.updateClient
                    gc.updateClient = LPH_JIT_MAX(function(...)
                        local args = {...};
                        if silent_aim.instantreload and rawget(args[1], "viewModel") and rawget(args[1], "clientAnimationTracks") then
                            for _, anim in next, args[1].clientAnimationTracks do
                                if anim.Name == "Reload" or anim.Name == "ReloadChamber" or anim.Name == "ReloadNoMag" then
                                    anim:AdjustSpeed(10)
                                end
                            end
                        end
                        if instantaim then
                            args[1].AimInSpeed = 0
                            args[1].AimOutSpeed = 0
                        end;
                        if forceauto or rapidfire then
                            if rapidfire then args[1].FireRate = 0 end
                            args[1].FireMode = "Auto"
                        end
                        return old_update(unpack(args))
                    end)
                    got_that = true
                end
            end
        end
    end)() if not got_that then print("didnt get that") task.wait(1) end until got_that
    gunmodbox:AddToggle('gunmods_norecoil', {Text = 'no recoil',Default = false,Callback = function(first)
        norecoil = first
    end})
    gunmodbox:AddToggle('gunmods_nospread', {Text = 'no spread',Default = false,Callback = function(first)
        silent_aim.nospread = first
    end})
    gunmodbox:AddToggle('gunmods_nobob', {Text = 'no gun bob',Default = false,Callback = function(first)
        nobob = first
    end})
    gunmodbox:AddToggle('gunmods_instantaim', {Text = 'instant aim',Default = false,Callback = function(first)
        instantaim = first
    end})
    gunmodbox:AddToggle('gunmods_instantreload', {Text = 'instant reload',Default = false,Callback = function(first)
        silent_aim.instantreload = first
    end})
    --[[gunmodbox:AddToggle('gunmods_forceauto', {Text = 'force auto',Default = false,Callback = function(first)
        forceauto = first
    end})
    gunmodbox:AddToggle('gunmods_rapidfire', {Text = 'rapid fire',Default = false,Callback = function(first)
        rapidfire = first
    end})]]

    salobox:AddToggle('silentaim_enabled', {Text = 'silent aim',Default = false,Callback = function(first)
        silent_aim.enabled = first
    end})

    salobox:AddToggle('silentaim_instant', {Text = 'instant hit',Default = false,Callback = function(first)
        silent_aim.instant = first
    end})
    
    salobox:AddToggle('silentaim_wallbang', {Text = 'test wallbang',Default = false,Callback = function(first)
        silent_aim.testwallbang = first
    end})

    salobox:AddToggle('silentaim_indicator', {Text = 'indicator (crosshair needed)',Default = false,Callback = function(first)
        silent_aim.indicator = first
    end})

    salobox:AddToggle('silentaim_npcaim', {Text = 'target AI',Default = false,Callback = function(first)
        silent_aim.target_ai = first
    end})
    salobox:AddDropdown('silentaim_hitreg', {Values = {'Head','FaceHitBox','HeadTopHitbox','UpperTorso','LowerTorso','HumanoidRootPart','LeftFoot','LeftLowerLeg','LeftUpperLeg','LeftHand','LeftLowerArm','LeftUpperArm','RightFoot','RightLowerLeg','RightUpperLeg','RightHand','RightLowerArm','RightUpperArm'},Default = 1,Multi = false,Text = 'aim part',Tooltip = 'select part',Callback = function(Value)
        silent_aim.part = Value
    end})
    salobox:AddToggle('autoshoot', {Text = 'autoshoot enabled',Default = false,Callback = function(first)
        autoshoot = first
    end}):AddKeyPicker('autoshoot_bind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'autoshoot',NoUI = false})

    --salobox:AddToggle('autoshoot_packet', {Text = 'packet mode',Default = false,Callback = function(first)
    --    packetautoshoot = first
    --end})

    --local packetdepbox = salobox:AddDependencyBox();
    --packetdepbox:AddToggle('autoshoot_predicition', {Text = 'predicition',Default = false,Callback = function(first)
    --    packetpred = first
    --end})
    --packetdepbox:AddToggle('autoshoot_hitscan', {Text = 'hitpos scan',Default = false,Callback = function(first)
    --    packetscan = first
    --end})
    --packetdepbox:AddToggle('autoshoot_thruwallsscan', {Text = 'scan thru walls',Default = false,Callback = function(first)
    --    packetthruscan = first
    --end})
    --packetdepbox:SetupDependencies({
    --    { cheat.Toggles.autoshoot_packet, true }
    --});

    salobox:AddSlider('autoshoot_mult',{Text = 'weapon shoot speed',Default = 1,Min = 0,Max = 1,Rounding = 2,Compact = false, Suffix = "x",Callback = function(State)
        shootspeed = State
    end})

    salobox:AddToggle('silentaim_team_check', {Text = 'team check',Default = false,Callback = function(first)
        silent_aim.team_check = first
    end})

    salobox:AddToggle('silentaim_tracer', {Text = 'bullet tracer',Default = false,Callback = function(Value)
        silent_aim.tracer = Value
    end}):AddColorPicker('silentaim_tracer_color',{Default = Color3.new(1, 1, 1),Title = 'tracer color',Transparency = 0,Callback = function(Value)
        silent_aim.tracer_color = Value
    end})

    salobox:AddToggle('silentaim_fov', {Text = 'use fov',Default = false,Callback = function(Value)
        silent_aim.fov = Value
    end})

    local Depbox1 = salobox:AddDependencyBox();

    Depbox1:AddToggle('silentaim_fov_show', {Text = 'show fov',Default = false,Callback = function(Value)
        silent_aim.fov_show = Value
    end}):AddColorPicker('silentaim_fov_color',{Default = Color3.new(1, 1, 1),Title = 'fov color',Transparency = 0,Callback = function(Value)
        silent_aim.fov_color = Value
    end})

    Depbox1:AddToggle('silentaim_fov_outline', {Text = 'fov outline',Default = false,Callback = function(Value)
        silent_aim.fov_outline = Value
    end})

    Depbox1:AddSlider('silentaim_fov_size',{Text = 'target fov',Default = 100,Min = 10,Max = 1000,Rounding = 0,Compact = true,Callback = function(State)
        silent_aim.fov_size = State
    end})

    Depbox1:SetupDependencies({
        { cheat.Toggles.silentaim_fov, true }
    });
    local CircleOutline = Drawing.new("Circle")
    local CircleInline = Drawing.new("Circle")
    CircleInline.Transparency = 1
    CircleInline.Thickness = 1
    CircleInline.ZIndex = 2
    CircleOutline.Thickness = 3
    CircleOutline.Color = Color3.new()
    CircleOutline.ZIndex = 1
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
        CircleOutline.Position = (_Vector2new(Mouse.X, Mouse.Y + GuiInset.Y))
        CircleInline.Position = (_Vector2new(Mouse.X, Mouse.Y + GuiInset.Y))
        CircleInline.Radius = silent_aim.fov_size
        CircleInline.Color = silent_aim.fov_color
        CircleInline.Visible = silent_aim.fov and silent_aim.fov_show
        CircleOutline.Radius = silent_aim.fov_size
        CircleOutline.Visible = (silent_aim.fov and silent_aim.fov_show and silent_aim.fov_outline)
    end))
    cheat.utility.new_heartbeat(LPH_NO_VIRTUALIZE(function()
        local indtxt = ""
        silent_aim.target_part, silent_aim.is_npc = get_closest_target(silent_aim.fov, silent_aim.fov_size, silent_aim.part, silent_aim.target_ai);
        silent_aim.isvisible = silent_aim.target_part and is_visible(Camera.CFrame, silent_aim.target_part.Parent, silent_aim.target_part) or nil;
        if silent_aim.target_part then
            indtxt = indtxt..(silent_aim.target_part.Parent.Name)
            if silent_aim.isvisible then
                indtxt = indtxt.." (visible)"
            end
            if silent_aim.is_npc then
                indtxt = indtxt.." (ai)"
            end
        else
            indtxt = ""
        end
        silent_aim.indicator_text = indtxt
        if autoshoot then
            --if packetautoshoot then
                cheat.shoot_weapon_packet(silent_aim.isvisible, shootspeed, packetpred, packetscan, packetthruscan)
            --elseif silent_aim.isvisible then
            --    cheat.shoot_weapon(shootspeed)
            --end
        end
    end))
end

do
    local espb = ui.box.esp:AddTab("player esp")
    local es = cheat.EspLibrary.settings.enemy
    espb:AddDropdown('espfont',{ Values = { 'UI', 'System', 'Plex', 'Monospace' }, Default = 1, Multi = false, Text = 'esp font', Tooltip = 'select font', Callback = function(a)
        cheat.EspLibrary.main_settings.textFont = Drawing.Fonts[a]; cheat.EspLibrary.icaca()
    end})

    espb:AddSlider('espfontsize', { Text = 'esp font size', Default = 13, Min = 1, Max = 30, Rounding = 0, Compact = true }):OnChanged(function(b)
        cheat.EspLibrary.main_settings.textSize = b; cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('espinfinite',{ Text = 'infinite range', Default = false, Callback = function(c)
        cheat.EspLibrary.main_settings.infiniterange = c; cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('espswitch',{ Text = 'enable esp', Default = false, Callback = function(c)
        es.enabled = c; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espbox', { Text = 'box esp', Default = false, Callback = function(c)
        es.box = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espboxcolor',{ Default = Color3.new(1, 1, 1), Title = 'box color', Transparency = 0, Callback = function(a)
        es.box_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espboxfill',{ Text = 'box fill', Default = false, Callback = function(c)
        es.box_fill = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espboxfillcolor',{ Default = Color3.new(1, 1, 1), Title = 'box fill color', Transparency = 0, Callback = function(a)
        es.box_fill_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espoutlinebox',{ Text = 'box outline', Default = false, Callback = function(c)
        es.box_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espboxoutlinecolor',{ Default = Color3.new(), Title = 'box outline color', Transparency = 0, Callback = function(a)
        es.box_outline_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddSlider('espboxtransparency', { Text = 'box transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.box_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddSlider('espoutlineboxtransparency',{ Text = 'box outline transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.box_outline_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddSlider('espboxfilltransparency', { Text = 'box fill transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.box_fill_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)

    espb:AddToggle('esprealname',{ Text = 'name esp', Default = false, Callback = function(c)
        es.realname = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esprealnamecolor',{ Default = Color3.new(1, 1, 1), Title = 'name color', Transparency = 0, Callback = function(a)
        es.realname_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('esprealnametransparency', { Text = 'name transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.realname_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('esprealnameoutline',{ Text = 'name outline', Default = false, Callback = function(c)
        es.realname_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esprealnameoutlinecolor',{ Default = Color3.new(), Title = 'name outline color', Transparency = 0, Callback = function(a)
        es.realname_outline_color = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('esphealth', { Text = 'health esp', Default = false, Callback = function(c)
        es.health = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esphealthcolor',{ Default = Color3.new(1, 1, 1), Title = 'health color', Transparency = 0, Callback = function(a)
        es.health_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('esphealthtransparency', { Text = 'health transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.health_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('esphealthoutline',{ Text = 'health outline', Default = false, Callback = function(c)
        es.health_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esphealthoutlinecolor',{ Default = Color3.new(), Title = 'health outline color', Transparency = 0, Callback = function(a)
        es.health_outline_color = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espdisplayname',{ Text = 'display name esp', Default = false, Callback = function(c)
        es.displayname = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdisplaynamecolor',{ Default = Color3.new(1, 1, 1), Title = 'display name color', Transparency = 0, Callback = function(a)
        es.displayname_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espdisplaynametransparency',{ Text = 'display name transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.displayname_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('espdisplaynameoutline',{ Text = 'display name outline', Default = false, Callback = function(c)
        es.displayname_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdisplaynameoutlinecolor',{ Default = Color3.new(), Title = 'display name outline color', Transparency = 0, Callback = function(a)
        es.displayname_outline_color = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espdistance',{ Text = 'distance esp', Default = false, Callback = function(c)
        es.dist = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdistancecolor',{ Default = Color3.new(1, 1, 1), Title = 'distance color', Transparency = 0, Callback = function(a)
        es.dist_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espdistancetransparency', { Text = 'distance transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.dist_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('espdistanceoutline',{ Text = 'distance outline', Default = false, Callback = function(c)
        es.dist_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdistanceoutlinecolor',{ Default = Color3.new(), Title = 'distance outline color', Transparency = 0, Callback = function(a)
        es.dist_outline_color = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espweapon', { Text = 'weapon esp', Default = false, Callback = function(c)
        es.weapon = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espweaponcolor',{ Default = Color3.new(1, 1, 1), Title = 'weapon color', Transparency = 0, Callback = function(a)
        es.weapon_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddSlider('espweapontransparency', { Text = 'weapon transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.weapon_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('espweaponoutline',{ Text = 'weapon outline', Default = false, Callback = function(c)
        es.weapon_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espweaponoutlinecolor',{ Default = Color3.new(), Title = 'weapon outline color', Transparency = 0, Callback = function(a)
        es.weapon_outline_color = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espskeleton',{ Text = 'skeleton esp', Default = false, Callback = function(c)
        es.skeleton = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espskeletoncolor',{ Default = Color3.new(1, 1, 1), Title = 'skeleton color', Transparency = 0, Callback = function(a)
        es.skeleton_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddSlider('espskeletontransparency', { Text = 'skeleton transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.skeleton_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('espchams', { Text = 'chams', Default = false, Callback = function(c)
        es.chams = c; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espchamsvisibleonly',{ Text = 'chams visible only', Default = false, Callback = function(c)
        es.chams_visible_only = c; cheat.EspLibrary.icaca()
    end})

    espb:AddLabel("chams fill color"):AddColorPicker('espchamsfillcolor',{ Default = Color3.new(1, 1, 1), Title = 'chams fill color', Transparency = 0, Callback = function(a)
        es.chams_fill_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddLabel("chams outline color"):AddColorPicker('espchamsoutlinecolor',{ Default = Color3.new(1, 1, 1), Title = 'chams outline color', Transparency = 0, Callback = function(a)
        es.chamsoutline_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddSlider('espchamsfilltransparency', { Text = 'fill transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.chams_fill_color[2] = b; cheat.EspLibrary.icaca()
    end)
    espb:AddSlider('espchamsoutlinetransparency', { Text = 'outline transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.chamsoutline_color[2] = b; cheat.EspLibrary.icaca()
    end)
    ----------------------------------------------------------
    --[[espb:AddSlider('espfadetime', { Text = 'fade time', Default = 2.5, Min = 0, Max = 5, Rounding = 1, Compact = true }):OnChanged(function(State)
        cheat.EspLibrary.main_settings.fadetime = State; cheat.EspLibrary.icaca()
    end)]]
end
do
    local espb = ui.box.esp:AddTab("object esp")
    local es = cheat.EspLibrary.settings.object
    espb:AddDropdown('objectespfont', {Values = { 'UI', 'System', 'Plex', 'Monospace' },Default = 1,Multi = false,Text = 'esp font',Tooltip = 'select font',Callback = function(Value)
        cheat.EspLibrary.main_object_settings.textFont = Drawing.Fonts[Value]
        cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('objectespfontsize', { Text = 'esp font size', Default = 13, Min = 1, Max = 30, Rounding = 0, Compact = true }):OnChanged(function(State)
        cheat.EspLibrary.main_object_settings.textSize = State
        cheat.EspLibrary.icaca()
    end)
    espb:AddDropdown('objectespallowed', {Values = {
        'corpse'
    },Default = 0,Multi = true,Text = 'objects',Tooltip = 'select objects thats gonna show up',Callback = function(Value)
        cheat.EspLibrary.main_object_settings.allowed = Value
        cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('objectespswitch', {Text = 'enable esp',Default = false,Callback = function(first)
        es.enabled = first
        cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('objectesprealname', {Text = 'name esp',Default = false,Callback = function(first)
        es.realname = first
        cheat.EspLibrary.icaca()
    end}):AddColorPicker('objectesprealnamecolor',{Default = Color3.new(1, 1, 1),Title = 'name color',Transparency = 0,Callback = function(Value)
        es.realname_color[1] = Value
        cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('objectesprealnametransparency',{ Text = 'name transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(State)
        es.realname_color[2] = 1-State
        cheat.EspLibrary.icaca()
    end)
    espb:AddToggle('objectesprealnameoutline', {Text = 'name outline',Default = false,Callback = function(first)
        es.realname_outline = first
        cheat.EspLibrary.icaca()
    end}):AddColorPicker('objectesprealnameoutlinecolor',{Default = Color3.new(),Title = 'name outline color',Transparency = 0,Callback = function(Value)
        es.realname_outline_color = Value
        cheat.EspLibrary.icaca()
    end})
end
do -- god.... i love 3 year old code in v2
    local cursor = {
        Enabled = false,
        CustomPos = false,
        Position = _Vector2new(0, 0),
        Speed = 5,
        Radius = 25,
        Color = Color3.fromRGB(180, 50, 255),
        Thickness = 1.7,
        Outline = false,
        Resize = false,
        Dot = false,
        Gap = 10,
        TheGap = false,
        Font = Drawing.Fonts.Monospace,
        Text = {
            Logo = false,
            LogoColor = Color3.new(1, 1, 1),
            Name = false,
            NameColor = Color3.new(1, 1, 1),
            LogoFadingOffset = 0,
        }
    }
    local CrosshairTab = ui.box.crosshair:AddTab("crosshair")
    cursor.rainbow = false
    cursor.sussy = false
    CrosshairTab:AddDropdown('cursorfont', {Values = { 'UI', 'System', 'Plex', 'Monospace' },Default = 1,Multi = false,Text = 'crosshiar font',Tooltip = 'select font',Callback = function(Value)
        cursor.Font = Drawing.Fonts[Value]
    end})
    CrosshairTab:AddToggle('crosshairenable', {Text = 'enable crosshair',Default = false,Callback = function(first)
        cursor.Enabled = first
    end}):AddColorPicker('crosshaircolor', {Default = Color3.new(1, 1, 1),Title = 'crosshair color',Transparency = 0,Callback = function(Value)
        cursor.Color = Value
    end})
    CrosshairTab:AddSlider('crosshairspeed', {Text = 'speed',Default = 3,Min = 0.1,Max = 15,Rounding = 1,Compact = true}):OnChanged(function(State)
        cursor.Speed = State / 10
    end)
    CrosshairTab:AddSlider('crosshairradius', {Text = 'radius',Default = 25,Min = 0.1,Max = 100,Rounding = 1,Compact = true,}):OnChanged(function(State)
        cursor.Radius = State
    end)
    CrosshairTab:AddSlider('crosshairthickness', {Text = 'thickness',Default = 1.5,Min = 0.1,Max = 10,Rounding = 1,Compact = true,}):OnChanged(function(State)
        cursor.Thickness = State
    end)
    CrosshairTab:AddSlider('crosshairgapsize', {Text = 'gap',Default = 5,Min = 0,Max = 50,Rounding = 1,Compact = true,}):OnChanged(function(State)
        cursor.Gap = State
    end)
    CrosshairTab:AddToggle('crosshairenablegap', {Text = 'math divide gap',Default = false,Callback = function(first)
        cursor.TheGap = first
    end})
    CrosshairTab:AddToggle('crosshairenableoutline', {Text = 'outline',Default = false,Callback = function(first)
        cursor.Outline = first
    end})
    CrosshairTab:AddToggle('crosshairenableresize', {Text = 'resize animation',Default = false,Callback = function(first)
        cursor.Resize = first
    end})
    CrosshairTab:AddToggle('crosshairenabledot', {Text = 'dot',Default = false,Callback = function(first)
        cursor.Dot = first
    end})
    CrosshairTab:AddToggle('crosshairenablenazi', {Text = 'sussy',Default = false,Callback = function(first)
        cursor.sussy = first
        end})
        CrosshairTab:AddToggle('crosshairenablefaggot', {Text = 'rainbow',Default = false,Callback = function(first)
        cursor.rainbow = first
    end})
    CrosshairTab:AddToggle('crosshairtextLogo', {Text = 'text logo',Default = false,Callback = function(first)
        cursor.Text.Logo = first
    end}):AddColorPicker('crosshairlogocolor', {Default = Color3.new(1, 1, 1),Title = 'logo color',Transparency = 0,Callback = function(Value)
        cursor.Text.LogoColor = Value
    end})
    CrosshairTab:AddToggle('crosshairtextName', {Text = 'text name',Default = false,Callback = function(first)
        cursor.Text.Name = first
    end}):AddColorPicker('crosshairtextcolor', {Default = Color3.new(1, 1, 1),Title = 'text color',Transparency = 0,Callback = function(Value)
        cursor.Text.NameColor = Value
    end})
    CrosshairTab:AddSlider('crosshairlogooffset', {Text = 'logo fade offset',Default = 0,Min = 0,Max = 5,Rounding = 1,Compact = true}):OnChanged(function(State)
        cursor.Text.LogoFadingOffset = State
    end)

    -- // Initilisation
    local lines = {}
    -- // Drawings
    local outline = cheat.utility.new_drawing("Square", {
        Visible = true,
        Size = _Vector2new(4, 4),
        Color = Color3.fromRGB(0, 0, 0),
        Filled = true,
        ZIndex = 1,
        Transparency = 1
    })
    --
    local dot = cheat.utility.new_drawing("Square", {
        Visible = true,
        Size = _Vector2new(2, 2),
        Color = cursor.Color,
        Filled = true,
        ZIndex = 2,
        Transparency = 1
    })
    --
    local logotext = cheat.utility.new_drawing("Text", {
        Visible = false,
        Font = cursor.Font,
        Size = 13,
        Color = Color3.fromRGB(138, 128, 255),
        ZIndex = 3,
        Transparency = 1,
        Text = "swimhub.xyz",
        Center = true,
        Outline = true,
    })
    local indicatortext = cheat.utility.new_drawing("Text", {
        Visible = false,
        Font = cursor.Font,
        Size = 13,
        Color = Color3.new(1, 1, 1),
        ZIndex = 3,
        Transparency = 1,
        Text = "",
        Center = true,
        Outline = true,
    })
    --
    for i = 1, 4 do
        local line_outline = cheat.utility.new_drawing("Line", {
            Visible = true,
            From = _Vector2new(200, 500),
            To = _Vector2new(200, 500),
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = cursor.Thickness + 2.5,
            ZIndex = 1,
            Transparency = 1
        })
        local line = cheat.utility.new_drawing("Line", {
            Visible = true,
            From = _Vector2new(200, 500),
            To = _Vector2new(200, 500),
            Color = cursor.Color,
            Thickness = cursor.Thickness,
            ZIndex = 2,
            Transparency = 1
        })
        local naziline = cheat.utility.new_drawing("Line", {
            Visible = true,
            From = _Vector2new(200, 500),
            To = _Vector2new(200, 500),
            Color = cursor.Color,
            Thickness = cursor.Thickness,
            ZIndex = 2,
            Transparency = 1
        })
        lines[i] = { line, line_outline, naziline }
    end
    local angle = 0
    local transp = 0
    local reverse = false
    local function setreverse(value)
        if reverse ~= value then
            reverse = value
        end
    end
    --
    local pos, rainbow, rotationdegree, color = Vector2.zero, 0, 0, Color3.new()
    local math_cos, math_atan, math_pi, math_sin = math.cos, math.atan, math.pi, math.sin
    local function DEG2RAD(x) return x * math_pi / 180 end
    local function RAD2DEG(x) return x * 180 / math_pi end
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
        if cursor.Enabled then
            rainbow = rainbow + (delta * 0.5)
            if rainbow > 1.0 then rainbow = 0.0 end
            color = Color3.fromHSV(rainbow, 1, 1)
            if cursor.CustomPos then pos = cursor.Position else pos = _Vector2new(
                Mouse.X,
                Mouse.Y + GuiInset.Y) end
            if cursor.rainbow then color = Color3.fromHSV(rainbow, 1, 1) else color = cursor.Color end
            if transp <= 1.5 + cursor.Text.LogoFadingOffset and not reverse then
                transp = transp + ((cursor.Speed * 10) * delta)
                if transp >= 1.5 + cursor.Text.LogoFadingOffset then setreverse(true) end
            elseif reverse then
                transp = transp - ((cursor.Speed * 10) * delta)
                if transp <= 0 - cursor.Text.LogoFadingOffset then setreverse(false) end
            end
            logotext.Position = _Vector2new(pos.X, (pos + _Vector2new(0, cursor.Radius + 5)).Y)
            logotext.Transparency = transp
            logotext.Visible = cursor.Text.Logo
            logotext.Color = cursor.Text.LogoColor
            logotext.Font = cursor.Font
            --
            indicatortext.Position = _Vector2new(pos.X, (pos + _Vector2new(0, cursor.Radius + (cursor.Text.Logo and 19 or 5))).Y)
            indicatortext.Visible = silent_aim.indicator
            indicatortext.Color = cursor.Text.NameColor
            indicatortext.Font = cursor.Font
            indicatortext.Text = silent_aim.indicator_text

            if cursor.sussy then
                local frametime = delta
                local a = cursor.Radius - 10
                local gamma = math_atan(a / a)

                if rotationdegree >= 90 then rotationdegree = 0 end

                for i = 1, 4 do
                    local p_0 = (a * math_sin(DEG2RAD(rotationdegree + (i * 90))))
                    local p_1 = (a * math_cos(DEG2RAD(rotationdegree + (i * 90))))
                    local p_2 = ((a / math_cos(gamma)) * math_sin(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))
                    local p_3 = ((a / math_cos(gamma)) * math_cos(DEG2RAD(rotationdegree + (i * 90) + RAD2DEG(gamma))))


                    lines[i][1].From = _Vector2new(pos.X, pos.Y)
                    lines[i][1].To = _Vector2new(pos.X + p_0, pos.Y - p_1)
                    lines[i][1].Color = color
                    lines[i][1].Thickness = cursor.Thickness
                    lines[i][1].Visible = true
                    lines[i][3].From = _Vector2new(pos.X + p_0, pos.Y - p_1)
                    lines[i][3].To = _Vector2new(pos.X + p_2, pos.Y - p_3)
                    lines[i][3].Color = color
                    lines[i][3].Thickness = cursor.Thickness
                    lines[i][3].Visible = true
                end
                rotationdegree = rotationdegree + ((cursor.Speed * frametime) * 1000)
            else
                angle = angle + ((cursor.Speed * 10) * delta)

                if angle >= 90 then
                    angle = 0
                end
                --
                dot.Visible = cursor.Dot
                dot.Color = color
                dot.Position = _Vector2new(pos.X - 1, pos.Y - 1)
                --
                outline.Visible = cursor.Outline and cursor.Dot
                outline.Position = _Vector2new(pos.X - 2, pos.Y - 2)
                --

                --
                for index, line in pairs(lines) do
                    index = index
                    local x, y = {}, {}
                    local x1, y1 = {}, {}
                    if cursor.Resize then
                        x = { pos.X +
                        (math_cos(angle + (index * (math.pi / 2))) * (cursor.Radius + ((cursor.Radius * math_sin(angle)) / 9))),
                            pos.X +
                            (math_cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and (((cursor.Radius - 20) * math_cos(angle)) / 4) or (((cursor.Radius - 20) * math_cos(angle)) - 4)))) }
                        y = { pos.Y +
                        (math_sin(angle + (index * (math.pi / 2))) * (cursor.Radius + ((cursor.Radius * math_sin(angle)) / 9))),
                            pos.Y +
                            (math_sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and (((cursor.Radius - 20) * math_cos(angle)) / 4) or (((cursor.Radius - 20) * math_cos(angle)) - 4)))) }
                        x1 = { pos.X + (math_cos(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .X +
                        (math_cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                        y1 = { pos.Y + (math_sin(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .Y +
                        (math_sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                    else
                        x = { pos.X + (math_cos(angle + (index * (math.pi / 2))) * (cursor.Radius)), pos.X +
                        (math_cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and ((cursor.Radius - 20) / cursor.Gap) or ((cursor.Radius - 20) - cursor.Gap)))) }
                        y = { pos.Y + (math_sin(angle + (index * (math.pi / 2))) * (cursor.Radius)), pos.Y +
                        (math_sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20) - (cursor.TheGap and ((cursor.Radius - 20) / cursor.Gap) or ((cursor.Radius - 20) - cursor.Gap)))) }
                        x1 = { pos.X + (math_cos(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .X +
                        (math_cos(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                        y1 = { pos.Y + (math_sin(angle + (index * (math.pi / 2))) * (cursor.Radius + 1)), pos
                        .Y +
                        (math_sin(angle + (index * (math.pi / 2))) * ((cursor.Radius - 20 + 1) - (cursor.TheGap and ((cursor.Radius - 20 + 1) / cursor.Gap) or ((cursor.Radius - 20 + 1) - cursor.Gap)))) }
                    end
                    --
                    line[1].Visible = true
                    line[1].Color = color
                    line[1].From = _Vector2new(x[2], y[2])
                    line[1].To = _Vector2new(x[1], y[1])
                    line[1].Thickness = cursor.Thickness
                    --
                    line[2].Visible = cursor.Outline
                    line[2].From = _Vector2new(x1[2], y1[2])
                    line[2].To = _Vector2new(x1[1], y1[1])
                    line[2].Thickness = cursor.Thickness + 2.5

                    line[3].Visible = false
                end
            end
        else
            dot.Visible = false
            outline.Visible = false
            logotext.Visible = false
            indicatortext.Visible = false
            --
            for index, line in pairs(lines) do
                line[1].Visible = false
                line[2].Visible = false
                line[3].Visible = false
            end
        end
    end))
end

do
    local WorldTab = ui.box.world:AddTab("world")
    local gradientenabled = false
    local gradientcolor1 = Color3.fromRGB(90, 90, 90)
    local gradientcolor2 = Color3.fromRGB(150, 150, 150)
    local oldgradient1 = Lighting.Ambient
    local oldgradient2 = Lighting.OutdoorAmbient
    local oldTime = mathround(Lighting.ClockTime)
    local nofog = false
    local noshadows = false
    local Time = 14
    local EnableTime = false
    local visuals_BloomInstance = Lighting:FindFirstChildOfClass("BloomEffect")
    local visuals_BloomIntensity = 0
    local visuals_BloomSize = 17
    local visuals_BloomThreshold = 0.9
    local visuals_BloomEnabled = false
    WorldTab:AddToggle('enabletimechanger', {Text = 'enable time changer',Default = false,Callback = function(first)
        EnableTime = first
    end})
    WorldTab:AddSlider('timechanger',{ Text = 'time changer', Default = oldTime, Min = 0, Max = 24, Rounding = 1, Compact = false }):OnChanged(function(State)
        Time = State
    end)
    WorldTab:AddToggle('ambientswitch', {Text = 'enable ambient',Default = false,Callback = function(first)
        gradientenabled = first
    end}):AddColorPicker('ambientcolor', {Default = Color3.new(1, 1, 1),Title = 'ambient color1',Transparency = 0,Callback = function(Value)
        gradientcolor1 = Value
    end}):AddColorPicker('ambientcolor1',{Default = Color3.new(1, 1, 1),Title = 'ambient color2',Transparency = 0,Callback = function(Value)
        gradientcolor2 = Value
    end})
    WorldTab:AddToggle('fogswitch', {
        Text = 'no fog',
        Default = false,
        Callback = function(first)
            nofog = first   
        end
    })
    WorldTab:AddToggle('grassswitch', {
        Text = 'no grass',
        Default = false,
        Callback = function(first)
            sethiddenproperty(_FindFirstChildOfClass(workspace, "Terrain"), "Decoration", not first)
        end
    })
    WorldTab:AddToggle('shadowswitch', {
        Text = 'no shadows',
        Default = false,
        Callback = function(first)
            noshadows = first
        end
    })
    cheat.utility.new_heartbeat(function()
        Lighting.GlobalShadows = not noshadows
        if gradientenabled then
            Lighting.Ambient = gradientcolor1
            Lighting.OutdoorAmbient = gradientcolor2
        end
        if EnableTime then Lighting.ClockTime = Time end
    end)
end
do -- god... i love 1 year old code in v2
    local othervisuals = ui.box.world:AddTab("other")
    local zoom_enabled, zoom_size = false, 10
    local fov_enabled, fov_size = false, 70
    othervisuals:AddToggle('fov_enabled', {Text = 'fov enabled',Default = false,Callback = function(first)
        fov_enabled = first
        globals.fov_enabled = first
        Camera.FieldOfView = zoom_enabled and zoom_size or fov_enabled and fov_size
    end})
    othervisuals:AddToggle('zoom_enabled', {Text = 'zoom enabled',Default = false,Callback = function(first)
        zoom_enabled = first
        globals.zoom_enabled = first
        Camera.FieldOfView = zoom_enabled and zoom_size or fov_enabled and fov_size
    end}):AddKeyPicker('zoom_bind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'zoom bind',NoUI = false})
    othervisuals:AddSlider('zoom_size', { Text = 'zoom size', Default = 10, Min = 0, Max = 90, Rounding = 0, Compact = true, Callback = function(value)
        zoom_size = value
    end})
    othervisuals:AddSlider('fov_size', { Text = 'fov size', Default = 70, Min = 0, Max = 120, Rounding = 0, Compact = true, Callback = function(value)
        fov_size = value
    end})
    othervisuals:AddToggle('noscreenfx', { Text = 'no screen effects', Default = false });
    othervisuals:AddToggle('inventoryviewer', { Text = 'inventory viewer', Default = false });
    othervisuals:AddSlider('inventoryviewer_x', { Text = 'X', Default = 200, Min = 0, Max = 700, Rounding = 0, Compact = true });
    othervisuals:AddSlider('inventoryviewer_y', { Text = 'Y', Default = 200, Min = 0, Max = 700, Rounding = 0, Compact = true });
    othervisuals:AddSlider('inventoryviewer_d', { Text = 'delay', Default = 0.25, Min = 0, Max = 1, Rounding = 2, Compact = true });
    othervisuals:AddLabel("viewmodel offset");
    othervisuals:AddSlider('viewmodel_x', { Text = 'X', Default = 0, Min = -5, Max = 5, Rounding = 2, Compact = true });
    othervisuals:AddSlider('viewmodel_y', { Text = 'Y', Default = 0, Min = -5, Max = 5, Rounding = 2, Compact = true });
    othervisuals:AddSlider('viewmodel_z', { Text = 'Z', Default = 0, Min = -5, Max = 5, Rounding = 2, Compact = true });
    othervisuals:AddToggle("ac", { Text = "arm chams", Default = false }):AddColorPicker('acc', { Default = Color3.new(1, 1, 1), Title = 'arm chams color' });
    othervisuals:AddToggle("gm", { Text = "gun chams", Default = false }):AddColorPicker('gcc', { Default = Color3.new(1, 1, 1), Title = 'gun chams color' });
    othervisuals:AddDropdown("acm", { Text = "arm chams material", Default = "SmoothPlastic", Values = { "ForceField", "Neon", "SmoothPlastic", "Glass" } });
    othervisuals:AddDropdown("gcm", { Text = "gun chams material", Default = "SmoothPlastic", Values = { "ForceField", "Neon", "SmoothPlastic", "Glass" } });
    local inv_originalpos = Vector2.new(200, 200)
    local draw, inventory, objects = {}, { objs = {} }, {}
    
    function draw:new(type, props)
        local obj = Drawing.new(type) --cheat.utility.new_drawing(type, props)
        for i,v in pairs(props) do
            obj[i] = v
        end
        objects[#objects + 1] = obj
        return obj
    end

    function draw:removeall()
        for i, v in pairs(objects) do
            v:Remove()
            table.remove(objects, i)
        end
    end

    function draw:changevis(value)
        for i, v in pairs(objects) do
            v.Visible = value
        end
    end

    function inventory:add(_text, _size)
        local text = draw:new("Text", {
            Text = _text,
            Size = _size,
            Font = Drawing.Fonts.Monospace,
            Outline = true,
            Center = false,
            Position = inv_originalpos + Vector2.new(0, (_size + 1) * #inventory.objs),
            Transparency = 1,
            Visible = true,
            Color = Color3.new(1, 1, 1),
            ZIndex = 1,
        })
        inventory.objs[#inventory.objs + 1] = text
    end

    function inventory:refresh()
        for i, v in inventory.objs do
            if v then v:Remove() end
            inventory.objs[i] = nil
            v = nil
        end
    end

    function inventory:update(__name)
        local rplayers = game:GetService("ReplicatedStorage").Players
        local updateon
        for _, rplayer in next, rplayers:GetChildren() do
            if __name == rplayer.Name then
                updateon = rplayer
            end
        end
        if not updateon then return inventory:refresh() end
        inventory:add("" .. updateon.Name .. " Inventory", 13)
        inventory:add("[Hotbar]", 13)
        for _, item in next, updateon.Inventory:GetChildren() do
            inventory:add("    " .. item.Name, 13)
        end
        inventory:add("[Clothing]", 13)
        for _, item in next, updateon.Clothing:GetChildren() do
            inventory:add("    " .. item.Name, 13)
            if _FindFirstChild(item, "Inventory") and #item.Inventory:GetChildren() ~= 0 then
                for _, subitem in next, item.Inventory:GetChildren() do
                    if subitem.ItemProperties:GetAttribute("Amount") then
                        inventory:add("        " .. subitem.Name ..
                        " => x" .. subitem.ItemProperties:GetAttribute("Amount"), 13)
                    else
                        inventory:add("        " .. subitem.Name, 13)
                    end
                end
            end
        end
        inventory:add("[Equipment]", 13)
        for _, item in next, updateon.Equipment:GetChildren() do
            inventory:add("    " .. item.Name, 13)
        end
    end

    local viewmodel_x = cheat.Options["viewmodel_x"]
    local viewmodel_y = cheat.Options["viewmodel_y"]
    local viewmodel_z = cheat.Options["viewmodel_z"]
    local gcm = cheat.Options.gcm
    local gcc = cheat.Options.gcc
    local acm = cheat.Options.acm
    local acc = cheat.Options.acc

    local FrameTimer = tick()
    local function vmpos(vm)
        if not vm then return end
        repeat task.wait() until vm.Name == "ViewModel"
        local hrp = vm:FindFirstChild("HumanoidRootPart")
        local vec = Vector3.new(viewmodel_x.Value, viewmodel_y.Value, viewmodel_z.Value)
        local LUA_W = hrp and hrp:FindFirstChild("LeftUpperArm")
        local RUA_W = hrp and hrp:FindFirstChild("RightUpperArm")
        local IR_W = hrp and hrp:FindFirstChild("ItemRoot")
        if LUA_W and RUA_W and IR_W then
            LUA_W.C0 = LUA_W.C0 + vec
            RUA_W.C0 = RUA_W.C0 + vec
            IR_W.C0 = IR_W.C0 + vec
        end
    end
    local function vmchams() LPH_JIT_MAX(function()
        local vm = _FindFirstChildOfClass(Camera, "Model")
        if not vm then return end
        repeat task.wait() until vm.Name == "ViewModel"

        local guncolor = gcc.Value
        local gunmaterial = gcm.Value
        local armcolor = acc.Value
        local armmaterial = acm.Value

        local ItemView = _FindFirstChild(vm, "Item")
        if ItemView and Toggles.gm.Value then -- gun
            for _, v in pairs(ItemView:GetDescendants()) do
                if v.ClassName == "MeshPart" or v.ClassName == "Part" then
                    v.Material = (gunmaterial) -- gun mat
                    v.Color = (guncolor)    -- gun color
                end
                if _FindFirstChildOfClass(v, "SurfaceAppearance") then
                    _FindFirstChildOfClass(v, "SurfaceAppearance"):Destroy()
                end
            end
        end
        if Toggles.ac.Value then
            for _, vm_item in pairs(vm:GetChildren()) do
                if vm_item.ClassName == "MeshPart" then
                    if vm_item.Name:find("Hand") or vm_item.Name:find("Arm") then
                        vm_item.Material = (armmaterial) -- hands mat
                        vm_item.Color = (armcolor) -- hands color
                    end
                end
                if vm_item.ClassName == "Model" and (_FindFirstChild(vm_item, "LL") or _FindFirstChild(vm_item, "LH")) then
                    for _, shirt_item in pairs(vm_item:GetChildren()) do
                        if _FindFirstChildOfClass(shirt_item, "SurfaceAppearance") then _FindFirstChildOfClass(shirt_item, "SurfaceAppearance"):Destroy() end
                        shirt_item.Material = (armmaterial)
                        shirt_item.Color = (armcolor)
                    end
                end
            end
        end
    end)() end
    Camera.ChildAdded:Connect(vmpos)
    Camera.DescendantAdded:Connect(vmchams)
    cheat.utility.new_renderstepped(LPH_JIT_MAX(function()
        inv_originalpos = Vector2.new(cheat.Options.inventoryviewer_x.Value, cheat.Options.inventoryviewer_y.Value)
        if LocalPlayer.PlayerGui:FindFirstChild("MainGui") then LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Visible = not Toggles.noscreenfx.Value end
        if (tick() - FrameTimer) >= cheat.Options.inventoryviewer_d.Value then
            FrameTimer = tick();
            inventory:refresh()
            if Toggles.inventoryviewer.Value and silent_aim.target_part then
                local name = silent_aim.target_part.Parent.Name
                inventory:update(name)
            end
        end;
        if (zoom_enabled or fov_enabled) then
            Camera.FieldOfView = zoom_enabled and zoom_size or fov_enabled and fov_size
        end
    end))
end
do
    local mvb = ui.box.move:AddTab('character')
    local speed_enabled, speed = false, 55
    local jump_enabled, jump = false, 55
    local gravity_enabled, gravity, original_gravity = false, 55, workspace.Gravity
    mvb:AddToggle('speedhack_enabled', {Text = 'speedhack enabled',Default = false,Callback = function(first)
        speed_enabled = first
    end})
    mvb:AddSlider('speedhack_speed',{ Text = 'speed', Default = 18.2, Min = 10, Max = 22, Rounding = 1, Suffix = "sps", Compact = false }):OnChanged(function(State)
        speed = State
    end)
    mvb:AddToggle('jumphack_enabled', {Text = 'jumphack enabled',Default = false,Callback = function(first)
        jump_enabled = first
    end})
    mvb:AddSlider('jumphack_height',{ Text = 'height', Default = 5, Min = 1, Max = 10, Rounding = 1, Suffix = "", Compact = false }):OnChanged(function(State)
        jump = State
    end)
    mvb:AddToggle('gravity_enabled', {Text = 'gravity enabled',Default = false,Callback = function(first)
        gravity_enabled = first
    end})
    mvb:AddSlider('gravity_height',{ Text = 'gravity', Default = workspace.Gravity, Min = 10, Max = workspace.Gravity, Rounding = 1, Suffix = "", Compact = false }):OnChanged(function(State)
        gravity = State
    end)
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
        local character = LocalPlayer.Character
        local humanoid = character and _FindFirstChildOfClass(character, "Humanoid")
        if humanoid then
            if speed_enabled then humanoid.WalkSpeed = speed end
            if jump_enabled then humanoid.JumpHeight = jump end
            workspace.Gravity = gravity_enabled and gravity or original_gravity
        end
    end))
end
do
    local mvb = ui.box.move:AddTab('flyhack')
    local enabled, speed, yspeed = false, 10, 10
    mvb:AddToggle('flyhack_enabled', {Text = 'flyhack enabled',Default = false,Callback = function(first)
        enabled = first
    end}):AddKeyPicker('flyhack_bind', {Default = 'None',SyncToggleState = true,Mode = 'Toggle',Text = 'flyhack',NoUI = false})
    mvb:AddSlider('flyhack_speed',{ Text = 'speed', Default = 10, Min = 1, Max = 50, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        speed = State
    end)
    mvb:AddSlider('flyhack_y_speed',{ Text = 'y speed', Default = 10, Min = 1, Max = 50, Rounding = 0, Suffix = "sps", Compact = false }):OnChanged(function(State)
        yspeed = State
    end)
    cheat.utility.new_heartbeat(LPH_JIT_MAX(function(delta)
        local character = LocalPlayer.Character
        local hrp = character and _FindFirstChild(character, "HumanoidRootPart")
        if enabled and hrp then
            local cameralook = Camera.CFrame.LookVector
            cameralook = _Vector3new(cameralook.X, 0, cameralook.Z)
            local direction = Vector3.zero
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(- cameralook.Z, 0, cameralook.X) or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, - cameralook.X) or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.Space) and direction + Vector3.yAxis or direction;
            direction = _IsKeyDown(UserInputService, Enum.KeyCode.LeftControl) and direction - Vector3.yAxis or direction;
            if direction ~= Vector3.zero then
                direction = direction.Unit
            end
            hrp.CFrame = hrp.CFrame + _Vector3new(1, 0, 1) * (direction * delta * speed) + Vector3.yAxis * (direction * delta * yspeed)
            for _, part in character:GetDescendants() do
                if part:IsA("BasePart") then part.AssemblyLinearVelocity = Vector3.zero end
            end
        end
    end))
end
loadswimhubfile("chat_spam.lua")(cheat.Library, ui.box.misc:AddTab("chat spam"), function(word)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(word, "Global")
end, 100, 200)

do
    local game_TweenService = game:GetService("TweenService")
    --[[local concrete_Enum = Enum.Material.Concrete
    local __index; __index = hookmetamethod(game, "__index", newcclosure(function(self, k)
    	if checkcaller() then return __index(self, k) end
    	if k == "FloorMaterial" and (globals.nofall or true) then
    		return concrete_Enum
    	end
    	return __index(self, k)
    end))]]
    local __newindex; __newindex = hookmetamethod(game, "__newindex", newcclosure(LPH_NO_VIRTUALIZE(function(self, k, v)
        if checkcaller() then return __newindex(self, k, v) end
        --if k == "FloorMaterial" and (globals.nofall or true) then
        --    return __newindex(self, k, concrete_Enum)
        --end
        if self == Camera then
            if k == "FieldOfView" and (globals.fov_enabled or globals.zoom_enabled) then
                return
            end
        end
        return __newindex(self, k, v)
    end)))
    local __namecall; __namecall = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(self,...)
        if checkcaller() then return __namecall(self, ...) end
        local args = {...}
        local method = getnamecallmethod()
        if self == game_TweenService and method == "Create" and args[1] == Camera and rawget(args[3], "FieldOfView") and (globals.fov_enabled or globals.zoom_enabled) then
            args[3] = {}
            return __namecall(self, unpack(args))
        end
        if method == "GetAttribute" then
            local attribute = args[1]
            if silent_aim.nospread and attribute == "AccuracyDeviation" then
                return 0
            end
            if silent_aim.enabled then
                if attribute == "ProjectileDrop" then
                    return 0
                end
                if attribute == "Drag" then
                    return 0
                end
            end
        end
        if method == "InvokeServer" then
            if self.Name == "FireProjectile" and silent_aim.enabled and silent_aim.instant and silent_aim.target_part then
                args[3] = 0/0
                return __namecall(self, unpack(args))
            end
            if self.Name == "Reload" and silent_aim.instantreload then
                args[2] = 0/0;
                args[3] = nil;
                return __namecall(self, unpack(args))
            end;
        end
        if method == "FireServer" then
            if self.Name == "ProjectileInflict" then
                if debug.traceback() and debug.traceback():find("CharacterController") then
                    return coroutine.yield()
                end
                args[4] = 0/0
                return __namecall(self, unpack(args))
            end
        end
        if method == "Raycast" --[[and debug.getinfo(3).short_src == "ReplicatedStorage.Modules.FPS.Bullet"]] and silent_aim.enabled and silent_aim.instant and silent_aim.target_part then
            local hitpart = silent_aim.target_part
            if hitpart then
                args[2] = (hitpart.Position - args[1])
                if silent_aim.testwallbang then
                    return {
                        Instance = hitpart,
                        Position = hitpart.Position,
                        Normal = Vector3.new(1, 0, 0),
                        Material = hitpart.Material,
                        Distance = (hitpart.Position - args[1]).Magnitude
                    }
                end
            end
            return __namecall(self, unpack(args))
        end
        return __namecall(self, ...)
    end)))
end

ui.box.themeconfig:AddToggle('keybindshoww', {Text = 'show keybinds',Default = false,Callback = function(first)cheat.Library.KeybindFrame.Visible = first end})
cheat.ThemeManager:SetOptionsTEMP(cheat.Options, cheat.Toggles)
cheat.SaveManager:SetOptionsTEMP(cheat.Options, cheat.Toggles)
cheat.ThemeManager:SetLibrary(cheat.Library)
cheat.SaveManager:SetLibrary(cheat.Library)
cheat.SaveManager:IgnoreThemeSettings()
cheat.ThemeManager:SetFolder('swimhub')
cheat.SaveManager:SetFolder('swimhub')
cheat.SaveManager:BuildConfigSection(ui.tabs.config)
cheat.ThemeManager:ApplyToGroupbox(ui.box.themeconfig)

cheat.EspLibrary.load()

task.spawn(function()
    for _, v in getconnections(game.ReplicatedStorage.Remotes.NotificationMessage.OnClientEvent) do
        if not v.Function then return end
        for i=1,5 do task.spawn(function()v.Function("WELCOME TO SWIMHUB!!!!!", 5, i)end) task.wait(1) end
    end
end)
