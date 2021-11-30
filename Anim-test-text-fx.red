Red [
    title: "Animation tests - text-fx"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" style: 'bold size: 120 color: 50.50.25.0]

text1: {Lorem ipsum dolor sit amet, consectetur adipiscing elit.
In elementum orci neque, eu tincidunt nisl finibus sit amet.
Ut consectetur pellentesque consectetur. Donec non vulputate
nisi. Pellentesque sodales ut justo at commodo.}

txt-bl: compose [id: 'test text: (text1) font: (fnt1) posXY: 10x50
                 mode: 'words from: 'left random: off]

anim-block: [
    pen white fill-pen sky line-width 2
    box 0x0 600x200
    st: start 0.0 duration 0.3 delay 0.1 ease :ease-in-out-cubic
    text-fx txt-bl text-scale from 0.0 to 1.0 1.0 ;from 1.0 to 1.0
    bx: start when st ends duration 2.0 ;ease :ease-linear
    fill-pen 255.255.105.30
    box 0x0 from 0x200 to 600x200
    start 1.0 after st ends duration 0.3 delay 0.1 ease :ease-in-out-cubic
    text-fx txt-bl text-scale from 1.0 to 0.0 1.0 ;from 1.0 to 1.0
    text-color from 50.50.25.0 to 255.255.255.0
]

view [
    title "Animate"
    canvas: base 600x200 black rate 120
    on-create [parse-anim anim-block face ]
]
