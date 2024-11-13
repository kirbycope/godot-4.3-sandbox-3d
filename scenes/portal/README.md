# Portal

## Getting Assets
In the Source Engine `.vtf` files are images (materials), `.mdl` files are models (meshes).

1. Install [Portal](https://store.steampowered.com/app/400/Portal/) using [Steam](https://store.steampowered.com/about/)
1. Install [VPKEdit](https://github.com/craftablescience/VPKEdit/releases)
1. Open VPKEdit and then select "File" -> "Open..."
1. Select or enter, `C:\Program Files (x86)\Steam\steamapps\common\Portal\portal\portal_pak_dir.vpk`
1. Right-click the root directory in the file tree and then select "Export All.."
    - Select an existing folder or create a new one to hold the extracted files

### Convert Images (.vtf to .png)
To Convert images use, https://www.coolutils.com/online/VTF-to-PNG

### Convert Models (.mdl to .glb)
1. Install [Blender](https://www.blender.org/download/)
1. Download [SourceIO.zip](https://github.com/REDxEYE/SourceIO/releases)
1. Open Blender and then select "Edit" -> "Preferences..."
1. Select the "Add-ons" tab
1. Open the drop-down at the top-right and then "Install from Disk..."
1. Select the downloaded "SourceIO.zip" file
1. Select "File" -> "New" -> "General"
1. Delete the existing collection and its content
1. Select "File" -> "Import" -> "Source Engine Assets" -> "GoldSrc/Source model (.mdl)"
1. Select a model from the extracted `../models` folder
    - You can see the model + texture in the "Texture Paint" tab
1. Select "File" -> "Export" -> "glTF 2.0 (.glb/.gltf)
1. Enter a name for the file and then select "Export glTF 2.0"
    - The file extenstion will be saved as .glb by default but you can change it to .glTF (model + bin + textures saved as seperate files)
