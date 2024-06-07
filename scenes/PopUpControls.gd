extends Node2D

@onready var popup = $ControlsPopUp
@onready var button = $OpenPopUpButton

func _ready():
	popup.show()
	button.disabled = false
	#$OpenPopUpButton.connect("pressed", Callable(self, "_on_open_pop_up_button_pressed"))
	#$OpenPopUpButton.connect("pressed", Callable(self, "_on_OpenPopupButton_pressed"))
	
func _on_open_pop_up_button_pressed():
	print("clicked")
