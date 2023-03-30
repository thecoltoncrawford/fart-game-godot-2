extends Control

var xbox = false
var switch = false
var playstation = false
var keyboard = false
var controller = 0

func _ready():
	$OptionButton.add_item("xbox", 0)
	$OptionButton.add_item("switch", 1)
	$OptionButton.add_item("playstation", 2)
	$OptionButton.add_item("keyboard", 3)

func _physics_process(delta):
	controller = $OptionButton.get_item_index($OptionButton.selected)
	match controller:
		0:
			$Xbox.visible = true
			$Switch.visible = false
			$Playstation.visible = false
			$Keyboard.visible = false
		1:
			$Xbox.visible = false
			$Switch.visible = true
			$Playstation.visible = false
			$Keyboard.visible = false
		2:
			$Xbox.visible = false
			$Switch.visible = false
			$Playstation.visible = true
			$Keyboard.visible = false
		3:
			$Xbox.visible = false
			$Switch.visible = false
			$Playstation.visible = false
			$Keyboard.visible = true
