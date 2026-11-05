# @tool marks our script as a "tool" script, which means it also runs while the
# editor is open. We do this so we can update the door sprite 
# while our game isn't running.
@tool
extends StaticBody2D

## Represents if this End door is the top or bottom. For sprite purposes mostly
enum DoorMode {
	Top,
	Bottom
}

# onready variables are only set when _ready() is called 
# (i.e. when this node has entered the scene tree)
# $... represents a path to a child node
@onready var bottom_sprite := $BottomSprite
@onready var top_sprite := $TopSprite
@onready var collider := $CollisionShape2D

# Called when this node enters the scene tree, i.e. it's "constructor"
# Note: this is actually called *after* the real constructor (_init)
func _ready():
	_recalculate_sprite.call_deferred()

## Determines if this End Door is for the Top fence gate or bottom.
@export var mode := DoorMode.Top:
	set(value):
		mode = value
		_recalculate_sprite()

## Whether or not this End Door is open. 
## If it is, the player can freely pass through it.
@export var open := false:
	set(value):
		open = value
		_recalculate_sprite()
		_recalculate_shape()


## Checks if the door is open, and if it is, disables collision.
func _recalculate_shape() -> void:
	if not collider:
		return
	collider.set_deferred("disabled", open)
	
## Checks the current state of this door and chooses which sprite to use.
## Essentially just a bunch of if statement checks
func _recalculate_sprite() -> void:
	if not (top_sprite && bottom_sprite):
		return
	if open:
		top_sprite.animation = "open_top"
		bottom_sprite.animation = "open_bottom"
	else:
		top_sprite.animation = "closed_top"
		bottom_sprite.animation = "closed_bottom"
	if mode == DoorMode.Top:
		top_sprite.visible = true
		bottom_sprite.visible = false
	else:
		top_sprite.visible = false
		bottom_sprite.visible = true
