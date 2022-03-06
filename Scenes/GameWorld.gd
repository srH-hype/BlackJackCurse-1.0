extends Node2D

const TILE_SIZE = 96

const LEVEL_SIZE = [
	Vector2(30,30),
	Vector2(35,35),
	Vector2(40,40),
	Vector2(45,45),
	Vector2(50,50)
]

const LEVEL_ROOMS = [5,7,9,12,15]
const MIN_ROOM_DIME = 5
const MAX_ROOM_DIME = 8

enum Tile {wall,flor}

var level_num = 0 
var map = []
var rooms = []
var level_size 

onready var title_map = $TileMap
onready var player = $protoplayer

var player_tile

func _ready():
	randomize()
	buildLevel()

func buildLevel():
	rooms.clear()
	map.clear()
	title_map.clear()
	
	level_size = LEVEL_SIZE[level_num]
	for x in range(level_size.x):
		map.append([])
		for y in range(level_size.y):
			map[x].append(Tile.wall)
			title_map.set_cell(x,y, Tile.wall)
