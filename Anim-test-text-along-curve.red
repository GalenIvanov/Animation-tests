Red [
    title: "Animation dialect tests - text-along-curve"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt2: make font! [name: "Verdana" size: 170 color: 0.0.0.0]
text1: "Red is a next-gen programming language, strongly inspired by REBOL"
bez-test: make block! 200
tt: 0.0
lim: 100 ; fow many points to calculate in the be\ier curve
bez-pts: [500x400 3700x-1200 3500x1000 2500x4000 6200x2000]  ; 10x for sub-pixel precision

st-txt: 10000 ; for animating text-along-curve
draw-bl: make block! 10 * length? text1
draw-bl: text-along-curve/init 'text1 1.0 text1 fnt2 bez-pts 0.98

append bez-test [line-cap round line-width 350 fill-pen transparent scale 0.1 0.1]
append/only bez-test collect [
    keep 'line
    repeat n lim [
        keep bezier-n bez-pts tt
        tt: n / lim
     ]
]    

view [
    title "Animate"
    bb: base 650x350 black rate 60
    draw compose/deep [
        font fnt2
        pen1: pen 80.108.142.255
        translate 0x50
        (bez-test)
        bz2: (draw-bl)
        
    ]
    on-time [
        tm: to float! difference now/precise st-time
        tween 'pen1/2/4 255 0 1.1 2.0 tm :ease-in-out-cubic
        tween 'st-txt  10000 0 1.5 6.0 tm :ease-in-out-quint
        text-along-curve 'text1 st-txt / 10000.0
    ]
    on-create [print "start" st-time: now/precise]
]
