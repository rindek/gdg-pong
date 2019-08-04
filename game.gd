extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
var pad_size
var direction = Vector2(-1.0, 0.9)

const PAD_SPEED = 100

func reset_direction():
	randomize()
	var random_x = [1.0, -1.0][randi() % 2]
	var random_y = randf() * [1, -1][randi() % 2]
#	direction = Vector2(0.1, 1)
	direction = Vector2(random_x, random_y)
	print(direction)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_direction()
	screen_size = get_viewport_rect().size
	pad_size = $left.get_texture().get_size()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_position = $ball.position
	
	if ((current_position.y < 0 and direction.y < 0) or (current_position.y > screen_size.y and direction.y > 0)):
	    direction.y = -direction.y	
	
	$ball.position += direction * 80 * delta
	current_position = $ball.position
	
	# Check gameover
	if (current_position.x < 0 or current_position.x > screen_size.x):
	    $ball.position = screen_size*0.5
	    reset_direction()

	# move left pad	
	var left_pos = $left.position
	var pad_height = $left.texture.get_height()
	if (left_pos.y + (pad_height / 2) < screen_size.y and Input.is_action_pressed("move_down")):
		$left.position.y += PAD_SPEED * delta
		
	if (left_pos.y - (pad_height / 2 ) > 0 and Input.is_action_pressed("move_up")):
		$left.position.y += -PAD_SPEED * delta
		
	# bouce ball off leftpad
	
	