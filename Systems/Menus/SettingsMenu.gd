extends Node

var master_volume : float
var sound_effects_volume : float
var music_volume : float
var voice_volume : float

var master_index : int
var sound_index : int
var music_index : int
var voice_index : int

@onready var master_slider : Slider = $AudioCategory/VolumeSliders/MasterVolume
@onready var sound_slider : Slider = $AudioCategory/VolumeSliders/SoundVolume
@onready var music_slider : Slider = $AudioCategory/VolumeSliders/MusicVolume 
@onready var voice_slider : Slider = $AudioCategory/VolumeSliders/VoiceVolume

func _ready() -> void:
	master_index = AudioServer.get_bus_index("Master")
	sound_index = AudioServer.get_bus_index("Sound FX")
	music_index = AudioServer.get_bus_index("Music")
	voice_index = AudioServer.get_bus_index("Voice")

func _on_master_volume_value_changed(value) -> void:
	master_volume = linear_to_db(value)
	print(str(master_volume))
	AudioServer.set_bus_volume_db(master_index , master_volume)

func _on_sound_volume_value_changed(value) -> void:
	sound_effects_volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(sound_index , sound_effects_volume)

func _on_music_volume_value_changed(value) -> void:
	music_volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_index, music_volume)

func _on_voice_volume_value_changed(value) -> void:
	voice_volume = linear_to_db(value)
	AudioServer.set_bus_volume_db(voice_index , voice_volume)

func _on_test_sound_pressed() -> void:
	$AudioCategory/TestingSound.play()

func _on_test_voice_pressed() -> void:
	$AudioCategory/TestingVocal.play()
	
func _on_audio_pressed() -> void:
	$AudioCategory.visible = true
	$DisplayCategory.visible = false
	$KeybindingCategory.visible = false

func _on_display_pressed() -> void:
	$AudioCategory.visible = false
	$DisplayCategory.visible = true
	$KeybindingCategory.visible = false

func _on_keybinding_pressed() -> void:
	$AudioCategory.visible = false
	$DisplayCategory.visible = false
	$KeybindingCategory.visible = true
