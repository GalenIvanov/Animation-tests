Red [
    title: "Animation tests - animation speed"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

bg-grid: collect [    ; background grid
    keep [pen white line-width 2]
    repeat y  6 [keep compose [line (as-pair 0 y - 1 * 40) (as-pair 680 y - 1 * 40)]]
    repeat x 16 [keep compose [line (as-pair x - 1 * 40 0) (as-pair x - 1 * 40 440)]]
]

demo-font: make font! [size: 16]
 
anim: compose/deep [
    start 0 duration 3 loop forever
    translate from 0x0 to -40x-40 [(bg-grid)]
    
    fill-pen black
    start 0 duration 4 loop two-way forever
    font demo-font
    
    text 20x20 "Speed 0.5" line 150x35 570x35
    translate from 150x25 to 550x25 speed 0.5 [box 0x0 20x20]
    
    text 20x60 "Speed 1.0" line 150x75 570x75
    translate from 150x65 to 550x65 [box 0x0 20x20]
    
    text 20x100 "Speed 2.0" line 150x115 570x115
    translate from 150x105 to 550x105 speed 200% [box 0x0 20x20]
    
    start 0 duration 3
    text 20x140 "Speed 2.0" line 150x155 570x155
    text 20x160 "no loop"
    translate from 150x145 to 550x145 speed 200% [box 0x0 20x20]
]

view [title "Animation speed" base 600x200 beige rate 67 draw animate anim]
