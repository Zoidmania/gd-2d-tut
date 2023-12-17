extends Node

@export var mob_scene: PackedScene
var score: int

# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func new_game():

    score = 0

    # delete all lingering mobs if they haven't despawned from a previous game
    get_tree().call_group("mobs", "queue_free")

    # place player at the start position
    $Player.start($StartPosition.position)

    $HUD.update_score(score)
    $HUD.show_message("Get Ready")

    $Music.play()

    # wait 2 seconds before starting to spawn mobs
    $StartTimer.start()


func game_over():

    $ScoreTimer.stop()
    $MobTimer.stop()

    $Music.stop()
    $DeathSound.play()

    $HUD.show_game_over()


# spawns a new mob at a random location
func _on_mob_timer_timeout():

    var mob = mob_scene.instantiate()

    # choose a random location on the path
    var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
    mob_spawn_location.progress_ratio = randf()

    # set the mob's position
    mob.position = mob_spawn_location.position

    # set mob's direction perpendicular to the path direction
    # Nota Bene: angles are calculated in radians, not degrees, so we use ratios of Pi here. Pi
    # radians is equal to 180 degrees.
    var direction = mob_spawn_location.rotation + PI / 2
    # add some randomness to the direction
    direction += randf_range(-PI / 4, PI / 4)
    mob.rotation = direction

    # set random velocity fot hte mob
    var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
    mob.linear_velocity = velocity.rotated(direction)

    # spawn the mob by adding it to the main tree
    add_child(mob)


# increments score by 1
func _on_score_timer_timeout():

    score += 1

    $HUD.update_score(score)


# starts the other two timers
func _on_start_timer_timeout():

    $MobTimer.start()
    $ScoreTimer.start()
