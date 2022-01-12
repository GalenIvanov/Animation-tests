Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

ball: [
    [
        fill-pen 235.240.255.50
        pen transparent
        circle 0x0 2  ; should be scaled automatically!!!
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
    number:     200
    emitter:    [50x50 150x350]
    direction:  90.0    
    dir-rnd:    0.0
    speed:      10.0
    speed-rnd:  5.0
    shapes:     ball
    forces:     [wind]
    limits:     [y > 350 x < 50]
    new-coords: [
        t: random 4
        either t < 3 [
            x: 150.0
            y: 50.0 + random 300.0
        ][
            x: 50 + random 100.0
            y: 50.0
        ]
    ]
]

burst: [
    number:     300                
    emitter:    [300x200 300x200]  
    direction:  0.0                
    dir-rnd:    360.0              
    speed:      10.0                
    speed-rnd:  10.0      
    shapes:     sparks             
    forces:     [gravity]
    limits:     [120.0 < sqrt x - 300.0 ** 2 + (y - 200.0 ** 2)]
    new-coords: [x: 300.0 y: 200.0]
]

rocket: [
    number:     20
    emitter:    [450x60 540x320]
    direction:  270.0
    dir-rnd:    0.0
    speed:      8.0
    speed-rnd:  8.0
    shapes:     ship
    limits:     [x > 550 y < 60]
    new-coords: [x: 455.0 + random 90.0 y: 340.0]
]

fnt: make font! [size: 15]

d: [
    fill-pen black
    pen transparent
    box 0x0 600x400
    
    start 1.0 duration 5.0 delay 2.0
    
    particles test motes
    line-width 8 pen white fill-pen transparent
    box 50x50 150x350
    
    pen transparent fill-pen papaya
    particles vulcano burst
    fill-pen transparent pen papaya  circle 300x200 125
    
    font fnt
    particles fleet rocket 
    pen sky box 460x50 570x350
]

view [
    canvas: base 600x400 rate 120
    on-create [parse-anim d face]
]
