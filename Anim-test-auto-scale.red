Red [
    title: "Animation tests - automatic scale"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

font-1: make font! [name: "Verdana" style: 'bold size: 180 color: 255.255.255.255]

ani-block: compose/deep [
    one: start 1.0 duration 0.5 delay 0.5 
        line-width 40
        pen yello
        line 370x350 from 370x350 to 200x350
        arc 200x200 150x150 90 from 0 to 270
        line 350x200 from 350x200 to 350x350
    two: start when one ends duration 0.5 delay 0.5
        pen sky
        line 320x300 from 320x300 to 200x300
        arc 200x200 100x100 90 from 0 to 270
        line 300x200 from 300x200 to 300x320
    three: start 1 after two ends duration 0.5 delay 0.5
        pen papaya
        line 270x250 from 270x250 to 200x250
        arc 200x200 50x50 90 from 0 to 270
        line 250x200 from 250x200 to 250x270
    start 1.0 before three starts duration 3.0 ease :ease-out-cubic
        font font-1 parameter font-1/color from transparent to 255.80.37.0
		translate 210x335 [
		    skew from -90.0 to 0.0
            text 0x0 "Animation"        
		]	
]

view compose [
    title "Animate"
    canvas: base 400x400 black rate 90
    on-create [parse-anim ani-block face]
]
