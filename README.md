# godot-4.3-sandbox-3d
A 3D sandbox for version 4.3 of the Godot Engine.

# Godot Best Practices
1. File names are `kebab-cased`, i.e. `"res://foo-bar.tscn"`.
1. Node names are `PascalCased`, i.e. `FooBar`.
1. Variable names are `snake_cased`, i.e. `foo_bar += 1`
1. Static type variable assignments using `:`.
	1. Inffered, i.e. `var foo := 1`, (less compile time, more runtime).
	1. Explicit, i.e. `var bar:int = 1`, (more compile time, less runtime).
1. Double-space before function declarations/comments.
1. Double-hash before function comments.
1. Single-space to seperate steps in a function.
1. Single-hash before code comments.
1. Arrange functions and variables alphabetically.
1. Use prefixes to group variables, i.e. `player_postion` and `player_health`.
