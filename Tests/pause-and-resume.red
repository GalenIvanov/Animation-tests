Red [
    title: "Animation tests - pausing and resuming animations"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

anim: compose/deep [
    fill-pen beige
	box 0x0 600x110
    fill-pen black

    line 30x35 565x35
	start 0 duration 5 ease 'ease-in-out-cubic
    translate black-box: from 30x25 to 550x25 speed 1.0[box 0x0 20x20]
	
	line 30x75 565x75
	fill-pen white
	start 0 duration 4 loop two-way forever
    translate white-box: from 30x65 to 550x65 speed 1.5 [box 0x0 20x20]
	
]

print "Pausing and resuming animations"

view [
    title "Animation speed"
	below
	base 600x110 beige rate 65 draw animate anim
	across
	button "Pause black" [pause-resume 'black-box]
	button "Pause white"  [pause-resume 'white-box]
]