extends Node

const dialogue_template = [
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "This is a Test Text, please ignore",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null
	}
]

var dialogue = [
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Hello! I am Mayor Mini Man, mayor of tidal town!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Poseidon is attacking our lovely village with waves!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Drag buildings outside of the red zone to save them!",
		"has_skip" : false,
		"signal_listen" : "house_moved",
		"signal_emit" : "house_movable"
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Great! Now press the 'skip' button to make the wave appear!",
		"has_skip" : false,
		"signal_listen" : "wave_finished",
		"signal_emit" : "start_wave_pressable"
	},
]
