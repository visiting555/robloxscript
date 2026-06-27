local menu_open = false
local features = {
    {name="Aimbot",enabled=false},
    {name="ESP",enabled=false},
    {name="SilentAim",enabled=false},
    {name="Fly",enabled=false},
    {name="NoClip",enabled=false}
}
local fly_active = false
local noclip_active = false

function anticheat_bypass()
    pcall(function()
        if hookfunction then
            hookfunction(function()end, function() return true end)
        end
        if setreadonly then
            for _,v in pairs(_G) do
                pcall(function() setreadonly(v,false) end)
            end
        end
        if getnilinstances then
            for _,v in ipairs(getnilinstances()) do
                pcall(function() v:Destroy() end)
            end
        end
    end)
end

function draw_menu()
    print("[MODERN MENU]")
    for i,v in ipairs(features) do
        print(i..". "..v.name.." ["..(v.enabled and "ON" or "OFF").."]")
    end
    print("M: Close Menu")
end

function toggle_menu()
    menu_open = not menu_open
    if menu_open then draw_menu() end
end

function enable_feature(idx)
    features[idx].enabled = not features[idx].enabled
    if features[idx].name == "Fly" then fly_active = features[idx].enabled end
    if features[idx].name == "NoClip" then noclip_active = features[idx].enabled end
    if menu_open then draw_menu() end
end

function aimbot_logic()
    -- Your universal aimbot logic here (must implement over game's API)
end

function esp_logic()
    -- Your universal esp logic here (must implement over game's API)
end

function silentaim_logic()
    -- Your universal silentaim logic here (must implement over game's API)
end

function fly_logic()
    -- Your universal fly logic here (must implement over game's API)
end

function noclip_logic()
    -- Your universal noclip logic here (must implement over game's API)
end

anticheat_bypass()

while true do
    if menu_open then
        local input = io.read()
        if input == "m" or input == "M" then
            toggle_menu()
        elseif tonumber(input) and features[tonumber(input)] then
            enable_feature(tonumber(input))
        end
    end
    if features[1].enabled then aimbot_logic() end
    if features[2].enabled then esp_logic() end
    if features[3].enabled then silentaim_logic() end
    if features[4].enabled then fly_logic() end
    if features[5].enabled then noclip_logic() end
    if not menu_open then
        local inp = ""
        if io.input() then
            inp = io.read()
        end
        if inp == "m" or inp == "M" then
            toggle_menu()
        end
    end
end
