extends KinematicBody2D

const MAX_SPEED = 150
var velocity = Vector2.ZERO

func _ready():
  add_to_group("player_pad")

func _physics_process(delta):
  var input_vector = Vector2.ZERO
  input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

  if input_vector != Vector2.ZERO:
    velocity = input_vector  * MAX_SPEED
  else:
    velocity = Vector2.ZERO

  move_and_collide(velocity * delta)
