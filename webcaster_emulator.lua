local obs = obslua

local scene_two = ""
local scene_one = ""
local pip_source_one = ""
local pip_source_two = ""
local debug = false
local hk = {}
local hotkeys = {
	TOGGLE_scene = "Webcaster: Toggle Scene",
	TOGGLE_pip = "Webcaster: Toggle Picture in Picture",
}

local function switch_scene(scene_name)
    local source = obs.obs_get_source_by_name(scene_name)
    if source ~= nil then
        obs.obs_frontend_set_current_scene(source)
        obs.obs_source_release(source)
    end
end

local function toggle_scene()
    local current_scene = obs.obs_frontend_get_current_scene()
    if current_scene ~= nil then
        local scene_name = obs.obs_source_get_name(current_scene)
        obs.obs_source_release(current_scene)
        if scene_name ~= scene_one then
            switch_scene(scene_one)
        else
            switch_scene(scene_two)
        end
    end
end

local function toggle_pip_old()
    local current_source = obs.obs_frontend_get_current_scene()
    if current_source ~= nil then
        local scene_name = obs.obs_source_get_name(current_source)
        if scene_name == scene_one then
            local scene = obs.obs_scene_from_source(current_source)
            local scene_item = obs.obs_scene_find_source(scene, pip_source_one)
            if scene_item then
                local is_visible = obs.obs_sceneitem_visible(scene_item)
                if is_visible then
                    obs.obs_sceneitem_set_visible(scene_item, false)
                else 
                    obs.obs_sceneitem_set_visible(scene_item, true)
                end
            else
                print("Source '" .. pip_source_one .. "' not found in current scene.")
            end
        else
            -- switch_scene(scene_two)
        end
    end
    obs.obs_source_release(current_source)
end

local function toggle_pip()
    local scenes = obs.obs_frontend_get_scenes()
    if scenes ~= nil then
        for _, scene_source in ipairs(scenes) do
            local scene_name = obs.obs_source_get_name(scene_source)
            local scene = obs.obs_scene_from_source(scene_source)
            if scene_name == scene_one then
                local scene_item = obs.obs_scene_find_source(scene, pip_source_one)
                if scene_item then
                    local is_visible = obs.obs_sceneitem_visible(scene_item)
                    if is_visible then
                        obs.obs_sceneitem_set_visible(scene_item, false)
                    else 
                        obs.obs_sceneitem_set_visible(scene_item, true)
                    end
                else
                    print("Source '" .. pip_source_one .. "' not found in current scene.")
                end
            elseif scene_name == scene_two then
                local scene_item = obs.obs_scene_find_source(scene, pip_source_two)
                if scene_item then
                    local is_visible = obs.obs_sceneitem_visible(scene_item)
                    if is_visible then
                        obs.obs_sceneitem_set_visible(scene_item, false)
                    else 
                        obs.obs_sceneitem_set_visible(scene_item, true)
                    end
                else
                    print("Source '" .. pip_source_two .. "' not found in current scene.")
                end
            else
                print("Scene '" .. scene_name .. "' skipped.")
            end
        end
    end
    obs.source_list_release(scenes)
end

local function onHotKey(action)
	if debug then obs.script_log(obs.LOG_INFO, string.format("Hotkey : %s", action)) end
	if action == "TOGGLE_scene" then
		toggle_scene()
	elseif action == "TOGGLE_pip" then
		obs.script_log(obs.LOG_INFO, string.format("Hotkey : %s", action))
        toggle_pip()
	end
end

function script_description()
    return "Emulate the keyboard functionality of the Epiphan Webcaster X2 for picture-in-picture between two scenes/sources"
end

function script_properties()
    local props = obs.obs_properties_create()

    -- Dropdown for scene selection
    local p1 = obs.obs_properties_add_list(props, "scene_list", "Select Scene 1", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    local p2 = obs.obs_properties_add_list(props, "scene_list2", "Select Scene 2", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    local scenes = obs.obs_frontend_get_scenes()
    if scenes then
        for _, scene in ipairs(scenes) do
            local scene_name = obs.obs_source_get_name(scene)
            obs.obs_property_list_add_string(p1, scene_name, scene_name)
            obs.obs_property_list_add_string(p2, scene_name, scene_name)
            obs.obs_source_release(scene)
        end
    end

    local p3 = obs.obs_properties_add_list(props, "pip_list1", "Select PiP Source 1", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    local p4 = obs.obs_properties_add_list(props, "pip_list2", "Select PiP Source 2", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)
    local sources1 = obs.obs_enum_sources()
    if sources1 then
        for _, source1 in ipairs(sources1) do
            local source_name = obs.obs_source_get_name(source1)
            obs.obs_property_list_add_string(p3, source_name, source_name)
            obs.obs_property_list_add_string(p4, source_name, source_name)
            obs.obs_source_release(source1)
        end
    end
    -- obs.obs_enum_source_release(sources1)

    return props
end

function script_update(settings)
    scene_one = obs.obs_data_get_string(settings, "scene_list")
    scene_two = obs.obs_data_get_string(settings, "scene_list2")
    pip_source_one = obs.obs_data_get_string(settings, "pip_list1")
    pip_source_two = obs.obs_data_get_string(settings, "pip_list2")
end


function script_save(settings)
	for k, v in pairs(hotkeys) do
		local hotkeyArray = obs.obs_hotkey_save(hk[k])
		obs.obs_data_set_array(settings, k, hotkeyArray)
		obs.obs_data_array_release(hotkeyArray)
	end
end


function script_load(settings)
	for k, v in pairs(hotkeys) do
		hk[k] = obs.obs_hotkey_register_frontend(k, v, function(pressed) if pressed then onHotKey(k) end end)
		local hotkeyArray = obs.obs_data_get_array(settings, k)
		obs.obs_hotkey_load(hk[k], hotkeyArray)
		obs.obs_data_array_release(hotkeyArray)
	end
end

-- Keep this around for a setting JSON reference
-- function script_save(settings)
--     local hotkey_save_data = obs.obs_hotkey_save(hotkey_scene_toggle)
--     if hotkey_save_data then
--         local wrapper = obs.obs_data_create()
--         obs.obs_data_set_array(wrapper, "hotkey_data", hotkey_save_data)
--         local json_str = obs.obs_data_get_json(wrapper)
--         obs.obs_data_set_string(settings, "toggle_scene_hotkey_data", json_str)
--         obs.obs_data_release(wrapper)
--         obs.obs_data_array_release(hotkey_save_data)
--     end
-- end
-- function script_load(settings)
--     hotkey_scene_toggle = obs.obs_hotkey_register_frontend(script_path(), "Toggle Scene Hotkey", toggle_scene)
--     local json_str = "{\"hotkey_data\":[{\"key\":\"OBS_KEY_TAB\"}]}"
--     if json_str and json_str ~= "" then
--         local wrapper = obs.obs_data_create_from_json(json_str)
--         local hotkey_save_data = obs.obs_data_get_array(wrapper, "hotkey_data")
--         print("debug json_str: " .. json_str)
--         obs.obs_hotkey_load(hotkey_scene_toggle, hotkey_save_data)
--         obs.obs_data_array_release(hotkey_save_data)
--         obs.obs_data_release(wrapper)
--     end
-- end