extends Node2D

const TILE_SIZE = 96
const ENEMY = preload("res://Scenes/protoEnemy.tscn")

const LEVEL_SIZES = [
	Vector2(30, 30),
	Vector2(35, 35),
	Vector2(40, 40),
	Vector2(45, 45),
	Vector2(50, 50),
]

var player_tile

const LEVEL_ROOM_COUNTS = [5, 7, 9, 12, 15]
const MIN_ROOM_DIMENSION = 5
const MAX_ROOM_DIMENSION = 8

enum Tile{wall, way}

var enemies = []
var enemy_pathfinding

onready var tile_map = $TileMap

var level_num = 0
var map = []
var rooms = []
var level_size

func _ready():
	randomize()
	build_level()
	GameManager.connect("endTurnSignal", self, "endTurnSig")
	GameManager.connect("cardFireSignal", self,"cardFire")
	EnemiesSingelton.connect("signalRemove",self, "removeEnemy")
	

#Creating the level.
func build_level():
	
	rooms.clear()
	map.clear()
	tile_map.clear()
	
	for enemy in enemies:
		enemy.remove()
	enemies.clear()
	
	enemy_pathfinding = AStar2D.new()
	
	level_size = LEVEL_SIZES[level_num]
	for x in range(level_size.x):
		map.append([])
		for y in range(level_size.y):
			map[x].append(Tile.wall)
			tile_map.set_cell(x, y, Tile.wall)
	
	var free_regions = [Rect2(Vector2(2, 2), level_size - Vector2(4, 4))]
	var num_rooms = LEVEL_ROOM_COUNTS[level_num]
	for i in range(num_rooms):
		add_room(free_regions)
		if free_regions.empty():
			break
	
	connect_rooms()
	
	
	var start_room = rooms.front()
	var player_x = start_room.position.x + 1 + randi() % int(start_room.size.x - 2)
	var player_y = start_room.position.y + 1 + randi() % int(start_room.size.y - 2)
	player_tile = Vector2(player_x, player_y)
	movePlayer()
	
	#Enemies
	EnemiesSingelton.enemiesPerLevel()
	var num_enemies = EnemiesSingelton.enemiesInLevel
	
	for i in range(num_enemies):
		var room = rooms[1 + randi() % (rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		var blocked = false
		for enemy in enemies:
			if enemy.tile.x == x && enemy.tile.y == y:
				blocked = true
				break
			
		if !blocked:
			var newEnemy = ENEMY.instance()
			newEnemy.create(EnemiesSingelton.enemiesList[i],x,y)
			newEnemy.position = newEnemy.tile * TILE_SIZE
			$enemies.add_child(newEnemy)
			enemies.append(newEnemy)

func clear_path(tile):
	var new_point = enemy_pathfinding.get_available_point_id()
	enemy_pathfinding.add_point(new_point, Vector2(tile.x, tile.y))
	var points_to_connect = []
	
	if tile.x > 0 && map[tile.x - 1][tile.y] == Tile.way:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector2(tile.x - 1, tile.y)))
	if tile.y > 0 && map[tile.x][tile.y - 1] == Tile.way:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector2(tile.x, tile.y - 1)))
	if tile.x < level_size.x - 1 && map[tile.x + 1][tile.y] == Tile.way:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector2(tile.x + 1, tile.y)))
	if tile.y < level_size.y - 1 && map[tile.x][tile.y + 1] == Tile.way:
		points_to_connect.append(enemy_pathfinding.get_closest_point(Vector2(tile.x, tile.y + 1)))
		
	for point in points_to_connect:
		enemy_pathfinding.connect_points(point, new_point)

func movePlayer():
	$player.position = player_tile * TILE_SIZE

func endTurn():
	GameManager.endTurn()
	movePlayer()

func _input(event):
	if GameManager.enemyTurn == false:
		if event.is_pressed():
			return
		
		if event.is_action("Left"):
			try_move(-1,0)
			$player.move()
		elif event.is_action("Right"):
			try_move(1,0)
			$player.move()
		elif event.is_action("Up"):
			try_move(0,-1)
			$player.move()
		elif event.is_action("Down"):
			try_move(0,1)
			$player.move()
	

func try_move(dx, dy):
	var x = player_tile.x + dx 
	var y = player_tile.y + dy
	
	var tile_type = Tile.wall
	if x >= 0 && x < level_size.x && y >= 0 && y < level_size.y:
		tile_type = map[x][y]
	
	match tile_type:
		Tile.way:
			var blocked = false
			for enemy in enemies:
				if  enemy.tile.x == x && enemy.tile.y == y:
					GameManager.takeDamage(enemy.attack)
					blocked = true
					break
			if !blocked:
				player_tile = Vector2(x,y)
	
	endTurn()

#Connecting the rooms together.
func connect_rooms():
	# Build an AStar graph of the area where we can add corridors
	
	var stone_graph = AStar2D.new()
	var point_id = 0
	for x in range(level_size.x):
		for y in range(level_size.y):
			if map[x][y] == Tile.wall:
				stone_graph.add_point(point_id, Vector2(x, y))
				
				# Connect to left if also stone
				if x > 0 && map[x - 1][y] == Tile.wall:
					var left_point = stone_graph.get_closest_point(Vector2(x - 1, y))
					stone_graph.connect_points(point_id, left_point)
					
				# Connect to above if also stone
				if y > 0 && map[x][y - 1] == Tile.wall:
					var above_point = stone_graph.get_closest_point(Vector2(x, y - 1))
					stone_graph.connect_points(point_id, above_point)
					
				point_id += 1
	
	var room_graph = AStar2D.new()
	point_id = 0
	for room in rooms:
		var room_center = room.position + room.size / 2
		room_graph.add_point(point_id, Vector2(room_center.x, room_center.y))
		point_id += 1
	
	# Add random connections until everything is connected
	
	while !is_everything_connected(room_graph):
		add_random_connection(stone_graph, room_graph)

func is_everything_connected(graph):
	var points = graph.get_points()
	var start = points.pop_back()
	for point in points:
		var path = graph.get_point_path(start, point)
		if !path:
			return false
			
	return true

func get_least_connected_point(graph):
	var point_ids = graph.get_points()
	
	var least
	var tied_for_least = []
	
	for point in point_ids:
		var count = graph.get_point_connections(point).size()
		if !least || count < least:
			least = count
			tied_for_least = [point]
		elif count == least:
			tied_for_least.append(point)
			
	return tied_for_least[randi() % tied_for_least.size()]

func get_nearest_unconnected_point(graph, target_point):
	var target_position = graph.get_point_position(target_point)
	var point_ids = graph.get_points()
	
	var nearest
	var tied_for_nearest = []
	
	for point in point_ids:
		if point == target_point:
			continue
		
		var path = graph.get_point_path(point, target_point)
		if path:
			continue
			
		var dist = (graph.get_point_position(point) - target_position).length()
		if !nearest || dist < nearest:
			nearest = dist
			tied_for_nearest = [point]
		elif dist == nearest:
			tied_for_nearest.append(point)
			
	return tied_for_nearest[randi() % tied_for_nearest.size()]

#Connecting the rooms together.
func add_random_connection(stone_graph, room_graph):
	var start_room_id = get_least_connected_point(room_graph)
	var end_room_id = get_nearest_unconnected_point(room_graph, start_room_id)
	
	var start_position = pick_random_door_location(rooms[start_room_id])
	var end_position = pick_random_door_location(rooms[end_room_id])
	
	# Find a path to connect the doors to each other
	
	var closest_start_point = stone_graph.get_closest_point(start_position)
	var closest_end_point = stone_graph.get_closest_point(end_position)
	
	var path = stone_graph.get_point_path(closest_start_point, closest_end_point)
	assert(path)
	
	set_tile(start_position.x, start_position.y, Tile.way)
	set_tile(end_position.x, end_position.y, Tile.way)
	
	for position in path:
		set_tile(position.x, position.y, Tile.way)
	
	room_graph.connect_points(start_room_id, end_room_id)

func pick_random_door_location(room):
	var options = []
	
	# Top and bottom walls
	
	for x in range(room.position.x + 1, room.end.x - 2):
		options.append(Vector2(x, room.position.y))
		options.append(Vector2(x, room.end.y - 1))
			
	# Left and right walls
	
	for y in range(room.position.y + 1, room.end.y - 2):
		options.append(Vector2(room.position.x, y))
		options.append(Vector2(room.end.x - 1, y))
			
	return options[randi() % options.size()]

func add_room(free_regions):
	var region = free_regions[randi() % free_regions.size()]
		
	var size_x = MIN_ROOM_DIMENSION 
	if region.size.x > MIN_ROOM_DIMENSION:
		size_x += randi() % int(region.size.x - MIN_ROOM_DIMENSION)
	
	var size_y = MIN_ROOM_DIMENSION
	if region.size.y > MIN_ROOM_DIMENSION:
		size_y += randi() % int(region.size.y - MIN_ROOM_DIMENSION)
		
	size_x = min(size_x, MAX_ROOM_DIMENSION)
	size_y = min(size_y, MAX_ROOM_DIMENSION)
		
	var start_x = region.position.x
	if region.size.x > size_x:
		start_x += randi() % int(region.size.x - size_x)
		
	var start_y = region.position.y
	if region.size.y > size_y:
		start_y += randi() % int(region.size.y - size_y)
	
	var room = Rect2(start_x, start_y, size_x, size_y)
	rooms.append(room)
	
	for x in range(start_x, start_x + size_x):
		set_tile(x, start_y, Tile.way)
		set_tile(x, start_y + size_y - 1, Tile.way)
		
	for y in range(start_y + 1, start_y + size_y - 1):
		set_tile(start_x, y, Tile.way)
		set_tile(start_x + size_x - 1, y, Tile.way)
		
		for x in range(start_x + 1, start_x + size_x - 1):
			set_tile(x, y, Tile.way)
			
	cut_regions(free_regions, room)

func cut_regions(free_regions, region_to_remove):
	var removal_queue = []
	var addition_queue = []
	
	for region in free_regions:
		if region.intersects(region_to_remove):
			removal_queue.append(region)
			
			var leftover_left = region_to_remove.position.x - region.position.x - 1
			var leftover_right = region.end.x - region_to_remove.end.x - 1
			var leftover_above = region_to_remove.position.y - region.position.y - 1
			var leftover_below = region.end.y - region_to_remove.end.y - 1
			
		
			if leftover_left >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
			if leftover_right >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
			if leftover_above >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
			if leftover_below >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
				
	for region in removal_queue:
		free_regions.erase(region)
		
	for region in addition_queue:
		free_regions.append(region)

func act(enemy):
	enemy.move()
	var my_point = enemy_pathfinding.get_closest_point(Vector2(enemy.tile.x, enemy.tile.y))
	var player_point = enemy_pathfinding.get_closest_point(Vector2(player_tile.x, player_tile.y))
	var path = enemy_pathfinding.get_point_path(my_point, player_point)
	if path:
		assert(path.size() > 1)
		var move_tile = Vector2(path[1].x, path[1].y)
		
		if move_tile == player_tile:
			enemy.attackFrame()
		else:
			var blocked = false
			for enemy in enemies:
				if enemy.tile == move_tile:
					blocked = true
					break
			
			if !blocked:
				enemy.tile = move_tile
	enemy.position = enemy.tile * TILE_SIZE
	
	if enemy.doubleAttack && enemy.firstMove:
		enemy.firstMoveM()
		act(enemy)

func set_tile(x, y, type):
	map[x][y] = type
	tile_map.set_cell(x, y, type)
	
	if type == Tile.way:
		clear_path(Vector2(x,y))

func endTurnSig():
	for enemy in enemies:
		act(enemy)

func cardFire(value):
	print("Damage" +" "+ String(value))
	var tilesAround = []
	
	tilesAround.append(Vector2(player_tile.x+1,player_tile.y))
	tilesAround.append(Vector2(player_tile.x,player_tile.y+1))
	tilesAround.append(Vector2(player_tile.x-1,player_tile.y))
	tilesAround.append(Vector2(player_tile.x,player_tile.y-1))
	tilesAround.append(Vector2(player_tile.x+1,player_tile.y+1))
	tilesAround.append(Vector2(player_tile.x-1,player_tile.y-1))
	tilesAround.append(Vector2(player_tile.x+1,player_tile.y-1))
	tilesAround.append(Vector2(player_tile.x-1,player_tile.y+1))
	
	for enemy in enemies:
		if tilesAround.has(enemy.tile):
			enemy.takeDamage(value)

func removeEnemy(enemy):
	enemies.erase(enemy)
	$enemies.remove_child(enemy)
	if enemies.empty():
		newLevel()

func newLevel():
	GameManager.newLevel()
	_ready()
