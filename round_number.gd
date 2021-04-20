extends Label

var score: int;

func _ready():
  score = 0;

func reset(value):
  score = value;
  update();

func increment():
  score += 1;
  update();

func update():
  set_text(String(score))
