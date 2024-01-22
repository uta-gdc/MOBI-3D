extends MeshInstance3D

#KEEP IN MIND COLORS GENERATED WILL BE WAY BRIGHTER DUE TO IN-GAME LIGHTING

@export var hex_code : String

func _ready():
	randomize()
	if hex_code == "":
		hex_code = "#%02x%02x%02x" % [randi() % 256, randi() % 256, randi() % 256]
		set_hex_code(hex_code)
		print("Hexcode not given, generating random")
		
	if get_surface_override_material_count() > 0:
		var material = get_surface_override_material(0) as StandardMaterial3D
		if material:
			var random_color = Color(hex_code)
			material.albedo_color = random_color
		else:
			print("Surface Material [0] is not a StandardMaterial3D")
	else:
		print("No surface materials found")

func set_hex_code(value):
	if not value.begins_with("#"):
		value = "#" + value
