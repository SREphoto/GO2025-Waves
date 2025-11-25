extends Node

const dialogue_template = [
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "This is a Test Text, please ignore",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	}
]

var dialogue_tut = [
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Hello! I am Mayor Mini Man, mayor of tidal town!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "angry",
		"direction" : "right",
		"text" : "Poseidon is attacking our lovely village with waves!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Drag buildings outside of the red zone to save them!",
		"has_skip" : false,
		"signal_listen" : "house_moved",
		"signal_emit" : "house_movable",
		"pointer" : Vector2(1320, 600),
		"pointer_rotation" : 0.0
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Great! Now press the 'skip' button to make the wave appear!",
		"has_skip" : false,
		"signal_listen" : "wave_sent",
		"signal_emit" : "start_wave_pressable",
		"pointer" : Vector2(481, 939),
		"pointer_rotation" : -30
	},
	{
		"speaker" : "Mayor",
		"mood" : "cry",
		"direction" : "right",
		"text" : "This reminds me of the time he destroyed my hometown when I was just a child...",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "After every wave, our village gets bigger and stronger!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "angry",
		"direction" : "right",
		"text" : "You MUST make a high enough offering to survive!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : Vector2(530, 200),
		"pointer_rotation" : 0.0
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "You have 2 waves left to reach the goal. Good luck! Keep us save!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : Vector2(440, 800),
		"pointer_rotation" : 0.0
	},
]

var dialogue_multi = [
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Congrats, you did it! I will reward you with a multiplicator house!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
]
