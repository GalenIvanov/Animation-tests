Red [
    title: "Animation tests - parameter"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

fnt: make font! [size: 18]

anim-block: compose [
    start 0 duration 10
    pen from white to white
    on-time [tm/3: form round/to time 0.01]
    on-exit [quit]
    start 1 duration 1 ease 'ease-in-out-quad
    parameter btn/size/y from 100 to 200
    font fnt
    tm: text 80x80 "0.00"
] 

view compose [
    btn: button 100x100 "OK"
    canvas: base 200x200 beige rate 67
    draw animate anim-block
]
