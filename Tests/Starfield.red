Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

accelerate: func [p][
    p/speed: p/speed * 1.1
    p/color/4: to-integer 85 / p/t
    p/scale-x: p/t / 0.5
    p/scale-y: p/t / 0.5
    p
]

stars: [
    number:  600
    emitter: has [x y d s c][
        x: random 600.0
        y: random 400.0
        d: arctangent2 y - 200 x - 300
        s: 20.0 + random 10.0
        compose [x: (x) y: (y) dir: (d) speed: (s)]
    ]
    absorber: function [x y d s][to-logic any [x < 0 x > 600 y < 0 y > 400]]
    ffd: 2.0
    shapes: [[circle 0x0 1]]
    scale-x: 0.1
    scale-y: 0.1
    color: [200.200.200.255 + random 55.55.55.0]
    forces: [accelerate]
]

d: [
    fill-pen black
    pen transparent
    box 0x0 600x400

    start 0.0 duration 15.0 delay 2.0
    particles test stars
]

print "Particles demo - Starfield"

view [
    canvas: base 600x400 rate 67
    draw animate d
]