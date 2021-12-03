local screen = IEngine.GetScreenSize()
Menu.Checkbox("---- OneShot.lua for Baimless ----", true, "Oneshot.lua")
Menu.Toggle("Enable", false)
    
Client.RegisterCallback("Paint", function()
    local DT = Config.Get(Vars.keyRageDoubleTap)
    local HS = Config.Get(Vars.keyRageHideShots)
    local DUCK = Config.Get(Vars.keyRageFakeDuck)
    local DMG = Config.Get(Vars.keyRageMinimalDamageOverride)
    local curY = screen.y / 2 + 160
    local RenderIndicator = function(text, col)
        font = Draw.AddFont("C:\\Windows\\Fonts\\verdana.ttf", 24.0);
        txtw = Draw.GetTextSize(font, 32.0, text)
        curY = curY + 40
        Draw.AddText(font, 28.0, Vector2D.new(17, curY + 3), text, Color.new(33, 33, 33, 180));
        Draw.AddText(font, 28.0, Vector2D.new(16, curY + 2), text, col);
        RenderIndicator("Oneshot.lua [Baimless]", Color.new(255, 255, 255, 255));
    end

    local enable = Menu.Get("Enable")
    if enable == true then
        if DT == true then
            RenderIndicator("Oneshot - DT", Color.new(255, 238, 0, 255))
        end

        if HS == true then
            RenderIndicator("Oneshot - HS", Color.new(0, 255, 195, 255))
        end

        if DMG == true then
            RenderIndicator("Oneshot - DMG", Color.new(164, 164, 164, 255))
        end

        if DUCK == true then
            RenderIndicator("Oneshot - FD", Color.new(255, 255, 255, 255));
        end
    end
end)

local ffi = require("ffi")
local SetClantag = ffi.cast("int(__fastcall*)(const char*, const char*)", Client.FindPattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))
local LastClantag = nil
local SetClantag = function(v)
  if v == LastClantag then return end
  SetClantag(v, v)
  LastClantag = v
end

local BuildTag = function(tag)
  local Ret = {" "}

  for i = 1, #tag do
    table.insert(Ret, tag:sub(1, i))
  end

  for i = #Ret - 1, 1, -1 do
    table.insert(Ret, Ret[i])
  end

  return Ret
end

local Tag = BuildTag("oneshot.lua bl");

local function ClantagAnimation()
    if not IEngine.IsConnected() then return end

    local NetchannInfo = IEngine.GetNetChannelInfo()
    if NetchannInfo == nil then return end

    local Latency = NetchannInfo:GetLatency(0) / IGlobals.flIntervalPerTick
    local TickcountPred = IGlobals.iTickCount + Latency
    local Iter = math.floor(math.fmod(TickcountPred / 16, #Tag + 1) + 1)


    SetClantag(Tag[Iter])
end

Client.RegisterCallback("Destroy", function()
  SetClantag("oneshot.lua bl", "")
end)

Client.RegisterCallback("Paint", ClantagAnimation)

Menu.Toggle("Anti Defensive", false)
local lc0 = IConVar.FindVar("cl_lagcompensation")

lc0:SetInt(0)