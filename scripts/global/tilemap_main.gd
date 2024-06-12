extends Node2D

signal tile_placed(amount)

var start_size = 20
var dic = {}
var last_indicator = Vector2i(0,0)
var tile_dic = get_all_tile_coords($TileMap.get_tileset().get_source(1))

var selected_item = 1
var selected_tile: int
@onready var tilemap = $TileMap

var aiming = false


# Called when the node enters the scene tree for the first 
func _ready():
	Events.card_aim_started.connect(show_cursor)
	Events.card_aim_ended.connect(hide_cursor)
	Events.place_tile.connect(place_tile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if aiming:
		$TileMap.clear_layer(2)
		$TileMap.set_cell(2, $TileMap.local_to_map(get_global_mouse_position()), 16, Vector2i.ZERO, 0) 


static func get_all_tile_coords(tile_source: TileSetSource) -> Array[Vector2i]:	
	var coords: Array[Vector2i] = []

	for i in tile_source.get_tiles_count():
		coords.append(tile_source.get_tile_id(i))

	return coords


func _on_background_music_ready():
	pass # Replace with function body.

func show_cursor(tile: int):
	aiming = true
	selected_tile = tile
	tilemap.set_layer_enabled(2, true)

func hide_cursor():
	aiming = false
	tilemap.set_layer_enabled(2, !true)

func place_tile(card: Card):
	var mouse_pos = get_global_mouse_position()
	# Condition for expanding map, can only place when there are Tiles adjecent
	if(card.layer == 0 && is_neighbor_tiles(mouse_pos)):
		$TileMap.set_cell(0, $TileMap.local_to_map(mouse_pos), selected_tile, Vector2i.ZERO, 0)
		Events.tile_placed.emit()
		return
	# Check if there is a vaiable space
	if($TileMap.get_cell_source_id(0,$TileMap.local_to_map(mouse_pos)) == -1 || $TileMap.get_cell_source_id(1,$TileMap.local_to_map(mouse_pos)) != -1):
		return
	else:
		$TileMap.set_cell(1, $TileMap.local_to_map(mouse_pos), selected_tile, Vector2i.ZERO, 0)
		Events.tile_placed.emit()
		
func is_neighbor_tiles(mouse_pos)-> bool:
	var neighbors = $TileMap.get_surrounding_cells($TileMap.local_to_map(mouse_pos))
	for n in range (0, neighbors.size()):
		if($TileMap.get_cell_source_id(0, neighbors[n]) != -1):
			return true
	return false