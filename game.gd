extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
var pad_size
var direction = Vector2(-1.0, 0.9)

const PAD_SPEED = 100
var ball_speed = 80
var multiplier = 1.1

func reset_direction():
  randomize()
  var random_x = [1.0, -1.0][randi() % 2]
  var random_y = randf() * [1, -1][randi() % 2]
  direction = Vector2(random_x, random_y)
  print(direction)

func reset_speed():
  ball_speed = 80

# Called when the node enters the scene tree for the first time.
func _ready():
  screen_size = get_viewport_rect().size
  $ball.position = screen_size * 0.5
  reset_direction()
  pad_size = $left.get_texture().get_size()
  set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var current_position = $ball.position
  
  if ((current_position.y < 0 and direction.y < 0) or (current_position.y > screen_size.y and direction.y > 0)):
    direction.y = -direction.y
  
  $ball.position += direction * ball_speed * delta
  current_position = $ball.position
  
  # move left pad	
  var left_pos = $left.position
  var pad_height = $left.texture.get_height()
  if (left_pos.y + (pad_height / 2) < screen_size.y and Input.is_action_pressed("move_down")):
    $left.position.y += PAD_SPEED * delta
    
  if (left_pos.y - (pad_height / 2 ) > 0 and Input.is_action_pressed("move_up")):
    $left.position.y += -PAD_SPEED * delta

  # bouce ball off leftpad
  var leftrec = Rect2($left.position - $left.texture.get_size() * 0.5, $left.get_texture().get_size())
  if (leftrec.has_point($ball.position)):
    direction.x = -direction.x
    ball_speed *= multiplier
    
  # bounce ball off rightpad
  var rightrec = Rect2($right.position - $right.texture.get_size() * 0.5, $right.get_texture().get_size())
  if (rightrec.has_point($ball.position)):
    direction.x = -direction.x
    ball_speed *= multiplier
    
  # Check gameover
  if (current_position.x < 0 or current_position.x > screen_size.x):
    $ball.position = screen_size*0.5
    reset_speed()
    reset_direction()

  # right pad - computer controlled
  if ($right.position.y > $ball.position.y and $right.position.y - ($right.texture.get_height() / 2) > 0):
    $right.position.y += -PAD_SPEED * delta
  
  if ($right.position.y < $ball.position.y and $right.position.y + ($right.texture.get_height() / 2) < screen_size.y):
    $right.position.y += PAD_SPEED * delta
