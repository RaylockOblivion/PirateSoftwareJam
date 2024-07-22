extends Node2D

enum interest_state{
	NONE,
	
	PASSIVE,
	ALERTED_BY_ACTION
}

@export var state : interest_state = interest_state.PASSIVE
@export var range : float = 200
@export var active : bool = true
