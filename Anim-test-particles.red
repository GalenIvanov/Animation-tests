Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

ball: [
    [
        fill-pen 240.240.255.30
        line-width 5
        pen yello
        circle 0x0 15
    ]   
]

snow: copy [
        number:  10                ; how many particles
        emitter: [50x10 550x2100]     ; where particles are born - a box
        velocity: [0.1 2.0]          ; x and y components of particle's speed.  
        scatter: [1.2 2.5 0.0 14.55]  ; variation of velocity [left rigth up down]
        shapes: ball              ; a block of blocks (shapes to be used to render particles)
    ]

probe d: particle/init-particles 'test make particle/particle-base snow


tree: [
    shape [
        line 20x20 5x20 35x50 10x50 50x90 -50x90 -10x50 -35x50 -5x20 -20x20 0x0
	]
]

fnt: make font! [style: 'bold size: 250 color: gold]
fnt2: make font! [style: 'bold size: 250 color: black]
text1: "Happy New Year 2022! Happy reducing!"
bez-test: make block! 200
tt: 0.0
lim: 100
bez-pts: [200x1000 2300x-200 2800x600 3200x2200 5800x500]  ; 10x for sub-pixel precision

st-txt: 10000
draw-bl: make block! 10 * length? text1
draw-bl: text-along-curve/init 'text1 1.0 text1 fnt bez-pts 0.98

insert d compose/deep [
    fill-pen 80.80.150
    pen transparent
	box 0x0 600x400
    fill-pen 220.220.235
	shape [
	    move -10x250
	    curv  120x200 300x270 500x300 700x320
		line 700x510 -10x410 -10x350
	]
	translate 70x220 [scale 0.25 0.25 (tree)]
	translate 90x205 [scale 0.40 0.40 (tree)]
	translate 110x210 [scale 0.35 0.35 (tree)]
	translate 130x220 [scale 0.25 0.25 (tree)]
	translate 170x220 [scale 0.25 0.25 (tree)]
	
	fill-pen 245.245.255
	shape [
	    move -10x300
	    curv -10x350 280x280 550x320 700x320
		line 750x510 -10x410 -10x350
	]
	
	translate 0x80  [font fnt2 (draw-bl) translate -3x-3 font fnt (draw-bl)]
]	

view [
    base 600x400 draw (d) rate 120
    on-time [
		tm: to float! difference now/precise st-time
	    ;particle/update-particles 'test
        tween 'st-txt  10000 0 1.5 6.0 tm :ease-in-out-quint
        text-along-curve 'text1 st-txt / 10000.0
	]
]
