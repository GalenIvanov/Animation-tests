Red [
    title: "Animation tests - automatic scale"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

font-1: make font! [name: "Verdana" style: 'bold size: 180 color: 255.255.255.255]

ani-block: compose/deep [
    one: start 1.0 delay 1.0 ease :ease-in-out-quad
        line-width 40
        pen yello
        line 400x350 from 400x350 to 200x350
        arc 200x200 150x150 90 from 0 to 270
        line 350x200 from 350x200 to 350x400
    two: start 1.0 after one delay 1.0 ease :ease-in-out-quad
        pen sky
        line 400x300 from 400x300 to 200x300
        arc 200x200 100x100 90 from 0 to 270
        line 300x200 from 300x200 to 300x400
    three:    start 1.0 after two delay 1.0 ease :ease-in-out-quad
        pen papaya
        line 400x250 from 400x250 to 200x250
        arc 200x200 50x50 90 from 0 to 270
        line 250x200 from 250x200 to 250x400
    start -1.0 along three duration 3.0 ease :ease-in-out-cubic
        font font-1 parameter font-1/color from transparent to 255.255.255.0
        text from 400x235 to 210x235 "Animation"        
        
]

view compose [
    title "Animate"
    canvas: base 400x400 black rate 60
    on-create [parse-anim ani-block face]
]
