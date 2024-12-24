class_name RecipeButton
extends HBoxContainer


signal selected(recipe: CraftingRecipe)


@onready var button: TextureButton = $Texture

var crafting_recipe : CraftingRecipe


func _ready() -> void:
	if !crafting_recipe:
		return
	
	button.texture_normal = crafting_recipe.output.item.sprite
	button.pressed.connect(on_button_pressed)


func on_button_pressed():
	selected.emit(crafting_recipe)
