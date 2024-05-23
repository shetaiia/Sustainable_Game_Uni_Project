class_name Card
extends Resource

enum Type {BUILDING, RESOURCES, ENVIROMENT, DECKS}  #type of cards

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var tile_id: int

func is_effecting_map() -> bool:
	return type == Type.BUILDING #returns true if CardType is BUILDING

func card_type() -> String:
	return Type.keys()[type]

func play(player_stats: PlayerStats):
	Events.card_played.emit(self)
	# here change the player stats
	apply_effects()

# abstract function for the specific cards
func apply_effects():
	pass
