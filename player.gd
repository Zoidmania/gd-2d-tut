extends Area2D

signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():

    hide()
    screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    # initial movement vector
    var velocity = Vector2.ZERO

    if Input.is_action_pressed("move_right"):
        velocity.x += 1
    if Input.is_action_pressed("move_left"):
        velocity.x -= 1
    if Input.is_action_pressed("move_up"):
        velocity.y -= 1
    if Input.is_action_pressed("move_down"):
        velocity.y += 1

    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite2D.play()
    else:
        $AnimatedSprite2D.stop()

    position += velocity * delta
    # prevent going out of bounds
    position = position.clamp(Vector2.ZERO, screen_size)

    if velocity.x != 0:
        $AnimatedSprite2D.animation = "walk"
        $AnimatedSprite2D.flip_v = false
        $AnimatedSprite2D.flip_h = velocity.x < 0
    if velocity.y != 0:
        $AnimatedSprite2D.animation = "up"
        $AnimatedSprite2D.flip_v = velocity.y > 0


# call to reset player to starting state
func start(pos: Vector2):

    position = pos
    show()
    $CollisionShape2D.disabled = false


func _on_body_entered(body: Node2D):
    # player disappears after being hit
    hide()

    hit.emit()

    # must be deferred as we can't change physics properties on a physics callback.
    # Nota Bene: Disabling the area's collision shape can cause an error if it happens in the middle
    # of the engine's collision processing. Using `set_deferred()` tells Godot to wait to disable
    # the shape until it's safe to do so.
    $CollisionShape2D.set_deferred("disabled", true)

