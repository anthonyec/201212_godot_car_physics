tool
extends Spatial

export var selector: String
export var entity: NodePath

var model: Spatial

func _ready():
	if Engine.editor_hint:
		return
		
	if model and selector and entity:
		var entity_node = get_node(entity)
		
		
		for child in model.get_children():
			if selector in child.name:
				var duplicated_entity = entity_node.duplicate()
				
				duplicated_entity.name = child.name
				add_child(duplicated_entity)
				duplicated_entity.global_transform = child.global_transform
		
		# Remove entity?
		entity_node.visible = false

func _on_model_loaded(loaded_model: Spatial):
	model = loaded_model

func _on_model_unloaded():
	model = null
	
	for child in get_children():
		remove_child(child)


func _on_VehicleModelLoader_model_loaded():
	pass # Replace with function body.
