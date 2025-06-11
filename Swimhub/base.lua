-- FABRICATED VALUES!!!
local type_custom = typeof
if not LPH_OBFUSCATED then
	LPH_JIT = function(...)
		return ...;
	end;
	LPH_JIT_MAX = function(...)
		return ...;
	end;
	LPH_NO_VIRTUALIZE = function(...)
		return ...;
	end;
	LPH_NO_UPVALUES = function(f)
		return (function(...)
			return f(...);
		end);
	end;
	LPH_ENCSTR = function(...)
		return ...;
	end;
	LPH_ENCNUM = function(...)
		return ...;
	end;
	LPH_ENCFUNC = function(func, key1, key2)
		if key1 ~= key2 then return print("LPH_ENCFUNC mismatch") end
		return func
	end
	LPH_CRASH = function()
		return print(debug.traceback());
	end;
    SWG_DiscordUser = "swim"
    SWG_DiscordID = 1337
    SWG_Private = true
    SWG_Dev = false
    SWG_Version = "dev"
    SWG_Title = 'roblox gay sex gui %s - %s'--'$$$  swimhub<font color="rgb(166, 0, 255)">.xyz</font> %s - %s  $$$'
    SWG_ShortName = 'dev'
    SWG_FullName = 'indev build'
    SWG_FFA = false
end;
--- FABRICATED VALUES END!!!

local workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiInset = cloneref(game:GetService("GuiService")):GetGuiInset()
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local function getfile(name)
    local repo = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/swimhub/main/"
    local success, content = pcall(request, {Url = repo..name, Method = "GET"})
    if success and content.StatusCode == 200 then
        return content.Body
    else
        return print("getfile returned error \""..content.."\"")
    end
end
local function isswimhubfile(file)
    return isfile("swimhub/new/files/"..file)
end
local function readswimhubfile(file)
    if not isswimhubfile(file) then return false end
    local success, returns = pcall(readfile, "swimhub/new/files/"..file)
    if success then return returns else return print(returns) end
end
local function loadswimhubfile(file)
    if not isswimhubfile(file) then return false end
    local success, returns = pcall(loadstring, readswimhubfile(file))
    if success then return returns else return print(returns) end
end
local function getswimhubasset(file)
    if isswimhubfile(file) then return false end
    local success, returns = pcall(getcustomasset, "swimhub/new/files/"..file)
    if success then return returns else return print(returns) end
end
do
    if not isfolder("swimhub") then makefolder("swimhub") end
    if not isfolder("swimhub/new") then makefolder("swimhub/new") end
    if not isfolder("swimhub/new/files") then makefolder("swimhub/new/files") end
    local function getfiles(force, list)
        for _, file in list do
            if (force or not force and not isswimhubfile(file)) then
                writefile("swimhub/new/files/"..file, getfile(file))
            end
        end
    end
    local gotassets = getfile("assets.json")
    local assets = HttpService:JSONDecode(gotassets)
    local localassets = readswimhubfile("assets.json")
    if localassets then
        localassets = HttpService:JSONDecode(localassets)
        if localassets.version ~= assets.version then
            writefile("swimhub/new/files/assets.json", gotassets)
            getfiles(true, assets.list)
        end
    else
        writefile("swimhub/new/files/assets.json", gotassets)
    end
    getfiles(false, assets.list)
end

-- swimhub main

local cheat = {
    Library = nil,
    Toggles = nil,
    Options = nil,
    ThemeManager = nil,
    SaveManager = nil,
    connections = {
        heartbeats = {},
        renderstepped = {}
    },
    drawings = {},
    hooks = {}
}
cheat.utility = {} do
    cheat.utility.new_heartbeat = function(func)
        local obj = {}
        cheat.connections.heartbeats[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.heartbeats[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_renderstepped = function(func)
        local obj = {}
        cheat.connections.renderstepped[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.renderstepped[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_drawing = function(drawobj, args)
        local obj = Drawing.new(drawobj)
        for i, v in pairs(args) do
            obj[i] = v
        end
        cheat.drawings[obj] = obj
        return obj
    end
    cheat.utility.new_hook = function(f, newf, usecclosure) LPH_NO_VIRTUALIZE(function()
        if usecclosure then
            local old; old = hookfunction(f, newcclosure(function(...)
                return newf(old, ...)
            end))
            cheat.hooks[f] = old
            return old
        else
            local old; old = hookfunction(f, function(...)
                return newf(old, ...)
            end)
            cheat.hooks[f] = old
            return old
        end
    end)() end
    local connection; connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.heartbeats) do
            func(delta)
        end
    end))
    local connection1; connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.renderstepped) do
            func(delta)
        end
    end))
    cheat.utility.unload = function()
        connection:Disconnect()
        connection1:Disconnect()
        for key, _ in pairs(cheat.connections.heartbeats) do
            cheat.connections.heartbeats[key] = nil
        end
        for key, _ in pairs(cheat.connections.renderstepped) do
            cheat.connections.heartbeats[key] = nil
        end
        for _, drawing in pairs(cheat.drawings) do
            drawing:Remove()
            cheat.drawings[_] = nil
        end
        for hooked, original in pairs(cheat.hooks) do
            if type(original) == "function" then
                hookfunction(hooked, clonefunction(original))
            else
                hookmetamethod(original["instance"], original["metamethod"], clonefunction(original["func"]))
            end
        end
    end
end
