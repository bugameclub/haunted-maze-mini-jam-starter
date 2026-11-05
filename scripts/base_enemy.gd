extends CharacterBody2D


## The speed to move at
@export var speed := 100

## The target node to move towards
@export var target: Node2D = null


@onready var navigation_agent := $NavigationAgent2D

## Called when this node enters the scene tree for the first time. 
## Sets our target to whatever is defined in target.
func _ready() -> void:
#	Sets the initial target position
	if target:
		navigation_agent.target_position = target.global_position
		

## Called every 1/60th of a second, when we need to step physics
func _physics_process(delta: float) -> void:
#	Moves towards target position if possible
	if !navigation_agent.is_target_reachable():
		return
	if !navigation_agent.is_target_reached():
#		Gives us a direction vector towards our goal
		var nav_direction := to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = nav_direction * speed
	
#	move_and_slide handles multiplication by delta, so we always move at the same speed.
#	It also handles collision for us.
	move_and_slide()
	

## Called whenever the timer for the navigation agent fires. 
## This updates our target position to the player's current position every few seconds.
func _on_reset_timer_timeout() -> void:
	if not target:
		return
	if navigation_agent.target_position != target.global_position:
		navigation_agent.target_position = target.global_position
