# @tool marks our script as a "tool" script, which means it also runs while the
# editor is open. We do this so we can do lightning effects from the editor when
# our game isn't running.
@tool
extends CanvasModulate
## A class that modulates the scene color to some lighting color, to add in
## actual lighting. Additionally, provides a way to create a lightning effect
## whenever we call do_lightning
class_name AmbientLight

# _do_lightning_action is technically unused, but that's just how tool buttons work.
@warning_ignore("unused_private_class_variable") 
## Adds a button we can use to manually trigger lightning when in the editor
@export_tool_button("Do Lightning") var _do_lightning_action = do_lightning

## The light color to use for lightning
@export var lightning_color: Color

## The base color of our scene. Makes everything dark and moody
@export var base_color: Color:
	set(value):
		base_color = value
		# color is our actual lighting color
		color = base_color

# creates a tween object for the lightning effect
var _tween: Tween

## Called when this node enters the scene tree for the first time. 
## Sets our color to base color
func _ready() -> void:
	color = base_color

## Creates a flash of lightning in the world.
func do_lightning() -> void:
	
#	If there's a previous tween, abort it.
	if _tween:
		_tween.kill()
	
#	Creates the tween object. Tweens allow us to smoothly transition some property
#	from one value to another.
	_tween = (get_tree()
		.create_tween()
		.bind_node(self)
		.set_trans(Tween.TRANS_BOUNCE))
	
#	Smoothly transitions our color from base_color to lightning_color.
#	Does this very quickly, but not instantly
	(_tween
		.tween_property(self, "color", lightning_color, 0.2)
		.set_trans(Tween.TRANS_EXPO)
		.set_ease(Tween.EASE_OUT)
	)
	
#	Smoothly transitions from lightning_color to base_color.
#	Does this rather slowly and dramatically
	(_tween
#		Chain forces this tween call to wait until the previous effects are done 
#		before it can be run (multiple properties can be tweened in parallel!)
		.chain()
		.tween_property(self, "color", base_color, 1.5)
	)
