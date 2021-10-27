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
        image logo from 60x60 to 35x35 from 60x60 to 150x150
        font font-1
        parameter font-1/color from 255.255.255.255 to 255.50.20.0
        txt1: text 50x200 "Some random text"
        pen from white to teal
        line-width 2
        translate from 300x400 to 600x400 [
           rot: start after st duration 2.0 ease :ease-out-elastic
           rotate from 0.0 to 90.0
           box -100x-100 100x100
        ]
    start 1.0 along rot duration 2.0
        fill-pen papaya
        translate from 200x50 to 450x50 [
            skew from 45.0 to -45.0
            box 0x0 200x100 
        ]    
]

view [
    title "Animate"
    canvas: base 800x600 black rate 90
    on-create [parse-anim ani-block face]
]
