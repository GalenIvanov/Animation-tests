Red []

#include %animate.red

bleach: func [x] [white * 0.7 + (x * 0.3)]
rotation: func [dir spd] [
	;; to rotate tangentially I need coordinate pair :(
	;; have to randomly choose constants until something almost works
	reduce [dir - 1.5 spd * 0.9975]
]
sc: 1.0
pspec: compose/deep [ 
	number: 1000
	; emitter: [-5x-5 5x5]
	emitter: [-25x-400 25x-300]
	speed: 50.0
	speed-rnd: 0
	direction: 180
	shapes: [
		[pen (bleach red    ) scale 0.5 0.5 [rotate (random 90) [line -2x0 2x0 line 0x-2 0x2]]]
		[pen (bleach blue   ) scale 0.5 0.5 [rotate (random 90) [line -2x0 2x0 line 0x-2 0x2]]]
		[pen (bleach green  ) scale 0.5 0.5 [rotate (random 90) [line -2x0 2x0 line 0x-2 0x2]]]
		[pen (bleach yellow ) scale 0.5 0.5 [rotate (random 90) [line -2x0 2x0 line 0x-2 0x2]]]
		[pen (bleach cyan   ) scale 0.5 0.5 [rotate (random 90) [line -2x0 2x0 line 0x-2 0x2]]]
		[pen (bleach magenta) scale 0.5 0.5 [rotate (random 90) [line -2x0 2x0 line 0x-2 0x2]]]
		[pen (bleach white  ) scale 0.5 0.5 [rotate (random 90) [line -2x0 2x0 line 0x-2 0x2]]]
	]
	limits: [
		case [
			within? as-pair x y -1000x-400 2000x120 [1 < random 1.2]
			50 > d: distance? 0x-130 as-pair x y [0.5 ** d > random 1.0]
		]
	]
	; new-coords: [x: (-10 + random 20) / sc: sc / 1.001 y: (-200 + random 50) / sc]
	new-coords: [x: -10 + random 50  y: -350 + random 50]
	forces: [rotation]
	; forces: [drag2 rotation]
]
view compose/deep/only [
	base 500x400 black rate 34 on-create [
		animate [
			translate 250x280
			; start 0 duration 600 ease :ease-linear loop forever
				; translate 250x250 ;rotate from 0.0 to -360.0
			;; start -60 - would need to emulate past events to fill this
			start -60 duration 600 ease :ease-out-expo
				; scale from 0.1 to 0 from 0.1 to 0
				; scale from 1.0 to 0.0 from 1.0 to 0.0
				particles wtf-is-this-for? pspec
		] face
	]
]
