Red [
    title: "Animation tests - pen and fill-pen"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

img: load %red-logo.png

fill: [
    fill-pen sky 
	pen sky
    box 0x0 100x100
	fill-pen radial red from white to black teal red from 0x0 to 120x80 40 repeat
	line-width 15
	start 0 duration 5 loop two-way forever
	pen radial red from orange to black from black to red red from 100x50 to -100x50 60 repeat
	circle 50x50 40
	]
	

anim-block: compose/deep [
    start 1 duration 3 loop two-way forever
    
	;fill-pen from red to black
	;fill-pen linear from red to blue from green to papaya from white to black from -100x0 to 100x0 200x0
	;fill-pen radial red from white to black teal red from 0x0 to 120x80 40 repeat
	;fill-pen diamond red white blue red  ; doesn't seem correct
    ;fill-pen bitmap img ;500x500 800x800
	;circle 400x400 380 
	
	fill-pen pattern 100x100 [(fill)]
	circle 300x300 280 
] 

print "start"

view compose [
    canvas: base 600x600 beige rate 60
    on-create [animate anim-block face]
]
