extends Node2D

var screen_size
var direction = Vector2(-1.0, 0.9)

const PAD_SPEED = 100
var ball_speed = 80
var multiplier = 1.1

var just_bounced = false

var _timer = null

func reset_direction():
  randomize()
  var random_x = [1.0, -1.0][randi() % 2]
  var random_y = randf() * [1, -1][randi() % 2]
  direction = Vector2(random_x, random_y)
  print(direction)

func reset_speed():
  ball_speed = 80

func debounce():
  just_bounced = false

func round_number() -> int:
  return int($Labels/round_number.text)

func check_game_over():
  if (round_number() > 5):
    get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
  screen_size = get_viewport_rect().size
  reset_ball_position()
  reset_direction()
  set_process(true)
  _timer = Timer.new()
  add_child(_timer)
  _timer.connect("timeout", self, "debounce")

func is_out_of_bounds(dir: String) -> bool:
  if dir == "up":
    return $ball.position.y < 0
  elif dir == "down":
    return $ball.position.y > screen_size.y
  elif dir == "right":
    return $ball.position.x > screen_size.x
  elif dir == "left":
    return $ball.position.x < 0
  else:
    return false
    
func is_heading(dir: String) -> bool:
  if dir == "up":
    return direction.y < 0
  else:
    return direction.y > 0

func mirror_y() -> void:
  direction.y = -direction.y  

func move_ball(delta: float) -> void:
  $ball.position += direction * ball_speed * delta

func move_left_pad(delta: float) -> void:
  var left_pos = $left.position
  var pad_height = $left.texture.get_height()
  if (left_pos.y + (pad_height / 2) < screen_size.y and Input.is_action_pressed("move_down")):
    $left.position.y += PAD_SPEED * delta
    
  if (left_pos.y - (pad_height / 2 ) > 0 and Input.is_action_pressed("move_up")):
    $left.position.y += -PAD_SPEED * delta

func bounce(pad: Sprite, label: Label) -> void:
  var rect = Rect2(pad.position - pad.texture.get_size() * 0.5, pad.get_texture().get_size())
  if (rect.has_point($ball.position) and !just_bounced):
    just_bounced = true
    direction.x = -direction.x
    ball_speed *= multiplier
    label.set_text(String(int(label.text) + 1))
    _timer.set_wait_time(0.1)
    _timer.set_one_shot(true)
    _timer.start()

func reset_ball_position() -> void:
  $ball.position = screen_size*0.5

func add_round_number() -> void:
  $Labels/round_number.set_text(String(round_number() + 1))

func end_of_round() -> void:
  reset_ball_position()
  reset_speed()
  reset_direction()
  add_round_number()
  check_game_over()

func ai(delta: float) -> void:
  ## right pad - computer controlled
  if ($right.position.y > $ball.position.y and $right.position.y - ($right.texture.get_height() / 2) > 0):
    $right.position.y += -PAD_SPEED * delta
  
  if ($right.position.y < $ball.position.y and $right.position.y + ($right.texture.get_height() / 2) < screen_size.y):
    $right.position.y += PAD_SPEED * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  ## bounce of ceiling and floor
  if (is_out_of_bounds("up") and is_heading("up")):
    mirror_y()

  if (is_out_of_bounds("down") and is_heading("down")):
    mirror_y()

  ## move ball
  move_ball(delta)
   
  ## move left pad	
  move_left_pad(delta)

  ## bounce off pads
  bounce($left, $Labels/leftscore)
  bounce($right, $Labels/rightscore)

  ## check round end
  if (is_out_of_bounds("right") or is_out_of_bounds("left")):
    end_of_round()

  ## handle AI
  ai(delta)
