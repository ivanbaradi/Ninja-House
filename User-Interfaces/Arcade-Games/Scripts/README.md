# Scripts

## Arcade UI Communications

This client script includes methods that are accessed by other scripts that associate with any arcade machine.

## Open Arcade

This script is triggered after the player interacts with the ProximityPrompt, which instructs them to **Play** the arcade game. When successful, an arcade's ScreenUI is enabled and its main menu becomes visible to the player's side.

All arcade UIs **MUST** be hidden from the player before they can open up another arcade.

From the last line from <code>ProximityPrompt.Triggered</code> event, **ArcadeUI** is a <code>StringVal</code> instance that stores the name of the arcade's ScreenUI.