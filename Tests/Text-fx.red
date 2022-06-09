Red [
    title: "Animation tests - text-fx"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

fnt1: make font! [name: "Brush Script MT" size: 28 color: 25.12.5.255]

text1: {Red’s ambitious goal is to build the world’s
first full-stack language, a language you can
use from system programming tasks,
up to high-level scripting through DSL.}

txt-bl: compose [
    id: 'test text: (text1) font: (fnt1)
    posXY: 20x20 sp-y: 0.75
    mode: 'chars from: 'center random: off
]

anim-block: compose [
    pen white fill-pen (papaya + 0.20.30) line-width 2 box 0x0 720x200
    
    st: start 2.0 duration 0.3 delay 0.02 ease 'ease-in-out-cubic
    text-fx txt-bl text-scale from 4.0 to 1.0 from 4.0 to 1.0
	on-start [print "starting text-scale 1"]
	on-exit [print "ending text-scale 1"]
    text-color from 25.12.5.255 to 25.12.5.0 
    
    sc: start 2 after st ends duration 0.3 delay 0.02 ease 'ease-in-out-cubic
    text-fx txt-bl text-color from 25.12.5.0 to 255.255.255.0 
    
    fade: start 0.1 after sc starts duration 0.3 delay 0.02 ease 'ease-in-out-cubic
    text-fx txt-bl text-color from 255.255.255.0 to 25.12.5.0
	on-start [print "starting text-color 1"]
	on-time [canvas/parent/text: form time]
	on-exit [print "ending text-color 1"]
    
    start 12.0 duration 0.3 delay 0.02 ease 'ease-in-out-cubic
    text-fx txt-bl text-move -20x0
	on-start [print "starting text-move 1"]
	on-exit [print "ending text-move 1"]

    text-color from 25.12.5.0 to 25.12.5.255 expires after 15
]
print "start"

view [
    title "Animate"
    canvas: base 600x200 black rate 67
    draw animate anim-block
]
