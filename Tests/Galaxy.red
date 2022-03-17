Red [
    title: "Animation tests - Galaxy"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

cx: 200 cy: 200

spin: function [p][
    r: sqrt p/x - cx ** 2 + (p/y - cy ** 2) ; distance from the center
    d: arctangent2 p/y - cy p/x - cx        ; angle 
    p/dir: 30 / r + d + 90                  ; 90 degrees for tangential + small correction
    p
]

stars: [
    number: 800
    emitter: function [][
        t: random 3             ; for the spiral arms 
        r: random 150           ; radius
        a: t * 120 + random 75  ; angle
        x: r * (cosine a) + cx  ; x oordinate
        y: r * (  sine a) + cy  ; y coordinate 
        s: 20                   ; speed
        c: 100.80.50.0          ; base color 
        c/:t: 100 + random 155  ; rgb channels
        c/4: to-integer r * 1.5 ; more transparent away from the center - affects only the halo
        compose [x: (x) y: (y) speed: (s) color: (c)]
    ]
    absorber: function [p][false] ; never respawn particles
    shapes: [[circle 0x0 3 fill-pen white circle 0x0 1]]
    forces: [spin]
]

d: [
    fill-pen black
    pen transparent
    box 0x0 400x400

    start 0.5 duration 25.0
    particles galaxy stars 
    
    fill-pen radial 255.190.120.0 255.150.80.40 255.127.20.150 255.0.0.255
    circle 200x200 from 20 to 180  ; expanding glow
]

print "Particles demo - Galaxy"

view [title "Spiral Galaxy" canvas: base 400x400 rate 67 draw animate d]
