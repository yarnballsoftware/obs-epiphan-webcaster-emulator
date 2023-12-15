# OBS Epiphan Webcaster X2 Plugin

## **Description**:

This plugin allows you to toggle various picture-in-picture scenes to emulate the PiP functionality of the Epiphan Webcaster X2. Forked from https://github.com/voidlesity/obs-scene-toggler

## **Installation**:

1. Copy the provided script (provided above) and save it as `scene_toggler.lua` on your computer.
2. Open OBS Studio.
3. Navigate to `Tools` > `Scripts`.
4. Click on the `+` (Add) button and select the `webcaster_emulator.lua` script you saved in step 1.
5. The script should now appear in the list of scripts within OBS.

## **Configuration NEEDS UPDATING**:

1. Once the script is loaded in OBS, you should see a property named "Select Scene" in the script's properties pane.
2. Use the dropdown list to select the scene you wish to toggle to. (if you don't see your desired scene check the [**Troubleshooting**](#troubleshooting) tab)
3. Close the scripts window.

## **Usage NEEDS UPDATING**:

1. Navigate to `File` > `Settings` > `Hotkeys`.
2. Scroll down to find "Toggle Scene Hotkey".
3. Set your desired hotkey for the toggle functionality.
4. Click "OK" to save your hotkey setting.
5. Now, whenever you press the hotkey, it will toggle between the currently active scene and the predefined scene you selected in the configuration step.

## **Troubleshooting NEEDS UPDATING**:

- Ensure the `scene_toggler.lua` script is loaded in the Scripts section.
- If the scene doesn't switch, double-check that the scene name in the dropdown list is correct and exists in your OBS.
- If the scene isn't visible in the dropdown click the little refresh button at the bottom left of the window.
- Make sure the hotkey you set isn't already in use by another function in OBS.
