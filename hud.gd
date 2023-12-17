extends CanvasLayer

# notifies the Main node that the Start button has been pressed.
signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


# displays a message for the duration of `MessageTimer`
func show_message(text: String):

    $Message.text = text
    $Message.show()
    $MessageTimer.start()


func show_game_over():

    show_message("Game Over")

    await $MessageTimer.timeout

    # reset message to pre-start state
    $Message.text = "Dodge the Creeps!"
    $Message.show()

    # make a one-shot timer and wait for it to finish
    # Nota Bene: the SceneTree has a built-in function `create_timer` that's useful for delaying for
    # a fixed number of seconds without having to create one-shot timers explicitly.
    await get_tree().create_timer(1.0).timeout
    $StartButton.show()


func update_score(score: int):
    $ScoreLabel.text = str(score)


# hides a displayed message after the duration of `MessageTimer`
func _on_message_timer_timeout():

    $Message.hide()


# fires the `start_game` signal and hides the `Start` button
func _on_start_button_pressed():

    $StartButton.hide()
    start_game.emit()
