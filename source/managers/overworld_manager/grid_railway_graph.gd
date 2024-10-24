extends RefCounted

class_name GridRailwayGraph

var astar = AStar2DWithEdgeWeights.new()

# Dict[Vector2, int]
var vertex_id_to_astar_id_mapping = {}
# Dict[Vector2, GridRailwayVertex]
var vertexes = {}
# Dict[Vector2, GridRailwayEdge]
var edges = {}

const FIRST_VERTEX_ID_IN_EDGE_ID := 0
const SECOND_VERTEX_ID_IN_EDGE_ID := 1


func add_vertex(id: Vector2, vertex: GridRailwayVertex) -> void:
    var astar_id := astar.get_available_point_id()

    vertexes[id] = vertex
    vertex_id_to_astar_id_mapping[id] = astar_id
    astar.add_point(astar_id, id)


func add_edge(from_id: Vector2, to_id: Vector2, edge: GridRailwayEdge) -> void:
    var id := [from_id, to_id]
    var astar_from_id = vertex_id_to_astar_id_mapping[from_id]
    var astar_to_id = vertex_id_to_astar_id_mapping[to_id]

    edges[id] = edge
    astar.connect_points_with_edge(astar_from_id, astar_to_id, edge.weight)


func remove_vertex(id: Vector2) -> void:
    if id not in vertexes:
        return

    var vertex: GridRailwayVertex = vertexes[id]
    # Array[Array[Vector2]]
    var vertex_connections = vertex.get_connections()

    for vertex_connection in vertex_connections:
        var first_vertex_id: Vector2 = vertex_connection[FIRST_VERTEX_ID_IN_EDGE_ID]
        var second_vertex_id: Vector2 = vertex_connection[SECOND_VERTEX_ID_IN_EDGE_ID]
        var vertex_neighbour: GridRailwayVertex
        
        if first_vertex_id != id:
            vertex_neighbour = vertexes[first_vertex_id]
        else:
            vertex_neighbour = vertexes[second_vertex_id]

        vertex_neighbour.remove_connection(vertex_connection)
        edges.erase(vertex_connection)

    vertexes.erase(id)


func remove_edge(from_id: Vector2, to_id: Vector2) -> void:
    var id = [from_id, to_id]
    var edge: GridRailwayEdge = get_edge(from_id, to_id)

    if not edge:
        return

    var astar_from_id = vertex_id_to_astar_id_mapping[from_id]
    var astar_to_id = vertex_id_to_astar_id_mapping[to_id]
    
    edges.erase(id)
    vertexes[from_id].remove_connection(id)
    vertexes[to_id].remove_connection(id)
    astar.disconnect_points_with_edge(astar_from_id, astar_to_id)


func get_vertex(id: Vector2) -> GridRailwayVertex:
    if id in vertexes:
        return vertexes[id]
    
    return null


func get_edge(from_id: Vector2, to_id: Vector2) -> GridRailwayEdge:
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