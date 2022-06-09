Red [
    title: "Animation tests - pausing and resuming animations"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

fnt1: make font! [name: "Verdana" size: 10 color: black]

anim: compose/deep [
    fill-pen beige
    box 0x0 600x140
    fill-pen black

    font fnt1
    text 30x25 "No loop"
    line 30x55 565x55
    start 1 duration 10 ; ease 'ease-in-out-cubic
    translate black-box: from 30x45 to 550x45 speed 2.5 [box 0x0 20x20]
    
    text 30x75 "Loop two-way forever"
    line 30x105 565x105
    fill-pen white
    start 0 duration 4.0 loop two-way forever
    translate white-box: from 30x95 to 550x95 speed 2.5 [box 0x0 20x20]
]

states: ["black" on "white" on]

change-caption: func [type][
    rejoin [pick ["Pause " "Resume "] states/:type: not states/:type type]
]

print "Pausing and resuming animations"

view [
    title "Pausing and resuming animations"
    below
    base 600x140 beige rate 67 draw animate anim
    across
    button "Pause black" [
        toggle-animation 'black-box
        face/text: change-caption "black"
    ] 
    button "Pause white" [
        toggle-animation 'white-box
        face/text: change-caption "white"
    ]
]
