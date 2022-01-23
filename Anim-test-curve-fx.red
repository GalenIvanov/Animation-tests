Red [
    title: "Animation dialect tests - text-along-curve"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" size: 16 color: black]
red-text: "Red is a next-gen programming language, strongly inspired by REBOL"
lim: 100 ; fow many points to calculate in the bezier curve
bez-pts: [500x400 3700x-1200 3500x1000 2500x4000 6200x2000]  ; 10x for sub-pixel precision
bez-pts2: [50x40 370x-120 350x100 250x400 620x200] 

tt: 0.0
bez-test: make block! 200
append bez-test [line-cap round line-width 350 fill-pen transparent scale 0.1 0.1]
; draws a (not automatically scaled) Bezier curve - it will be included in trace-path function!
append/only bez-test collect [  ; not scaled!  
    keep 'line
    repeat n lim [
        keep bezier-n bez-pts tt
        tt: n / lim
    ]
]

upper-triangle: [pen red fill-pen yello polygon 0x-15 10x-35 -10x-35]
lower-triangle: [pen red fill-pen yello polygon 0x15 10x35 -10x35]
draw-block: reduce [upper-triangle lower-triangle]

red-info: [data: red-text font: fnt1 curve: bez-pts2 space-x: 0.98]
shapes: [data: draw-block curve: bez-pts2 space-x: 0]

block: compose/deep [
    font fnt1
    start 1.0 duration 1.0
    pen1: pen from 80.108.142.255 to 80.108.142.0
    translate 0x50
    (bez-test)
    line-width 3
    start 1.0 duration 2.0 delay 1.0 ease :ease-in-out-cubic
    curve-fx Red-lang red-info from 1.0 to 0.0 expires after 5
    curve-fx test-block shapes from 1.0 to 0.0 expires after 5
]

view [
    title "Animate"
    below
    bb: base 650x350 black rate 120
    on-create [parse-anim block face]
]
