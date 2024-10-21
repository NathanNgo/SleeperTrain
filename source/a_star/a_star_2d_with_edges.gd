extends AStar2D

class_name AStar2DWithEdges

# Dict[Array[int], Node2D]
var edges = {}
const MIN_EDGE_WEIGHT = 0.0


func _compute_cost(from_id: int, to_id: int) -> float:
	var cost: int

	if [from_id, to_id] in edges:
		cost = edges[[from_id, to_id]].weight
	else:
		cost = edges[[to_id, from_id]].weight

	return cost


func _estimate_cost(from_id: int, to_id: int) -> float:
	var cost = MIN_EDGE_WEIGHT

	if [from_id, to_id] in edges:
		cost = edges[[from_id, to_id]].weight
	elif [to_id, from_id] in edges:
		cost = edges[[to_id, from_id]].weight

	return cost


func connect_points_with_edge(id: int, to_id: int, edge: Node2D, bidirectional: bool = true) -> void:
	edges[[id, to_id]] = edge
	super.connect_points(id, to_id, bidirectional)


func disconnect_points_with_edge(id: int, to_id: int, bidirectional: bool = true) -> void:
	edges.erase([id, to_id])
	super.disconnect_points(id, to_id, bidirectional)
