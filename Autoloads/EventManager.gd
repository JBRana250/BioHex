extends Node

class Event:
	var event_name: String
	var recievers: Array[Callable] # Array containing the methods to call when the event is broadcast.
	var event_data: Dictionary # Dictionary with keys representing data name and values are the actual data values.
	func _init(_event_name):
		event_name = _event_name
		event_data = {}
		recievers = []

var LeavingScene: Event = Event.new("LeavingScene")
var EnemyDefeated: Event = Event.new("EnemyDefeated")
var CombatRoomCleared: Event = Event.new("CombatRoomCleared")

var Events: Array[Event] = [LeavingScene, EnemyDefeated, CombatRoomCleared]

func _get_event_from_name(event_name: String) -> Event:
	for event in Events:
		if event.event_name == event_name:
			return event
	print_debug("No event found with name " + event_name)
	return

func subscribe(event_name: String, function: Callable):
	var event = _get_event_from_name(event_name)
	event.recievers.append(function)

func unsubscribe(event_name: String, function: Callable):
	var event = _get_event_from_name(event_name)
	event.recievers.erase(function)

func broadcast_event(event_name: String, event_data: Dictionary):
	var event = _get_event_from_name(event_name)
	if event.recievers == []:
		print("no recievers")
		return
	for reciever in event.recievers:
		reciever.call(event_data)
