Red [
    title: "Animation tests - text-fx"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" style: 'bold size: 100 color: 255.255.255.0]

text1: {Lorem ipsum dolor sit amet, consectetur adipiscing elit.
In elementum orci neque, eu tincidunt nisl finibus sit amet.
Ut consectetur pellentesque consectetur. Donec non vulputate
nisi. Pellentesque sodales ut justo at commodo. Aliquam rutrum
dui in turpis lobortis luctus. Phasellus ultricies ipsum eu
dui bibendum finibus. In urna libero, ultrices sed rhoncus ut,
consequat et magna. Sed a tortor a ex sodales pretium.}

txt-bl: compose [text: (text1) font: (fnt1) mode: 'words from: 'left dur: 1.0 delay: 0.1 posXY: 150x150]
;scale-bl: scale-text/init 'scale-txt 0.0 txt-bl

anim-block: [
    pen white fill-pen sky line-width 2
    box 0x0 600x400
	start 1.0 duration 2.0
	translate from 0x0 to 0x100
	line 10x10 590x10
	text-fx txt-bl  ; WIP
]

view [
    title "Animate"
    canvas: base 600x400 black rate 90
    on-create [parse-anim anim-block face]
]