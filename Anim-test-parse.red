Red [
    title: "Animation tests - parsing animation block"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

ani-bl1: compose/deep [
    line-width 50
    fill-pen (yello)
	scale 0.1 0.1
    start 2.0 duration 2.0 ease :ease-in-out-cubic
        translate from 0x0 to 5000x1900
    start 4.0
        rotate from 0 to 90 450x450
        [box 100x100 1000x1000]
]

view [
    title "Animate"
    canvas: base 600x300 beige rate 120
    on-create [parse-anim ani-bl1 face]
]