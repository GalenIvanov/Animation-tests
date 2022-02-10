Red [
    title: "Animation tests - pen and fill-pen"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

img: load %red-logo.png
fnt: make font! [size: 35 style: 'bold color: black]

fill: [
    fill-pen yello pen transparent
    box 0x0 100x100
    fill-pen sky pen white line-width 5
    circle 50x50 40
]
 
anim-block: compose/deep [
    pen white line-width 8
    
    font fnt
    fill-pen pattern 100x100 [(fill)]
    start 0 ease 'ease-in-out-cubic loop 2 times duration 5 loop forever 
    rotate 'fill-pen from 0.0 to 360.0 150x150
        
    start 0 duration 5 ease 'ease-in-out-elastic loop two-way forever
    scale 'fill-pen from 1.0 to 2.0 from 1.0 to 2.0
    
    spline 100x100 from 300x50 to 300x150 500x100
        from 450x300 to 550x300
        500x500 from 300x550 to 300x450 100x500
        from 150x300 to 50x300 closed               
] 

view compose [
    canvas: base 600x600 black rate 67
    draw animate anim-block
]
