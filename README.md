# godot-4.3-sandbox-3d
A 3D sandbox for v4.3 of the Godot game engine.

# Godot Best Practices
1. Directory names are `kebab-cased`, i.e. `"res://foo-bar/main.tscn"`.
1. Node names are `PascalCased`, i.e. `FooBar`.
1. File and Variable names are `snake_cased`, i.e. `foo_bar += 1`
1. Static type variable assignments using `:`.
	1. Inffered, i.e. `var foo := 1`, (less compile time, more runtime).
	1. Explicit, i.e. `var bar:int = 1`, (more compile time, less runtime).
1. Double-space before function declarations/comments.
1. Double-hash before function comments.
1. Single-space to seperate steps in a function.
1. Single-hash before code comments.
1. Arrange functions and variables alphabetically.
1. Use prefixes to group variables, i.e. `player_postion` and `player_health`.

## Godot Color Codes (from icon.svg)
https://rgbcolorcode.com/color/`{hex}`

**Charcoal** </br>
*#363d52* </br>
`rgb(54, 61, 82)` </br>
`vec3(0.21,0.24,0.32)` </br>

**White** </br>
*#fff* </br>
`rgb(255, 255, 255)` </br>
`vec3(1.00,1.00,1.00)` </br>

**Steel Blue** </br>
*#478cbf* </br>
`rgb(71, 140, 191)` </br>
`vec3(0.28,0.55,0.75)` </br>

**Paynes Gray** </br>
*#414042* </br>
`rgb(65, 64, 66)` </br>
`vec3(0.25,0.25,0.26)` </br>
