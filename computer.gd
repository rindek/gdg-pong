extends KinematicBody2D

const MAX_SPEED = 150
var velocity = Vector2.ZERO

func _ready():
  add_to_group("computer_pad")

func _physics_process(delta):
  if (position.y > get_parent().get_node("ball2").position.y):
    velocity.y = -1.0 * MAX_SPEED

  elif (position.y < get_parent().get_node("ball2").position.y):
    velocity.y = 1.0 * MAX_SPEED

  move_and_collide(velocity * delta)
