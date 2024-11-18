# Super Mario Odyssey

## Getting Assets
Download asset from [models-resource](https://www.models-resource.com/nintendo_switch/supermarioodyssey/)

## Example
1. Download the [Bonneton](https://www.models-resource.com/download/37435/) location
1. Unarchive the downloaded .zip file
1. Import the .FBX into your assets folder
    - An FBX importer was added to Godot in 4.3
1. Create a new Scene (StaticBody3D)
1. Drag-and-drop the FBX file into the scene
1. Rotate the node to 90 degrees in the x-direction
    - These assets import sideways for some reason
1. Right-click the imported node and select "Make Local"
1. Select all MeshInstance3Ds and select the "Mesh" -> "Create Collision Shape..."
    - The button is near the top-center of the screen
1. Select "Create"
1. Move the CollisionShape3D(s) to under the parent node
1. Rotate the CollisionShape3D(s) to 0 degrees in the x-direction
