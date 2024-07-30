extends CustomState
class_name StateMachine

var host = get_parent()
var state_machine = self

signal state_changed(state_name: String)

@export var disabled:bool
@export var default_state: CustomState
var curr_state: CustomState

func _ready():
	curr_state=default_state
	curr_state.on_start()

func on_end():
	curr_state.on_end()

func _physics_process(delta):
	curr_state.update(delta)

func _process(delta):
	curr_state.process_update(delta)

func update(delta):
	curr_state.update(delta)

func process_update(delta):
	curr_state.process_update(delta)

func change_state(new_state_name: String):
	var new_state:CustomState = get_node_or_null(new_state_name)
	if !is_instance_valid(new_state):
		if not new_state_name:
			printerr('Cannot chang to ', new_state_name,' in',
			 host.name,' switching to ', default_state.name,' instead')
			change_state(default_state.name)
			return
	
	if new_state == curr_state:
		return
	
	set_state(new_state)

func engage_tree():
	state_machine.set_state(self)
	set_state(default_state)

func exit_tree():
	state_machine.change_state("")

func set_state(state:CustomState):
	curr_state=state
