Red [
    title: "Animation tests - text-fx"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" size: 130 color: 85.105.155.0]

text1: {Lorem ipsum dolor sit amet, consectetur adipiscing elit.
In elementum orci neque, eu tincidunt nisl finibus sit amet.
Ut consectetur pellentesque consectetur. Donec non vulputate
nisi. Pellentesque sodales ut justo at commodo. Aliquam rutrum
dui in turpis lobortis luctus. Phasellus ultricies ipsum eu
dui bibendum finibus. In urna libero, ultrices sed rhoncus ut,
consequat et magna. Sed a tortor a ex sodales pretium.}

txt-bl: compose [id: 'test text: (text1) font: (fnt1) mode: 'words from: 'bottom delay: 0.1 random: off]

anim-block: [
    pen white fill-pen sky line-width 2
    box 0x0 600x400
    st: start 1.0 duration 0.5 ease :ease-in-out-cubic
    translate 10x10
    line 10x0 580x0
    text-fx txt-bl text-scale 1.0 from 0.0 to 1.0
    ; animatioin length is calculated incorrectly (text-fx)
    ;start 1.0 after st ease :ease-in-out-cubic
    ;box 0x0 from 0x0 to 600x400 
    start 8 duration 1.0 ease :ease-in-out-cubic
    text-fx txt-bl text-scale 1.0 from 1.0 to 0.0

]

view [
    title "Animate"
    canvas: base 600x200 black rate 120
    on-create [parse-anim anim-block face]
]
