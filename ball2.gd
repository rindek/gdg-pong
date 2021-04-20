extends KinematicBody2D


var speed = 80
const MAX_SPEED = 400
var velocity = Vector2.ZERO

func _ready():
  end_of_round()

func end_of_round():
 randomize()
 position = get_viewport_rect().size*0.5
 speed = 100
 velocity.x = randf() * [1, -1][randi() % 2]
 velocity.y = randf() * [1, -1][randi() % 2]
 velocity = velocity.normalized() * speed
 get_node("../Labels/round_number").increment()
 print(velocity)

func _physics_process(delta):
  move_and_slide(velocity * delta * speed)

  if get_slide_count() > 0:
    var collision = get_slide_collision(0)
    print(collision)

    if collision.collider.is_in_group("player_pad"):
      get_node("../Labels/leftscore").increment()

    if collision.collider.is_in_group("computer_pad"):
      get_node("../Labels/rightscore").increment()

    if collision.collider.is_in_group("killer_wall"):
      end_of_round()

    elif collision != null:
      velocity = velocity.bounce(collision.normal)
      speed = min(speed + 5, MAX_SPEED)
      print(velocity, speed)
