Red [
    title: "Animation tests - scale-text from top"
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

scale-bl: scale-text/init/rand 'scale-txt 0.0 'top text1 fnt1 'chars 150x150 1.0 1.0 1.0 0.7 0.01


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
        scale-text 'scale-txt tm 'top
    ]
    on-create [print "start" st-time: now/precise]
]