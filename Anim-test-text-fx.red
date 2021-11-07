Red [
    title: "Animation tests - text-fx"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" style: 'bold size: 120 color: 225.255.205.0]

text1: {Lorem ipsum dolor sit amet, consectetur adipiscing elit.
In elementum orci neque, eu tincidunt nisl finibus sit amet.
Ut consectetur pellentesque consectetur. Donec non vulputate
nisi. Pellentesque sodales ut justo at commodo. Aliquam rutrum
dui in turpis lobortis luctus. Phasellus ultricies ipsum eu
dui bibendum finibus. In urna libero, ultrices sed rhoncus ut,
consequat et magna. Sed a tortor a ex sodales pretium.}

txt-bl: compose [id: 'test text: (text1) font: (fnt1) mode: 'chars from: 'left delay: 0.1 posXY: 150x150]

anim-block: [
    pen white fill-pen sky line-width 2
    box 0x0 600x400
    start 1.0 ease :ease-in-out-cubic
    translate from 0x0 to 0x200
    line 10x0 590x0
    text-fx txt-bl text-scale 0.5 0.5 ; WIP
]

view [
    title "Animate"
    canvas: base 600x400 black rate 120
    on-create [parse-anim anim-block face]
]
