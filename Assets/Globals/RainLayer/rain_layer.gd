extends CanvasLayer

@onready var desat_rect: ColorRect = $DesatRect
@onready var rain_particles: CPUParticles2D = $RainParticles

var raining = false

func fade_in(amount : int = 800):
	raining = true
	rain_particles.visible = true
	rain_particles.amount = amount
	rain_particles.emitting = true
	await desaturate(1.0)

func fade_out():
	if raining:
		raining = false
		rain_particles.emitting = false
		await resaturate(1.0)
		rain_particles.visible = false

func desaturate(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(
		desat_rect.material,
		"shader_parameter/desaturation_amount",
		0.5,
		duration
	)
	await tween.finished

func resaturate(duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(
		desat_rect.material,
		"shader_parameter/desaturation_amount",
		0.0,
		duration
	)
	await tween.finished
