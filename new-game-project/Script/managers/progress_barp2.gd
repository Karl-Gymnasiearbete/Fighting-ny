extends TextureProgressBar

#@export var p2 : Player2


func _ready():
	#player.healthChanged.connect(update)
	update()

func update():
	pass
	#value = p2.currentHealth * / p2.maxHealth
