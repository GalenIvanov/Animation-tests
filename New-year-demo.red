Red [
    title: "Animation tests - New year demo"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

tree: [
    shape [line 20x20 5x20 35x50 10x50 50x90 -50x90 -10x50 -35x50 -5x20 -20x20 0x0]
]

flakes: [
    [
        fill-pen 235.240.255.50
        pen transparent
        circle 0x0 2
    ]
    [
        fill-pen 235.250.255.100
        pen transparent
        circle 0x0 3
    ]
    [text 0x0 "❅"]
]

random-dir: func [dir speed][
    dir: dir + 1.0 - random 2.0
    reduce [dir speed]
]

snow-obj: compose [
    number:     1000
    emitter:    [0x0 600x400]
    direction:  90.0    
    dir-rnd:    0.0
    speed:      10.0
    speed-rnd:  5.0
    shapes:     flakes
    forces:     [random-dir gravity]
    limits:     [y > 400]
    new-coords: [x: random 600.0 y: -10.0]
]

fnt-snow: make font! [style: 'bold size: 10 color: 240.240.240.80]
fnt1: make font! [style: 'bold size: 23 color: gold]
fnt2: make font! [style: 'bold size: 23 color: black]

text1: "Happy New Year 2022! Happy reducing!"
bez-pts: [20x100 230x-20 280x60 320x220 580x50 680x-30]
happy-new-year: [data: text1 font: fnt2 curve: bez-pts space-x: 1.00]

scene: compose/deep [
    fill-pen 80.100.180
    pen transparent
    box 0x0 600x400
    fill-pen 220.220.235
    shape [
        move -10x250
        curv  120x200 300x270 500x300 700x320
        line 700x510 -10x410 -10x350
    ]
    translate  70x220 [scale 0.25 0.25 (tree)]
    translate  90x205 [scale 0.40 0.40 (tree)]
    translate 110x210 [scale 0.35 0.35 (tree)]
    translate 130x220 [scale 0.25 0.25 (tree)]
    translate 170x220 [scale 0.25 0.25 (tree)]
    
    fill-pen 245.245.255
    shape [
        move -10x300
        curv -10x350 280x280 550x320 700x320
        line 750x510 -10x410 -10x350
    ]
    
    font fnt-snow
    start 0.0 duration 20.0 
    particles snow snow-obj
    
    start 2.0 duration 5.0 ease :ease-in-out-cubic
    translate 0x80 [
        font fnt2
        curve-fx greeting-b happy-new-year from 1.0 to 0.0
        translate -3x-3 
        font fnt1
        curve-fx greeting happy-new-year from 1.0 to 0.0
    ]    
    start 10.0 duration 5.0 ease :ease-in-out-cubic
    translate 0x80 [
        font fnt2
        curve-fx greeting-b happy-new-year from 0.0 to 1.0
        translate -3x-3 
        font fnt1
        curve-fx greeting happy-new-year from 0.0 to 1.0
    ]
    
    start 18.0 duration 2.0 ease :ease-in-out-cubic
    fill-pen from 0.0.0.255 to 0.0.0.0
    box 0x0 600x400
]

view [
    base 600x400 rate 120
    on-create [parse-anim scene face]
]
