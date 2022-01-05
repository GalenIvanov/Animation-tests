Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

random/seed now

ball: [
    [
        fill-pen 235.240.255.50
        pen transparent
        circle 0x0 25
    ]   
]

dot: [[box 0x0 20x20] [rotate 45.0 [box 0x0 40x40]] ]

random-dir: func [dir speed][
    dir: dir + 0.1 - random 0.2
    return reduce [dir speed]
]

box-limit: func [x y /local c][
    c: false
    if y > 350 [
        c: true
        y: 50
    ]    
 reduce [c x y]
]

circle-limit: func [x y /local c][
    c: false 
    if 120 < sqrt x - 300 ** 2 + (y - 200 ** 2) [
        c: true
        x: 300.0
        y: 200.0
    ]
    reduce [c x y]
] 

snow: compose [
    number:    200                    ; how many particles
    emitter:   [50x50 150x350]      ; where particles are born - a box
    direction: 90.0                    ; degrees
    dir-rnd:   3.0                  ; random spread of direction, symmetric
    speed:     10.0                   ; particle base speed
    speed-rnd: 5.0      
    shapes:    ball                   ; a block of blocks (shapes to be used to render particles)
    forces:    []
    limits:   :box-limit
]

sphere: [
    number:    300                    ; how many particles
    emitter:   [300x200 300x200]      ; where particles are born - a box
    direction: 0.0                    ; degrees
    dir-rnd:   360.0                  ; random spread of direction, symmetric
    speed:     5.0                   ; particle base speed
    speed-rnd: 10.0      
    shapes:    dot                   ; a block of blocks (shapes to be used to render particles)
    forces:    [random-dir gravity]
    limits:   :circle-limit
]
    
d: particle/init-particles 'test make particle/particle-base snow

insert d compose/deep [
    fill-pen black
    pen transparent
    box 0x0 600x400
    scale 0.1 0.1
]    

append d [fill-pen papaya]
append d particle/init-particles 'sphere make particle/particle-base sphere
append d [fill-pen transparent pen papaya line-width 100 circle 3000x2000 1250]

print "start"

view [
    base 600x400 draw (d) rate 120
    on-time [
        tm: to float! difference now/precise st-time
        particle/update-particles 'test
        particle/update-particles 'sphere
    ]
]
