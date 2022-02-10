Red [
    title: "Animation tests - loops"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

bg-grid: collect [     ; background grid
    keep [pen white]
    repeat y  6 [keep compose [line (as-pair 0 y - 1 * 40) (as-pair 680 y - 1 * 40)]]
    repeat x 16 [keep compose [line (as-pair x - 1 * 40 0) (as-pair x - 1 * 40 440)]]
]

demo-font: make font! [size: 16]
 
anim: compose/deep [
    line-width 3 fill-pen white
    start 0.0 duration 3.0 loop forever
    translate from 0x0 to -40x-40 [(bg-grid)]
    
    font demo-font
    
    fly-in: start 0.0 duration 2.0 ease 'ease-in-out-elastic
    translate from 600x0 to 0x0 [
        text 20x20 "loop 3 times"
        box 230x20 580x50
        start 2.0 after fly-in starts duration 2.0 loop 3 times 
        translate from 0x0 to 320x0 on-exit [print "One-way finished"] on-start [print "One-way started"]
        box 235x25 255x45
    ]
    start 0.5 after fly-in starts duration 2.0 ease 'ease-in-out-elastic    
    translate from 600x0 to 0x0 [
        text 20x60 "loop two-way 3 times"
        box 230x60 580x90
        start 2.0 after fly-in starts duration 2.0 loop two-way 3 times
        translate from 0x0 to 320x0 on-exit [print "Two-way finished"] on-start [print "Two-way started"]
        box 235x65 255x85
    ]

    start 2.0 after fly-in starts ease 'ease-in-out-cubic 
    translate from 0x100 to 0x0 [
        line 20x130 580x130
        text 20x140 "Background: loop forever"
    ]    
]

print "Loops test"

view [
    canvas: base 600x180 beige rate 67
    draw animate anim
]
