Red [
    title: "Animation tests - text-fx"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Brush Script MT" size: 28 color: 25.12.5.255]

text1: {Red’s ambitious goal is to build the world’s
first full-stack language, a language you can
use from system programming tasks,
up to high-level scripting through DSL.}

txt-bl: compose [
    id: 'test text: (text1) font: (fnt1)
    posXY: 20x20 sp-y: 0.75
    mode: 'chars from: 'center
]

anim-block: compose [
    pen white fill-pen (papaya + 0.20.30) line-width 2 box 0x0 720x200
    
    st: start 1.0 duration 0.3 delay 0.02 ease :ease-in-out-cubic
    text-fx txt-bl text-scale from 4.0 to 1.0 from 4.0 to 1.0
    text-color from 25.12.5.255 to 25.12.5.0
    
    sc: start 1.0 after st ends duration 0.3 delay 0.03 ease :ease-in-out-cubic
    text-fx txt-bl text-color from 25.12.5.0 to 255.255.255.0
    
    fade: start 0.1 after sc starts duration 0.3 delay 0.03 ease :ease-in-out-cubic
    text-fx txt-bl text-color from 255.255.255.0 to 25.12.5.0
    
    start when fade ends duration 0.3 delay 0.02 ease :ease-in-out-quad
    text-fx txt-bl text-move -100x0 
    text-color from 25.12.5.0 to 25.12.5.255
]

view [
    title "Animate"
    canvas: base 600x200 black rate 120
    on-create [parse-anim anim-block face ]
]
