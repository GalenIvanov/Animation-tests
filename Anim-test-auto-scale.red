Red [
    title: "Animation tests - automatic scale"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

logo: load %red-logo.png
font-1: make font! [name: "Verdana" style: 'bold size: 200 color: 255.255.255.255]


ani-block: compose/deep [
    st: start 1.0 duration 2.0 delay 1.0 ease :ease-in-out-quad
        parameter logo/alpha from 255 to 0
        image logo from 600x600 to 350x350 from 600x600 to 1500x1500
        font font-1
        parameter font-1/color from 255.255.255.255 to 255.50.20.0
        txt1: text 500x2000 "Some random text"
        pen1: pen from white to (teal)
        line-width 20
        translate from 3000x4000 to 6000x4000 [
           rot: start 2.0 after st duration 2.0 ease :ease-out-elastic
           rotate from 0.0 to 90.0
           box -1000x-1000 1000x1000
        ]
    start 0.0 after rot duration 2.0
        fill-pen papaya
        translate from 2000x500 to 5000x500
        box 0x0 2000x1000 
]

view [
    title "Animate"
    canvas: base 800x600 black rate 120
    on-create [parse-anim ani-block face]
]
