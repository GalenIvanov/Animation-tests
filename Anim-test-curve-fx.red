Red [
    title: "Animation dialect tests - text-along-curve"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

; To do:
; Autoscale of bezier-curve points - for the Bezier curve
; draw-block mode
; up-down direction?


fnt1: make font! [name: "Verdana" size: 17 color: black]
red-text: "Red is a next-gen programming language, strongly inspired by REBOL"
bez-test: make block! 200
tt: 0.0
lim: 100 ; fow many points to calculate in the bezier curve
bez-pts: [500x400 3700x-1200 3500x1000 2500x4000 6200x2000]  ; 10x for sub-pixel precision
bez-pts2: [50x40 370x-120 350x100 250x400 620x200] 

append bez-test [line-cap round line-width 350 fill-pen transparent scale 0.1 0.1]

; draws the Bezier curve - needs to be separated in a function!
append/only bez-test collect [  ; not scaled!  
    keep 'line
    repeat n lim [
        keep bezier-n bez-pts tt
        tt: n / lim
    ]
]

small-box: [pen red box -20x-10 20x10]
small-circle: [pen sky circle 0x0 20]
probe draw-block: reduce [small-box small-circle]


red-info: [data: red-text font: fnt1 curve: bez-pts2 space-x: 0.93]
;red-info: [data: [[box 0x0 10x10]] font: fnt1 curve: bez-pts]
red-info: [data: draw-block curve: bez-pts2 space-x: 50]

block: compose/deep [
    font fnt1
    start 1.0 duration 2.0 delay 1.0 
    pen1: pen from 80.108.142.255 to 80.108.142.0

    ; progress - temporary - will be deleted
    line-width 5
    line 10x340 640x340
    translate from 0x0 to 630x0 [line 10x310 10x335]
    
    translate 0x50
    start 1.0 duration 5.0 ease :ease-in-out-quint
    (bez-test) 
    line-width 3
    curve-fx Red-lang red-info from 1.0 to 0.0    ; id data curve-pos

]

view [
    title "Animate"
    below
    time-t: text "0.0"
    bb: base 650x350 black rate 120
    on-create [parse-anim block face]
]
