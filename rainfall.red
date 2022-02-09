Red []

#include %animate.red

~size: system/view/screens/1/size * 6x7 / 10
~scale: ~size * 10 / 1000x1000
; drop: draw 10x20 [shape [move 5x0 'line -5x20 'arc 10x0 6 10 0 large close]]
drop: [shape [move 5x0 line 0x20 arc 10x20 6 10 0 large close]]
layers: 5
drops: collect [repeat i layers [
	i: i + 1
	keep/only compose/only [scale (1 / i) (1 / i) (drop)]
]]
data: collect [repeat i layers [
	keep b: to [] object compose/deep/only [
		number: 30 * i
		emitter: [0x0 (~size * 1x-1)]
		speed: 400 / (i + 1)
		direction: 85 + random 10
		shapes: reduce [(drops/:i)]
		limits: [y > (~size/y * (1 / i + 2) / 3)]
		new-coords: [x: random ~size/x y: 0]
		; new-coords: [p: random (~size * 1x0) x: p/x y: p/y]
	]
	set to word! rejoin ['data i] b 
]]
view compose/deep/only [
	base ~size white rate 66 on-create [
		animate [
			start 0 duration 60 ease :ease-in-expo
				; [box 10x10 from 10x70 to 70x70]
				; image from 0x0 to 100x0 drop
				(collect [repeat i layers [keep reduce [
					'particles to word! rejoin ['value-with-zero-value i] to word! rejoin ['data i]
					; 'on-exit [print "111"]
				]]])
		] face
	]
]
quit
