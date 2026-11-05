extends CharacterBody2D
class_name Player



## The player's speed, in pixels/sec
@export var speed := 500
## The player's starting health
@export var starting_health := 5
## The amount of coins to collect before we win
@export var coins_to_win := 4

## Settings regarding the ambient light around the player
@export_group("Ambient Light", "ambient_light_")
## The amplitute of the ambient light flicker.
@export var ambient_light_amplitute := 0.1
## The frequency of the ambient light flicker, aka. how many seconds it takes to go back and forth
@export var ambient_light_frequency := 2.0
## The starting range of the ambient light
@export var ambient_light_offset := 1.0

## The angle the player is "facing." This is grabbed from the current mouse position
## and is used to aim the flashlight. This is measured in [b]radians[/b], not degrees.
var look_angle := 0.0

## The amount of time in seconds that has passed since this player entered the scene tree
var _elapsed_time := 0.0

# onready variables are only set when _ready() is called 
# (i.e. when this node has entered the scene tree)
# $... represents a path to a child node, so these grab references 
# to the AmbientLight, Flashlight, and Sprite nodes
@onready var ambient_light := $AmbientLight
@onready var flashlight := $Flashlight
@onready var sprite := $Sprite2D

## Called every 1/60th of a second, when we need to step physics
func _physics_process(delta: float) -> void:
	
	# mouse position in viewport coordinates
	var mouse_position = get_viewport().get_mouse_position()
	# player's position in viewport coordinates
	var viewport_position = get_global_transform_with_canvas().origin
#	The angle of the mouse relative to the player
	var angle = (mouse_position - viewport_position).angle()
	look_angle = angle
	
#	Rotates the flashlight so its facing the mouse.
	flashlight.rotation = look_angle
	
#	Calculates our player's movement direction based on inputs
	var movement := Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		movement.x -= 1
	if Input.is_action_pressed("right"):
		movement.x += 1
	if Input.is_action_pressed("up"):
		movement.y -= 1
	if Input.is_action_pressed("down"):
		movement.y += 1
	
#	The reason we normalize this is because if we hold up + left, 
#	we'd actually be moving faster (the vector's length would be 1.414...)
#	We reset this to 1 so the player is always moving at the same speed regardless
#	of what direciton we're moving in.
	movement = movement.normalized() * speed
	velocity = movement
	
#	move_and_slide handles multiplication by delta, so we always move at the same speed.
#	It also handles collision for us.
	move_and_slide()

## Called every single frame.
func _process(delta: float) -> void:
#	Update our elapsed time.
	_elapsed_time += delta
	
#	Scales the ambient light texture based on this formula, which adds a very subtle
#	pulsing effect with the light around the player.
	ambient_light.texture_scale = sqrt(
		ambient_light_offset + (
			ambient_light_amplitute * sin(
				(2 * PI / ambient_light_frequency) * _elapsed_time
			)
		)
	)
