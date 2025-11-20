extends TextureProgressBar

#@export var p1 : Player1


func _ready():
	#player.healthChanged.connect(update)
	update()

func update():
	pass
	#value = p1.currentHealth * / p1.maxHealth
