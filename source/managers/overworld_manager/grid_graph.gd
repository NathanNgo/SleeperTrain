extends RefCounted

class_name GridGraph

var astar = AStar2DWithEdges.new()

var vertex_id_to_astar_id_mapping = {}
var vertexes = {}
var edges = {}


func add_vertex(id: Vector2, vertex: Variant) -> void:
    var astar_id := astar.get_available_point_id()
    vertexes[id] = vertex
    vertex_id_to_astar_id_mapping[id] = astar_id
    astar.add_point(astar_id, id)


func add_edge(from_id: Vector2, to_id: Vector2, edge: Variant) -> void:
    var id := [from_id, to_id]
    var astar_from_id = vertex_id_to_astar_id_mapping[from_id]
    var astar_to_id = vertex_id_to_astar_id_mapping[to_id]
    edges[id] = edge
    astar.connect_points_with_edge(astar_from_id, astar_to_id, edge.weight)


func remove_vertex(id: Vector2) -> void:
    pass


func remove_edge(from_id: Vector2, to_id: Vector2) -> void:
    var id = [from_id, to_id]
    var edge: Variant = get_edge(from_id, to_id)
    
    if edge:
        edges.erase(id)
        vertexes[from_id].remove_connection(id)
        vertexes[to_id].remove_connection(id)


func get_edge(from_id: Vector2, to_id: Vector2) -> Variant:
    var id = [from_id, to_id]
    var reverse_id = [to_id, from_id]

    if id in edges:
        return edges[id]
    elif reverse_id in edges:
        return edges[reverse_id]

    return null


func get_path(from_id: Vector2, to_id: Vector2) -> Array[Vector2]:
    var astar_from_id = vertex_id_to_astar_id_mapping[from_id]
    var astar_to_id = vertex_id_to_astar_id_mapping[to_id]
    var path_ids = astar.get_point_path(astar_from_id, astar_to_id)

    return path_ids