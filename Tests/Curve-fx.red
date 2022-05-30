Red [
    title: "Animation dialect tests - text-along-curve"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

fnt1: make font! [name: "Verdana" size: 16 color: black]
red-text: "Red is a next-gen programming language, strongly inspired by REBOL"
bez-pts: [50x40 370x-120 350x100 250x400 620x200] 

bez-test: head insert copy bez-pts 'bezier

upper-triangle: [pen red fill-pen yello polygon 0x-15 10x-35 -10x-35]
lower-triangle: [pen red fill-pen yello polygon 0x15 10x35 -10x35]
draw-block: reduce [upper-triangle lower-triangle]

red-info: [data: red-text font: fnt1 curve: bez-pts space-x: 0.98]
shapes: [data: draw-block curve: bez-pts space-x: 0]

lerp: func [x][x]

states: ["info" on "pointer" on]

change-caption: func [type][
    rejoin [pick ["Pause " "Resume "] states/:type: not states/:type type]
]

block: compose/deep [
    font fnt1
    start 0.5 duration 0.5 ease :lerp
    translate 0x50
    line-cap round 
    stroke-path b1 (bez-test) width 35 color 80.108.142.0 ;expires after 7
    
    line-width 3
    start 2.0 duration 4.0 delay 1.0 ease 'ease-in-out-cubic
    curve-fx info red-info from 1.0 to 0.0 expires after 6 speed 1.25
    on-start [print "starting"]
    on-time [bb/parent/text: form time]
    on-exit [print "Effect finished"]
    curve-fx pointer shapes from 1.0 to 0.0 expires after 6 
    on-start [print "Block mode"]
]

print "curve-fx test"

view [
    title "Animate"
    below
    bb: base 650x350 black rate 67 draw animate block
    across
    button "Pause info" [
        toggle-animation 'info
        face/text: change-caption "info"
    ]
    button "Pause pointer" [
        toggle-animation 'pointer
        face/text: change-caption "pointer"
    ]        
    
]
