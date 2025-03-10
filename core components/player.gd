extends CharacterBody2D

class_name PlatformerController2D

@export var README: String = "IMPORTANT: MAKE SURE TO ASSIGN 'left' 'right' 'jump' 'dash' 'up' 'down' 'roll' 'latch' 'twirl' 'run' in the project settings input map. Usage tips. 1. Hover over each toggle and variable to read what it does and to make sure nothing bugs. 2. Animations are very primitive. To make full use of your custom art, you may want to slightly change the code for the animations"
#INFO READEME 
#IMPORTANT: MAKE SURE TO ASSIGN 'left' 'right' 'jump' 'dash' 'up' 'down' 'roll' 'latch' 'twirl' 'run'  in the project settings input map. THIS IS REQUIRED
#Usage tips. 
#1. Hover over each toggle and variable to read what it does and to make sure nothing bugs. 
#2. Animations are very primitive. To make full use of your custom art, you may want to slightly change the code for the animations

@export_category("Necesary Child Nodes")
@export var PlayerSprite: AnimatedSprite2D
@export var PlayerCollider: CollisionShape2D
@onready var dead_light: PointLight2D = $deadLight
@onready var die_fire_sfx: AudioStreamPlayer2D = $dieFireSFX
@onready var die_spikes_sfx: AudioStreamPlayer2D = $dieSpikesSFX
@onready var rat_walk: AudioStreamPlayer2D = $ratWalk
@onready var rat_dash: AudioStreamPlayer2D = $ratDash
@onready var rat_impact: AudioStreamPlayer2D = $ratImpact
@onready var rat_slide: AudioStreamPlayer2D = $ratSlide
@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_left_2: RayCast2D = $RayLeft2
@onready var ray_right_2: RayCast2D = $RayRight2

@onready var dead_particles: GPUParticles2D = $deadParticles
@export var max_platform_velocity: float = 30.0  # Adjust as needed

#INFO HORIZONTAL MOVEMENT 
@export_category("L/R Movement")
##The max speed your player will move
@export_range(50, 500) var maxSpeed: float = 200.0
##How fast your player will reach max speed from rest (in seconds)
@export_range(0, 4) var timeToReachMaxSpeed: float = 0.2
##How fast your player will reach zero speed from max speed (in seconds)
@export_range(0, 4) var timeToReachZeroSpeed: float = 0.2
##If true, player will instantly move and switch directions. Overrides the "timeToReach" variables, setting them to 0.
@export var directionalSnap: bool = false
##If enabled, the default movement speed will by 1/2 of the maxSpeed and the player must hold a "run" button to accelerate to max speed. Assign "run" (case sensitive) in the project input settings.
@export var runningModifier: bool = false

#INFO JUMPING 
@export_category("Jumping and Gravity")
##The peak height of your player's jump
@export_range(0, 20) var jumpHeight: float = 2.0
##How many jumps your character can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
@export_range(0, 4) var jumps: int = 1
##The strength at which your character will be pulled to the ground.
@export_range(0, 100) var gravityScale: float = 20.0
##The fastest your player can fall
@export_range(0, 1000) var terminalVelocity: float = 500.0
##Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var descendingGravityFactor: float = 1.3
##Enabling this toggle makes it so that when the player releases the jump key while still ascending, their vertical velocity will cut by the height cut, providing variable jump height.
@export var shortHopAkaVariableJumpHeight: bool = true
##How much the jump height is cut by.
@export_range(1, 10) var jumpVariable: float = 2
##How much extra time (in seconds) your player will be given to jump after falling off an edge. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var coyoteTime: float = 0.2
##The window of time (in seconds) that your player can press the jump button before hitting the ground and still have their input registered as a jump. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var jumpBuffering: float = 0.2

#INFO EXTRAS
@export_category("Wall Jumping")
##Allows your player to jump off of walls. Without a Wall Kick Angle, the player will be able to scale the wall.
@export var wallJump: bool = false
##How long the player's movement input will be ignored after wall jumping.
@export_range(0, 0.5) var inputPauseAfterWallJump: float = 0.1
##The angle at which your player will jump away from the wall. 0 is straight away from the wall, 90 is straight up. Does not account for gravity
@export_range(0, 90) var wallKickAngle: float = 60.0
##The player's gravity will be divided by this number when touch a wall and descending. Set to 1 by default meaning no change will be made to the gravity and there is effectively no wall sliding. THIS IS OVERRIDDED BY WALL LATCH.
@export_range(1, 20) var wallSliding: float = 1.0
##If enabled, the player's gravity will be set to 0 when touching a wall and descending. THIS WILL OVERRIDE WALLSLIDING.
@export var wallLatching: bool = false
##wall latching must be enabled for this to work. #If enabled, the player must hold down the "latch" key to wall latch. Assign "latch" in the project input settings. The player's input will be ignored when latching.
@export var wallLatchingModifer: bool = false
@export_category("Dashing")
##The type of dashes the player can do.
@export_enum("None", "Horizontal", "Vertical", "Four Way", "Eight Way") var dashType: int
##How many dashes your player can do before needing to hit the ground.
@export_range(0, 10) var dashes: int = 1
##If enabled, pressing the opposite direction of a dash, during a dash, will zero the player's velocity.
@export var dashCancel: bool = true
##How far the player will dash. One of the dashing toggles must be on for this to be used.
@export_range(1.5, 4) var dashLength: float = 2.5
@export_category("Corner Cutting/Jump Correct")
##If the player's head is blocked by a jump but only by a little, the player will be nudged in the right direction and their jump will execute as intended. NEEDS RAYCASTS TO BE ATTACHED TO THE PLAYER NODE. AND ASSIGNED TO MOUNTING RAYCAST. DISTANCE OF MOUNTING DETERMINED BY PLACEMENT OF RAYCAST.
@export var cornerCutting: bool = false
##How many pixels the player will be pushed (per frame) if corner cutting is needed to correct a jump.
@export_range(1, 5) var correctionAmount: float = 1.5
##Raycast used for corner cutting calculations. Place above and to the left of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var leftRaycast: RayCast2D
##Raycast used for corner cutting calculations. Place above of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var middleRaycast: RayCast2D
##Raycast used for corner cutting calculations. Place above and to the right of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var rightRaycast: RayCast2D
@export_category("Down Input")
##Holding down will crouch the player. Crouching script may need to be changed depending on how your player's size proportions are. It is built for 32x player's sprites.
@export var crouch: bool = false
##Holding down and pressing the input for "roll" will execute a roll if the player is grounded. Assign a "roll" input in project settings input.
@export var canRoll: bool
@export_range(1.25, 2) var rollLength: float = 2
##If enabled, the player will stop all horizontal movement midair, wait (groundPoundPause) seconds, and then slam down into the ground when down is pressed. 
@export var groundPound: bool
##The amount of time the player will hover in the air before completing a ground pound (in seconds)
@export_range(0.05, 0.75) var groundPoundPause: float = 0.25
##If enabled, pressing up will end the ground pound early
@export var upToCancel: bool = false

@export_category("Animations (Check Box if has animation)")
##Animations must be named "run" all lowercase as the check box says
@export var run: bool
##Animations must be named "jump" all lowercase as the check box says
@export var jump: bool
##Animations must be named "idle" all lowercase as the check box says
@export var idle: bool
##Animations must be named "walk" all lowercase as the check box says
@export var walk: bool
##Animations must be named "slide" all lowercase as the check box says
@export var slide: bool
##Animations must be named "latch" all lowercase as the check box says
@export var latch: bool
##Animations must be named "falling" all lowercase as the check box says
@export var falling: bool
##Animations must be named "crouch_idle" all lowercase as the check box says
@export var crouch_idle: bool
##Animations must be named "crouch_walk" all lowercase as the check box says
@export var crouch_walk: bool
##Animations must be named "roll" all lowercase as the check box says
@export var roll: bool



#Variables determined by the developer set ones.
var appliedGravity: float
var maxSpeedLock: float
var appliedTerminalVelocity: float

var friction: float
var acceleration: float
var deceleration: float
var instantAccel: bool = false
var instantStop: bool = false

var jumpMagnitude: float = 500.0
var jumpCount: int
var jumpWasPressed: bool = false
var coyoteActive: bool = false
var dashMagnitude: float
var gravityActive: bool = true
var dashing: bool = false
var dashCount: int
var rolling: bool = false

var twoWayDashHorizontal
var twoWayDashVertical
var eightWayDash

var wasMovingR: bool
var wasPressingR: bool
var movementInputMonitoring: Vector2 = Vector2(true, true) #movementInputMonitoring.x addresses right direction while .y addresses left direction
var is_dropping_through: bool = false
var is_dead: bool = false

var wall_slide_buffer_time: float = 0.05  # Adjust this value to change buffer window
var wall_slide_buffer_timer: float = 0.0
var was_wall_sliding: bool = false

var gdelta: float = 1

var dset = false

var colliderScaleLockY
var colliderPosLockY

var latched
var wasLatched
var crouching
var groundPounding

var anim
var col
var animScaleLock : Vector2

#Input Variables for the whole script
var upHold
var downHold
var leftHold
var leftTap
var leftRelease
var rightHold
var rightTap
var rightRelease
var jumpTap
var jumpRelease
var runHold
var latchHold
var dashTap
var rollTap
var downTap
var twirlTap

@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $Camera2D/AnimationPlayer

var platform_velocity: Vector2 = Vector2.ZERO

var motion_previous = Vector2()
var hit_the_ground = false

var inherited_platform_velocity: Vector2 = Vector2.ZERO
var velocity_tween: Tween
var is_tweening_velocity: bool = false

func _ready():
	dead_light.visible = false
	dead_particles.emitting = false
	rat_slide.stream_paused = true
	var count = GameManager.get_reset_count()
	#dead_particles.amount = max(1, count)
	print("Reset count: ", count)
	if !is_in_group("player"):
		add_to_group("player")

	wasMovingR = true
	anim = PlayerSprite
	col = PlayerCollider
	anim.play("hit")
	
	_updateData()
	
func _updateData():
	acceleration = maxSpeed / timeToReachMaxSpeed
	deceleration = -maxSpeed / timeToReachZeroSpeed
	
	jumpMagnitude = (10.0 * jumpHeight) * gravityScale
	jumpCount = jumps
	
	dashMagnitude = maxSpeed * dashLength
	dashCount = dashes
	
	maxSpeedLock = maxSpeed
	
	animScaleLock = abs(anim.scale)
	colliderScaleLockY = col.scale.y
	colliderPosLockY = col.position.y
	
	if timeToReachMaxSpeed == 0:
		instantAccel = true
		timeToReachMaxSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantAccel = false
	else:
		instantAccel = false
		
	if timeToReachZeroSpeed == 0:
		instantStop = true
		timeToReachZeroSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantStop = false
	else:
		instantStop = false
		
	if jumps > 1:
		jumpBuffering = 0
		coyoteTime = 0
	
	coyoteTime = abs(coyoteTime)
	jumpBuffering = abs(jumpBuffering)
	
	if directionalSnap:
		instantAccel = true
		instantStop = true
	
	
	twoWayDashHorizontal = false
	twoWayDashVertical = false
	eightWayDash = false
	if dashType == 0:
		pass
	if dashType == 1:
		twoWayDashHorizontal = true
	elif dashType == 2:
		twoWayDashVertical = true
	elif dashType == 3:
		twoWayDashHorizontal = true
		twoWayDashVertical = true
	elif dashType == 4:
		eightWayDash = true
	
	
func tween_platform_velocity(start_velocity: Vector2, duration: float = 1.0) -> void:
	print("Tween function called with velocity: ", start_velocity)
	
	if velocity_tween and velocity_tween.is_valid():
		velocity_tween.kill()
		print("Killed existing tween")
	
	velocity_tween = create_tween()
	velocity_tween.set_trans(Tween.TRANS_QUAD)
	velocity_tween.set_ease(Tween.EASE_OUT)
	
	is_tweening_velocity = true
	inherited_platform_velocity = start_velocity
	print("Set initial inherited velocity to: ", inherited_platform_velocity)
	
	# Tween the inherited velocity to zero
	velocity_tween.tween_property(self, "inherited_platform_velocity", Vector2.ZERO, duration)
	velocity_tween.finished.connect(func(): 
		is_tweening_velocity = false
		print("Tween finished"))

func _process(_delta):
	platform_velocity = Vector2.ZERO
	
	#INFO animations
	#directions
	if is_on_wall() and !is_on_floor() and latch and wallLatching and ((wallLatchingModifer and latchHold) or !wallLatchingModifer):
		latched = true
	else:
		latched = false
		wasLatched = true
		_setLatch(0.2, false)

	if rightHold and !latched and !is_dead:
		anim.scale.x = animScaleLock.x * -1
	if leftHold and !latched and !is_dead:
		anim.scale.x = animScaleLock.x
	
	#run
	if run and idle and !dashing and !crouching and !walk and !is_dead:
		if abs(velocity.x) > 30 and is_on_floor() and !is_on_wall():
			anim.speed_scale = abs(velocity.x / 150)
			anim.play("run")
		elif abs(velocity.x) < 30 and is_on_floor():
			anim.speed_scale = 1
			anim.play("idle")
	elif run and idle and walk and !dashing and !crouching and !is_dead:
		if abs(velocity.x) > 30.0 and is_on_floor() and !is_on_wall():
			#anim.speed_scale = abs(velocity.x / 150)
			if abs(velocity.x) < (maxSpeedLock):
				anim.play("run")
			else:
				anim.play("run")
		elif abs(velocity.x) < 30.0 and is_on_floor():
			anim.speed_scale = 1
			anim.play("idle")
		
	#jump
	if velocity.y < 0 and jump and !dashing and !is_dead:
		anim.speed_scale = 1
		anim.play("jump")
		
	if velocity.y > 1 and falling and !dashing and !crouching and !is_dead and wall_slide_buffer_time <= 0:
		anim.speed_scale = 1
		anim.play("falling")
	
	if dashing and !is_dead:
			anim.speed_scale = 1
			anim.play("dash")
			rat_dash.play()
	
	if latch and slide:
		#wall slide and latch
		if latched and !wasLatched:
			anim.speed_scale = 1
			anim.play("latch")
		if is_on_wall() and velocity.y > 0 and slide and anim.animation != "slide" and wallSliding != 1:
			anim.speed_scale = 1
			anim.play("slide")
			rat_slide.stream_paused = false
		else:
			rat_slide.stream_paused = true

		#dash
		if dashing and !is_dead:
			anim.speed_scale = 1
			anim.play("dash")
			
		#crouch
		if crouching and !rolling and !is_dead:
			if abs(velocity.x) > 10:
				anim.speed_scale = 1
				anim.play("crouch_walk")
			else:
				anim.speed_scale = 1
				anim.play("crouch_idle")
		
		if rollTap and canRoll and roll:
			anim.speed_scale = 1
			anim.play("roll")
		
		
		

func _physics_process(delta):
	if !dset:
		gdelta = delta
		dset = true
	#INFO Input Detectio. Define your inputs from the project settings here.
	leftHold = Input.is_action_pressed("left")
	rightHold = Input.is_action_pressed("right")
	upHold = Input.is_action_pressed("up")
	downHold = Input.is_action_pressed("down")
	leftTap = Input.is_action_just_pressed("left")
	rightTap = Input.is_action_just_pressed("right")
	leftRelease = Input.is_action_just_released("left")
	rightRelease = Input.is_action_just_released("right")
	jumpTap = Input.is_action_just_pressed("jump")
	jumpRelease = Input.is_action_just_released("jump")
	runHold = Input.is_action_pressed("run")
	latchHold = Input.is_action_pressed("latch")
	dashTap = Input.is_action_just_pressed("dash")
	rollTap = Input.is_action_just_pressed("roll")
	downTap = Input.is_action_just_pressed("down")
	twirlTap = Input.is_action_just_pressed("twirl")
	
	#Squash & Stretch
	
	if not is_on_floor():
		if abs(velocity.y) > 30.0:
			$SpriteHolder.scale.y = 1.75
			$SpriteHolder.scale.x = 0.75
			hit_the_ground = false

	if not hit_the_ground and is_on_floor():
		hit_the_ground = true
		$SpriteHolder.scale.y = 0.6
		$SpriteHolder.scale.x = 1.75
		rat_impact.pitch_scale = randf_range(1.0, 5.0)
		rat_impact.play()


	
	$SpriteHolder.scale.x = lerpf($SpriteHolder.scale.x, 1, 1 - pow(0.01, delta))
	$SpriteHolder.scale.y = lerpf($SpriteHolder.scale.y, 1, 1 - pow(0.01, delta))


	#Crush Check
	if test_move(transform, Vector2.ZERO) and not is_dead:
		#await get_tree().create_timer(0.15).timeout
		if ray_left.is_colliding() || ray_right.is_colliding() || ray_left_2.is_colliding() || ray_right_2.is_colliding():
			die_crush()


	#INFO Left and Right Movement

	if rightHold and leftHold and movementInputMonitoring and !is_dead:
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = -0.1
	elif rightHold and movementInputMonitoring.x and !is_dead:
		if velocity.x > maxSpeed or instantAccel:
			velocity.x = maxSpeed
		else:
			velocity.x += acceleration * delta
		if velocity.x < 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = -0.1
	elif leftHold and movementInputMonitoring.y and !is_dead:
		if velocity.x < -maxSpeed or instantAccel:
			velocity.x = -maxSpeed
		else:
			velocity.x -= acceleration * delta
		if velocity.x > 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = 0.1
				
	if velocity.x > 0:
		wasMovingR = true
	elif velocity.x < 0:
		wasMovingR = false
		
	if rightTap:
		wasPressingR = true
	if leftTap:
		wasPressingR = false
	
	if runningModifier and !runHold:
		maxSpeed = maxSpeedLock / 2
	elif is_on_floor(): 
		maxSpeed = maxSpeedLock
	
	if !(leftHold or rightHold):
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = 0
			
	#INFO Crouching
	if crouch:
		if downHold and is_on_floor():
			crouching = true
		elif !downHold and !rolling:
			crouching = false
			
	if !is_on_floor():
		crouching = false
			
	if crouching:
		maxSpeed = maxSpeedLock / 2
		col.scale.y = colliderScaleLockY / 2
		col.position.y = colliderPosLockY + (8 * colliderScaleLockY)
	elif !runningModifier or (runningModifier and runHold):
		maxSpeed = maxSpeedLock
		col.scale.y = colliderScaleLockY
		col.position.y = colliderPosLockY
		
	#INFO Rolling
	if canRoll and is_on_floor() and rollTap and crouching:
		_rollingTime(rollLength * 0.25)
		if wasPressingR and !(upHold):
			velocity.y = 0
			velocity.x = maxSpeedLock * rollLength
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(rollLength * 0.0625)
		elif !(upHold):
			velocity.y = 0
			velocity.x = -maxSpeedLock * rollLength
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(rollLength * 0.0625)
		
	if canRoll and rolling:
		#if you want your player to become immune or do something else while rolling, add that here.
		pass
			
	#INFO Jump and Gravity
	if velocity.y > 0:
		appliedGravity = gravityScale * descendingGravityFactor
	else:
		appliedGravity = gravityScale
	
	if is_on_wall() and !groundPounding and !is_dead and !is_on_floor():
	# Get wall normal to determine which side we're touching
		var wall_normal = get_wall_normal()
		# Check if pressing toward wall (wall_normal.x is 1 for right wall, -1 for left wall)
		
		#######control whether input is needed to use wall_sliding by commenting one of the following out
		var pressing_toward_wall = (wall_normal.x > 0 and leftHold and !downHold) or (wall_normal.x < 0 and rightHold and !downHold)
		#var pressing_toward_wall = (wall_normal.x > 0) or (wall_normal.x < 0)
	
		if pressing_toward_wall:
			wall_slide_buffer_timer = wall_slide_buffer_time
			was_wall_sliding = true
			appliedTerminalVelocity = terminalVelocity / wallSliding
			anim.play("slide")
			rat_slide.stream_paused = false
			if wallLatching and ((wallLatchingModifer and latchHold) or !wallLatchingModifer):
				appliedGravity = 0
			
				if velocity.y < 0:
					velocity.y += 50
				if velocity.y > 0:
					velocity.y = 0
				
				if wallLatchingModifer and latchHold and movementInputMonitoring == Vector2(true, true):
					velocity.x = 0
			elif wallSliding != 1 and velocity.y > 0:
				appliedGravity = appliedGravity / wallSliding
		else:
			appliedTerminalVelocity = terminalVelocity
			appliedGravity = gravityScale if velocity.y <= 0 else gravityScale * descendingGravityFactor
	elif !is_on_wall() and !groundPounding:
		if was_wall_sliding and wall_slide_buffer_timer > 0:
			appliedTerminalVelocity = terminalVelocity
			appliedGravity = gravityScale if velocity.y <= 0 else gravityScale * descendingGravityFactor
			wall_slide_buffer_timer -= delta  # Decrease buffer timer
			rat_slide.stream_paused = true
		else:
		# Buffer expired or wasn't wall sliding
			await get_tree().create_timer(groundPoundPause).timeout
			was_wall_sliding = false
			appliedTerminalVelocity = terminalVelocity
			appliedGravity = gravityScale if velocity.y <= 0 else gravityScale * descendingGravityFactor
			

	if gravityActive:
		if velocity.y < appliedTerminalVelocity:
			velocity.y += appliedGravity
		elif velocity.y > appliedTerminalVelocity:
				velocity.y = appliedTerminalVelocity
		
	if shortHopAkaVariableJumpHeight and jumpRelease and velocity.y < 0:
		velocity.y = velocity.y / jumpVariable
	
	if jumps == 1 and !is_dead:
		if !is_on_floor() and !is_on_wall():
			if coyoteTime > 0:
				coyoteActive = true
				_coyoteTime()
				
		if jumpTap and !is_on_wall():
			if coyoteActive:
				coyoteActive = false
				_jump()
			if jumpBuffering > 0:
				jumpWasPressed = true
				_bufferJump()
			elif jumpBuffering == 0 and coyoteTime == 0 and is_on_floor():
				_jump()
		elif jumpTap and is_on_wall() and !is_on_floor():
			if wallJump and !latched:
				_wallJump()
			elif wallJump and latched:
				_wallJump()
		elif jumpTap and is_on_floor():
			_jump()
			
		if is_on_floor():
			jumpCount = jumps
			if coyoteTime > 0:
				coyoteActive = true
			else:
				coyoteActive = false
			if jumpWasPressed:
				_jump()

	elif jumps > 1 and !is_dead:
		if is_on_floor():
			jumpCount = jumps
		if jumpTap and is_on_wall() and wallJump:
			_wallJump()
		elif jumpTap and jumpCount > 0:
			velocity.y = -jumpMagnitude
			jumpCount = jumpCount - 1
			_endGroundPound()
			
			
	#INFO dashing
	if is_on_floor() and !is_dead:
		dashCount = dashes
	if eightWayDash and dashTap and dashCount > 0 and !rolling and !is_dead:
		var input_direction = Input.get_vector("left", "right", "up", "down")
		var dTime = 0.0625 * dashLength
		_dashingTime(dTime)
		_pauseGravity(dTime)
		velocity = dashMagnitude * input_direction
		if (!rightHold and !leftHold and !downHold and !upHold) and wasMovingR:
			velocity.x = dashMagnitude
		elif (!rightHold and !leftHold and !downHold and !upHold) and !wasMovingR:
			velocity.x = -dashMagnitude
		dashCount += -1
		movementInputMonitoring = Vector2(false, false)
		_inputPauseReset(dTime)
	
	if twoWayDashVertical and dashTap and dashCount > 0 and !rolling and !is_dead:
		var dTime = 0.0625 * dashLength
		if upHold and downHold:
			_placeHolder()
		elif upHold:
			_dashingTime(dTime)
			_pauseGravity(dTime)
			velocity.x = 0
			velocity.y = -dashMagnitude
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
		elif downHold and dashCount > 0:
			_dashingTime(dTime)
			_pauseGravity(dTime)
			velocity.x = 0
			velocity.y = dashMagnitude
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
	
	if twoWayDashHorizontal and dashTap and dashCount > 0 and !rolling and !is_dead:
		var dTime = 0.0625 * dashLength
		if wasPressingR and !(upHold or downHold):
			velocity.y = 0
			velocity.x = dashMagnitude
			_pauseGravity(dTime)
			_dashingTime(dTime)
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
		elif !(upHold or downHold):
			velocity.y = 0
			velocity.x = -dashMagnitude
			_pauseGravity(dTime)
			_dashingTime(dTime)
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
			
	if dashing and velocity.x > 0 and leftTap and dashCancel:
		velocity.x = 0
	if dashing and velocity.x < 0 and rightTap and dashCancel:
		velocity.x = 0
	
	#INFO Corner Cutting
	if cornerCutting:
		if velocity.y < 0 and leftRaycast.is_colliding() and !rightRaycast.is_colliding() and !middleRaycast.is_colliding():
			position.x += correctionAmount
		if velocity.y < 0 and !leftRaycast.is_colliding() and rightRaycast.is_colliding() and !middleRaycast.is_colliding():
			position.x -= correctionAmount
			
	#INFO Ground Pound
	if groundPound and downTap and !is_on_floor() and !is_on_wall() and !is_dead:
		groundPounding = true
		gravityActive = false
		velocity.y = 0
		anim.play("falling")
		await get_tree().create_timer(groundPoundPause).timeout
		_groundPound()
	if is_on_floor() and groundPounding:
		_endGroundPound()
	
	
	
	# REPLACE THE PLATFORM VELOCITY SECTION IN _physics_process
	# Handle platform velocity
	var new_platform_velocity = Vector2.ZERO
	var was_on_platform = is_on_floor() and platform_velocity != Vector2.ZERO
	
	# Check for platform collision and get velocity
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision:
			var collider = collision.get_collider()
			var platform = collider.get_parent()
			if platform and platform is Node2D and "velocity" in platform:
				new_platform_velocity = platform.velocity
				new_platform_velocity.x = clamp(new_platform_velocity.x, -max_platform_velocity, max_platform_velocity)
				break
	
	# Handle getting on/off platform
	if is_on_floor():
		if new_platform_velocity != Vector2.ZERO:
			platform_velocity = new_platform_velocity
			is_tweening_velocity = false
			inherited_platform_velocity = Vector2.ZERO
	else:
		# Just left platform
		print("Debug - was_on_platform:", was_on_platform, 
	  " !is_tweening_velocity:", !is_tweening_velocity,
	  " platform_velocity:", platform_velocity)
		if was_on_platform and !is_tweening_velocity and platform_velocity != Vector2.ZERO:
			print("Starting tween with platform velocity: ", platform_velocity)
			# Store the velocity before setting it to zero
			var velocity_to_tween = platform_velocity
			platform_velocity = Vector2.ZERO
			tween_platform_velocity(velocity_to_tween)
		elif platform_velocity != Vector2.ZERO:
			platform_velocity = Vector2.ZERO
	
	# Calculate input velocity
	var input_velocity = Vector2.ZERO
	if rightHold and movementInputMonitoring.x and !is_dead:
		input_velocity.x += acceleration * delta
	elif leftHold and movementInputMonitoring.y and !is_dead:
		input_velocity.x -= acceleration * delta
	
	# Apply velocities
	if is_on_floor():
		velocity.x = platform_velocity.x + (input_velocity.x * 8)
	else:
		var combined_velocity = inherited_platform_velocity.x + (input_velocity.x * 8)
		velocity.x = combined_velocity
		print("Current inherited velocity: ", inherited_platform_velocity.x, " Combined velocity: ", combined_velocity)
	
	move_and_slide()
	
	if upToCancel and upHold and groundPound:
		_endGroundPound()
	
	# Handle platform drop-through
	###################if is_on_floor() and downHold and !is_dead:
		set_collision_mask_value(2, false)  # Disable collision with layer 2
		is_dropping_through = true
		await get_tree().create_timer(0.05).timeout
		set_collision_mask_value(2, true)   # Re-enable collision with layer 2
		is_dropping_through = false

	if velocity.x > 29 and is_on_floor():
		rat_walk.stream_paused = false
	elif velocity.x < -29.9 and is_on_floor():
		rat_walk.stream_paused = false
	else:
		rat_walk.stream_paused = true


func _bufferJump():
	await get_tree().create_timer(jumpBuffering).timeout
	jumpWasPressed = false

func _coyoteTime():
	await get_tree().create_timer(coyoteTime).timeout
	coyoteActive = false
	jumpCount += -1

	
func _jump():
	if jumpCount > 0:
		velocity.y = -jumpMagnitude
		jumpCount += -1
		jumpWasPressed = false
		
func _wallJump():
	var horizontalWallKick = abs(jumpMagnitude * cos(wallKickAngle * (PI / 180)))
	var verticalWallKick = abs(jumpMagnitude * sin(wallKickAngle * (PI / 180)))
	velocity.y = -verticalWallKick
	var dir = 1
	if wallLatchingModifer and latchHold:
		dir = -1
	if wasMovingR:
		velocity.x = -horizontalWallKick  * dir
	else:
		velocity.x = horizontalWallKick * dir
	if inputPauseAfterWallJump != 0:
		movementInputMonitoring = Vector2(false, false)
		_inputPauseReset(inputPauseAfterWallJump)
			
func _setLatch(delay, setBool):
	await get_tree().create_timer(delay).timeout
	wasLatched = setBool
			
func _inputPauseReset(time):
	await get_tree().create_timer(time).timeout
	movementInputMonitoring = Vector2(true, true)
	

func _decelerate(delta, vertical):
	if !vertical:
		if (abs(velocity.x) > 0) and (abs(velocity.x) <= abs(deceleration * delta)):
			velocity.x = 0 
		elif velocity.x > 0:
			velocity.x += deceleration * delta
		elif velocity.x < 0:
			velocity.x -= deceleration * delta
	elif vertical and velocity.y > 0:
		velocity.y += deceleration * delta


func _pauseGravity(time):
	gravityActive = false
	await get_tree().create_timer(time).timeout
	gravityActive = true

func _dashingTime(time):
	dashing = true
	await get_tree().create_timer(time).timeout
	dashing = false
	if !is_on_floor():
		velocity.y = -gravityScale * 10

func _rollingTime(time):
	rolling = true
	await get_tree().create_timer(time).timeout
	rolling = false	

func _groundPound():
	appliedTerminalVelocity = terminalVelocity * 10
	anim.play("falling")
	velocity.y = jumpMagnitude * 2
	
func _endGroundPound():
	groundPounding = false
	#anim.play("hit")
	appliedTerminalVelocity = terminalVelocity
	gravityActive = true

func _placeHolder():
	pass

func die_fire():
	dead_light.visible = true
	die_fire_sfx.play()
	var tree = get_tree()
	if !is_dead:
		velocity.x = 0
		velocity.y = -150
		is_dead = true
		#set_physics_process(false)
		set_process_input(false)
		anim.play("die")
		animation_player.play("dead_zoom")
		await tree.create_timer(0.7).timeout
		dead_particles.emitting = true
	if is_dead:
		dead_particles.emitting = true
	await tree.create_timer(4.0).timeout
	if tree and is_instance_valid(self):
		GameManager.increment_reset_count()
		tree.reload_current_scene()

func die_spikes():
	die_spikes_sfx.play()
	dead_light.visible = true
	if !is_dead:
		animation_player.play("dead_zoom")
		velocity.x = 0
		velocity.y = -100
		is_dead = true
		set_process_input(false)
		anim.play("die")
		await get_tree().create_timer(0.5).timeout
		gravityScale = 0
		#set_physics_process(false)

func die_crush():
	dead_light.visible = true
	die_spikes_sfx.play()
	if !is_dead:
		dead_light.visible = true
		animation_player.play("dead_zoom")
		velocity.x = 0
		is_dead = true
		gravityScale = 0
		set_process_input(false)
		anim.play("die")
		#set_physics_process(false)

func book_bounce():
	if !is_dead:
		velocity.y = -200
		
