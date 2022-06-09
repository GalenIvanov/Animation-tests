Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

t-sc: 0.5  ; time-scale

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
    [fill-pen yello box 0x0 2x2]
    [fill-pen 255.120.10 rotate 45.0 box 0x0 4x4]
]

ship: compose/deep [[rotate -45.0 [text 0x0 (form to-char 128640)]]]  ; U+1F680     

wind: function [p][
    if p/dir < 135 [p/dir: 135 + p/dir / 2.0]
    p/dir: p/dir + 2.0 - random 4.0
    p
]

gravity: function [p][
    vx: p/speed * cosine p/dir
    vy: p/speed *   sine p/dir
    vy: 10.0 * t-sc + vy  ; adjusted by the time-scale (animation speed)
    p/dir: arctangent2 vy vx
    p/speed: sqrt vx * vx + (vy * vy)
    p
]

motes: compose [
    number: 100
    emitter: function [][
        t: random 4
        either t < 3 [
            x: 150.0
            y: 50.0 + random 300.0
        ][
            x: 50 + random 100.0
            y: 50.0
        ]
        d: 90.0
        s: 50.0 + random 10.0
        compose [x: (x) y: (y) dir: (d) speed: (s)]
    ]
    absorber: function [
        {Returns true if the particle needs to be re-emitted}
        p
    ][
        to-logic any [p/x < 50 p/x > 150 p/y < 50 p/y > 350]
    ]
    ffd:    4.0     ; how many seconds to fast forward the particles animation
    shapes: ball
    forces: [wind]
]

burst: [
    number:  300                
    emitter: function [][
       x: 300.0
       y: 150.0
       d: random 360.0
       s: 40.0 + random 15.0
       compose [x: (x) y: (y) dir: (d) speed: (s) t: (random 8.0)]
    ]
    absorber: function [p][
        to-logic any [
            p/t > 5.0
            120.0 < sqrt p/x - 300.0 ** 2 + (p/y - 200.0 ** 2)
        ]    
    ]
    ffd: 5.0
    shapes: sparks               
    forces: [gravity]
]

rocket: [
    number:  20
    emitter: function [][
       x: 450.0 + random 90.0
       y: 340.0
       d: 270.0
       s: 50.0 + random 50.0
       compose [x: (x) y: (y) dir: (d) speed: (s)]
    ]
    absorber: function [p][p/y < 60]
    shapes: ship
    ffd: 5.0
]

fnt: make font! [size: 15]

states: ["left" on "center" on "right" on]

change-caption: func [type][
    rejoin [pick ["Pause " "Resume "] states/:type: not states/:type type]
]

d: compose [
    fill-pen black
    pen transparent
    box 0x0 600x400
    
    start 0.0 duration 5.0 delay 2.0
    
    particles test motes expires after 6 speed 1.0 on-start [print "Motes"] on-exit [print "Motes finished"]
    line-width 8 pen white fill-pen transparent
    box 50x50 150x350
    
    pen transparent fill-pen papaya
    particles vulcano burst speed (t-sc) expires after 6 on-start [print "Vulcano"] on-exit [print "Vulcano finished"]
    fill-pen transparent pen papaya circle 300x200 125
    
    font fnt
    particles fleet rocket on-start [print "Rockets"] on-exit [print "Rockets finished"] expires after 6 speed 2.0
    pen sky box 460x50 570x350
]

print "Particles demo"

view [
    below
    canvas: base 600x400 rate 67
    draw animate d
    across pad 70x0 space 125x0
    button "Pause left" [
        toggle-animation 'test
        face/text: change-caption "left"
    ]
    button "Pause center" [
        toggle-animation 'vulcano
        face/text: change-caption "center"
    ]
    button "Pause right" [
        toggle-animation 'fleet
        face/text: change-caption "right"
    ]
]
