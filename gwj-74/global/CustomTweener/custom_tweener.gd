extends Node

func tween_visibility(item_on: CanvasItem, tween_on: Tween, item_off: CanvasItem, tween_off: Tween, duration: float) -> Array[Tween]:
	if tween_on:
		tween_on.kill()
	tween_on = get_tree().create_tween()
	if tween_off:
		tween_off.kill()
	tween_off = get_tree().create_tween()

	item_on.visible = true
	item_off.visible = true

	tween_on.tween_property(item_on, "modulate:a", 1, duration)
	tween_off.tween_property(item_off, "modulate:a", 0, duration)
	tween_off.tween_callback(item_off.hide)
	return [tween_on, tween_off]


func reset_visibility(item_on : CanvasItem, item_off : CanvasItem) -> void:
	item_on.visible = true
	item_on.modulate.a = 1
	item_off.visible = false
	item_off.modulate.a = 0


func set_visibility(value: bool, item: CanvasItem, tween: Tween, duration: float) -> Tween:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()

	if value:
		item.visible = true
		tween.tween_property(item, "modulate:a", 1, duration)
	else:
		tween.tween_property(item, "modulate:a", 0, duration)
		tween.tween_callback(item.hide)
	return tween


func switch_lights(lights_on : Array, lights_off : Array) -> void:
	for light in lights_on:
		light.visible = true
	for light in lights_off:
		light.visible = false