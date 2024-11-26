class_name AStar2DWithEdgeWeights extends AStar2D

const MIN_EDGE_WEIGHT = 0.0

# Dict[Array[int], float]
var edge_weights = {}


func _compute_cost(from_id: int, to_id: int) -> float:
    var cost: int

    if [from_id, to_id] in edge_weights:
        cost = edge_weights[[from_id, to_id]]
    else:
        cost = edge_weights[[to_id, from_id]]

    return cost


func _estimate_cost(from_id: int, to_id: int) -> float:
    var cost = MIN_EDGE_WEIGHT

    if [from_id, to_id] in edge_weights:
        cost = edge_weights[[from_id, to_id]]
    elif [to_id, from_id] in edge_weights:
        cost = edge_weights[[to_id, from_id]]

    return cost


func connect_points_with_edge_weight(
    id: int, to_id: int, edge_weight: float, bidirectional: bool = true
) -> void:
    edge_weights[[id, to_id]] = edge_weight
    super.connect_points(id, to_id, bidirectional)


func disconnect_points_with_edge_weight(id: int, to_id: int, bidirectional: bool = true) -> void:
    if [id, to_id] in edge_weights:
        edge_weights.erase([id, to_id])
    else:
        edge_weights.erase([to_id, id])

    super.disconnect_points(id, to_id, bidirectional)
