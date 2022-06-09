Red [
    title: "Animation tests - New year demo"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

tree: [
    shape [line 20x20 5x20 35x50 10x50 50x90 -50x90 -10x50 -35x50 -5x20 -20x20 0x0]
]

random-dir: function [p] [
    p/color: 255.255.255.255
    p/color/4: tween 255 0 p/t 'ease-in-out-cubic
    p/dir: p/dir + 1.0 - random 2.0
    p
]

snow-obj: compose [
    number:  800
    emitter: function [][
        x: random 600
        y: -100 + random 500
        s: 20.0 + random 15.0
        sc: 0.5 + random 1.0
        compose [x: (x) y: (y) dir: 90 speed: (s) scale-x: (sc) scale-y: (sc)]
    ]
    shapes: [[circle 0x0 2]]
    forces: [random-dir]
    ffd: 0.0
    absorber: function [p][p/y > 395]
]

fnt1: make font! [style: 'bold size: 23 color: gold]
fnt2: make font! [style: 'bold size: 23 color: black]

text1: "Happy New Year 2022! Happy reducing!"
bez-pts: [20x100 230x-20 280x60 320x220 580x50 680x-30]
happy-new-year: [data: text1 font: fnt2 curve: bez-pts space-x: 1.00]

scene: compose/deep [
    fill-pen 80.100.180
    pen transparent
    box 0x0 600x400
    fill-pen 230.235.245
    
    shape [
        move -10x250
        curv 120x200 300x270 500x300 700x320
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
    
    start 0.0 duration 20.0 
    particles snow snow-obj expires after 10
    
    start 2.0 duration 5.0 ease 'ease-in-out-cubic
    translate 0x80 [
        font fnt2
        curve-fx greeting-b-l happy-new-year from 1.0 to 0.0 expires after 8
        translate -3x-3 
        font fnt1
        curve-fx greeting-l happy-new-year from 1.0 to 0.0  expires after 8
    ]    
    start 10.0 duration 5.0 ease 'ease-in-out-cubic
    translate 0x80 [
        font fnt2
        curve-fx greeting-b-r happy-new-year from 0.0 to 1.0 expires after 18
        translate -3x-3 
        font fnt1
        curve-fx greeting-r happy-new-year from 0.0 to 1.0 expires after 18
    ]
    
    start 18.0 duration 2.0 ease 'ease-in-out-cubic
    fill-pen from 0.0.0.255 to 0.0.0.0 on-exit [quit]
    box 0x0 600x400
]

view [
    canvas: base 600x400 rate 67
    draw animate scene
]
