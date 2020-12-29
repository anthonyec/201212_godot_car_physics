tool
extends Spatial

export var model_resource: PackedScene = null setget set_model_resource

signal model_loaded
signal model_unloaded

func load_model_resource(resource: PackedScene):
	if !resource:
		return null
		
	var model = load(resource.resource_path).instance()
	
	model.name = "Model"
	
	add_child(model)
	emit_signal("model_loaded", model)

func unload_model_resource():
	var model = get_node_or_null("Model")
		
	if model:
		remove_child(model)
		emit_signal("model_unloaded")

func set_model_resource(value: PackedScene) -> PackedScene:
	if !value:
		unload_model_resource()
		
	model_resource = value
	load_model_resource(value)
	return value;
