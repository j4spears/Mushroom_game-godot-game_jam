extends Node

const SPORE_SONG = preload("uid://i578jwwbpscb")

var music_player
var poof_sfx
var bounce_sfx
var music_started := false

var metranome_A
var metranome_B
var metranome_C

func _ready() -> void:
	
	#create metranome timers
	metranome_A = Timer.new()
	metranome_A.wait_time = 4.2
	metranome_A.autostart = true
	add_sibling.call_deferred(metranome_A)
	
	#create metranome timers
	metranome_B = Timer.new()
	metranome_B.wait_time = 1.05
	metranome_B.autostart = true
	add_sibling.call_deferred(metranome_B)
	
	#create music stream
	music_player = AudioStreamPlayer.new()
	music_player.stream = SPORE_SONG
	add_sibling.call_deferred(music_player)


func _process(_delta: float) -> void:
	
	#wait to start music so it's properly alligned
	if not music_started and metranome_A.time_left < 1.95:
		music_player.play()
		music_started = true


func time_until_hit(metranome): return metranome.time_left
