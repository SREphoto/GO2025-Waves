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
		"text" : "Poseidon is attacking our village with waves!",
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
		"pointer" : Vector2(1800, 470),
		"pointer_rotation" : 120.0
	},
	{
		"speaker" : "Mayor",
		"mood" : "cry",
		"direction" : "right",
		"text" : "It reminds me of when he destroyed my hometown as a child.",
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
		"pointer" : Vector2(450, 171),
		"pointer_rotation" : 25.0
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "Remember: Only the largest group per color counts!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : Vector2(450, 171),
		"pointer_rotation" : 25.0
	},
	{
		"speaker" : "Mayor",
		"mood" : "normal",
		"direction" : "right",
		"text" : "You have 2 waves left to reach the goal. Good luck! Keep us save!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : Vector2(1790, 300),
		"pointer_rotation" : 120.0
	},
]
#Vector2(1810, 96)
#Vector2(1810, 256)

var dialogue_multi = [
	{
		"speaker" : "Mayor",
		"mood" : "happy",
		"direction" : "right",
		"text" : "Conratulations, you saved us... for now. You earned a spin!",
		"has_skip" : false,
		"signal_listen" : "shopping_done",
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "happy",
		"direction" : "right",
		"text" : "Multi-houses multiply all regular houses in their effect area!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
	{
		"speaker" : "Mayor",
		"mood" : "happy",
		"direction" : "right",
		"text" : "These effects stack, so place multi-houses well!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	},
]

const dialogue_boss = [
	{
		"speaker" : "Mayor",
		"mood" : "angry",
		"direction" : "right",
		"text" : "He's tired now! Attack him!!!",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	}
]

const dialogue_hard_mode = [
	{
		"speaker" : "Mayor",
		"mood" : "angry",
		"direction" : "right",
		"text" : "Yes, that's right! I was the bad guy all along!",
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
		"text" : "Eat sand, boy...",
		"has_skip" : true,
		"signal_listen" : null,
		"signal_emit" : null,
		"pointer" : null,
		"pointer_rotation" : null
	}
]

const dialogue_win = [
	{
		"speaker" : "Mayor",
		"mood" : "happy",
		"direction" : "right",
		"text" : "YOU DID IT!",
		"has_skip" : true,
	},
	{
		"speaker" : "Mayor",
		"mood" : "happy",
		"direction" : "right",
		"text" : "You defeated Poseidon and saved this town!",
		"has_skip" : true,
	},
	{
		"speaker" : "Mayor",
		"mood" : "angry",
		"direction" : "right",
		"text" : "After 50 long years, I finally got my revenge!",
		"has_skip" : true,
	},
	{
		"speaker" : "Mayor",
		"mood" : "happy",
		"direction" : "right",
		"text" : "You will be our hero forever!",
		"has_skip" : true,
	},
	{
		"speaker" : "Mayor",
		"mood" : "happy",
		"direction" : "right",
		"text" : "And finally: Thanks for playing!",
		"has_skip" : true,
	},
]
