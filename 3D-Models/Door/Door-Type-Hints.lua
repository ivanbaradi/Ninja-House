-- Options to relay door info
export type DoorOptions = {
	DoorSound: Sound, -- door sound object
	doorSoundId: number, -- asset Id for door sound
	canCollide: boolean -- parts are collidable. false, otherwise.
}

-- Definition of the door and animations
export type DoorDictionary = {
	Door: Model, -- door model
	OpenDoor: Tween, -- animation for opening door
	CloseDoor: Tween -- animation for closing door
}

return {}
