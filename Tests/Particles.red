Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

ball: [
    [
        fill-pen 235.240.255.50
        pen transparent
        circle 0x0 2
    ]
    [
        fill-pen 235.250.255.80
        pen transparent
        circle 0x0 4
    ]       
]

sparks: [
    [box 0x0 2x2]
    [fill-pen 255.120.10 rotate 45.0 box 0x0 4x4]
]

ship: compose/deep [[rotate -45.0 [text 0x0 (form to-char 128640)]]]  ; U+1F680  

wind: func [dir speed][
    if dir < 135 [dir: 135 + dir / 2.0]
    dir: dir + 2.0 - random 4.0
    reduce [dir speed]
]

motes: compose [
    number: 100
    emitter: has [
        {Intializes the spatial properties of a particle}
        x y d s ; x and y coordinates, direction and speed
    ][
        t: random 4
        either t < 3 [
            x: 150.0
            y: 50.0 + random 300.0
        ][
            x: 50 + random 100.0
            y: 50.0
        ]
        d: 90.0
        s: 1.5 + random 0.2
        compose [x: (x) y: (y) dir: (d) speed: (s)]
    ]
    absorber: function [
        {Returns true if the particle needs to be re-emitted}
        x y d s ; x and y coordinates, direction and speed of the particle
    ][
        to-logic any [x < 50 x > 150 y < 50 y > 350]
    ]
    rewind:     120  ; how many times to update the particles immediately after initialization
    shapes:     ball
    forces:    [wind]
]

burst: [
    number:     300                
    emitter:    [300x200 300x200] 
    emitter: has [x y d s][
       x: 300.0
       y: 150.0
       d: random 360.0
       s: 0.5 + random 0.5
       compose [x: (x) y: (y) dir: (d) speed: (s)]
    ]
    absorber: function [x y d s][120.0 < sqrt x - 300.0 ** 2 + (y - 200.0 ** 2)]
    rewind: 150
    shapes:     sparks             
    forces:     [gravity]
]

rocket: [
    number:  20
    emitter: has [x y d s][
       x: 450.0 + random 90.0
       y: 340.0
       d: 270.0
       s: 1.8 + random 1.5
       compose [x: (x) y: (y) dir: (d) speed: (s)]
    ]
    absorber: function [x y d s][y < 60]
    shapes: ship
    rewind: 100
]

fnt: make font! [size: 15]

d: [
    fill-pen black
    pen transparent
    box 0x0 600x400
    
    start 0.0 duration 5.0 delay 2.0
    
    particles test motes expires after 6 on-start [print "Motes"] on-exit [print "Motes finished"]
    line-width 8 pen white fill-pen transparent
    box 50x50 150x350
    
    pen transparent fill-pen papaya
    particles vulcano burst expires after 6 on-start [print "Vulcano"] on-exit [print "Vulcano finished"]
    fill-pen transparent pen papaya  circle 300x200 125
    
    font fnt
    particles fleet rocket expires after 6 on-start [print "Rockets"] on-exit [print "Rockets finished"]
    pen sky box 460x50 570x350
]

print "Particles demo"

view [
    canvas: base 600x400 rate 67
    draw animate d
]
