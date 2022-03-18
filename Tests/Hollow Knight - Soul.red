Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

; Remake of an effect from the Hollow Knight game

#include %../Animate.red

cx: 200
cy: 300
size: 30

soar: func [p][
    p/dir: p/dir + 1.0 - random 2.0           
    p/color/4: tween 255 0 p/t / 0.75 'ease-in-out-cubic
    if p/t > 2.0 [
        p/scale-x: p/scale-x * 2.0 / p/t
        p/scale-y: p/scale-y * 2.0 / p/t
    ]    
    p
]

blobs: [
    number: 12
    emitter: function [][
        x: cx - size + random 2 * size
        y: cy - size + random 3 * size
        d: 268 + random 4.0 
        s: 30.0 + random 30.0
        c: 0.0.0.255
        sc: 1.0 + random 1.0
        t: random 2.5
        compose [x: (x) y: (y) dir: (d) speed: (s) color: (c) scale-x: (sc) scale-y: (sc) t: (t)]
    ]
    absorber: function [p][p/t > 2.5]
    shapes: [[circle 0x0 4]]
    forces: [soar]
]

d: [
    fill-pen white
    pen transparent
    box 0x0 400x400

    start 0.0 duration 25.0
    particles soul blobs
]

print "Particles demo"

view [canvas: base 400x400 rate 67 draw animate d]