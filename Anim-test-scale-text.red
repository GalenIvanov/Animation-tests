Red [
    title: "Animation tests - scale-text"
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

txt-bl: compose [text: (text1)  font: (fnt1) mode: 'chars from: 'center delay: 0.01 posXY: 150x150]
scale-bl: scale-text/init/rand 'scale-txt 0.0 txt-bl

view [
    title "Animate"
    bb: base 760x220 black rate 60
    draw compose/deep [
        font fnt1
        scale 0.15 0.15 [
           (scale-bl)
        ]   
    ]
    on-time [
        tm: to float! difference now/precise st-time
        scale-text 'scale-txt tm
    ]
    on-create [print "start" st-time: now/precise]
]
