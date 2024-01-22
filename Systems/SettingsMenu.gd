extends Node

var master_volume
var sound_effects_volume
var music_volume
var voice_volume

var master_index
var sound_index
var music_index
var voice_index

@onready var master_slider = $AudioCategory/VolumeSliders/MasterVolume
@onready var sound_slider = $AudioCategory/VolumeSliders/SoundVolume
@onready var music_slider = $AudioCategory/VolumeSliders/MusicVolume 
@onready var voice_slider = $AudioCategory/VolumeSliders/VoiceVolume

func _ready() -> void:
	master_index = AudioServer.get_bus_index("Master")
	sound_index = AudioServer.get_bus_index("Sound FX")
	music_index = AudioServer.get_bus_index("Music")
	voice_index = AudioServer.get_bus_index("Voice")

func _on_master_volume_value_changed(value) -> void:
	master_volume = linear_to_db(value)
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
