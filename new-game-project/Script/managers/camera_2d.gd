extends Camera2D

var player1: Node2D
var player2: Node2D

@export var min_zoom := 1.0
@export var max_zoom := 0.5
@export var zoom_margin := 200.0
@export var smoothing_speed := 5.0
@export var min_x := -INF
@export var max_x := INF
@export var min_y := -INF
@export var max_y := INF

func _ready():
	# Wait for players to be spawned and added to groups
	await get_tree().process_frame
	
	var p1_nodes = get_tree().get_nodes_in_group("player1")
	var p2_nodes = get_tree().get_nodes_in_group("player2")
	
	if p1_nodes.size() > 0:
		player1 = p1_nodes[0]
	if p2_nodes.size() > 0:
		player2 = p2_nodes[0]

func _process(delta):
	if not player1 or not player2:
		return
	
	var mid_point = (player1.global_position + player2.global_position) / 2.0
	var distance = player1.global_position.distance_to(player2.global_position)
	
	var viewport_size = get_viewport_rect().size
	var desired_zoom = max((distance + zoom_margin) / viewport_size.x, min_zoom) 
	desired_zoom = clamp(desired_zoom, max_zoom, min_zoom)
	
	var target_pos = Vector2(clamp(mid_point.x, min_x, max_x), clamp(mid_point.y, min_y, max_y))
	
	global_position = global_position.lerp(target_pos, smoothing_speed * delta)
	zoom = zoom.lerp(Vector2.ONE / desired_zoom, smoothing_speed * delta)
