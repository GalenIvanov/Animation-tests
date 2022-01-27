Red [
    title: "Animation tests - stroke-path"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

path: [
   arc 100x50 50 180 -90  ; note that radius 50 is an integer! and not a pair!
   line 100x100 220x100 180x200 250x200
   arc 250x250 50 270 90 
   bezier 300x250 320x400 450x200 500x300
   line 500x300 500x325
   arc 535x325 35 180 -180
]

path-block: compose [
    pen white
    line-width 15
    line-cap round
       
    start 1 duration 3 ease :ease-in-out-quad
    stroke-path test (path) width 15 color (papaya - 10.10.10)
    
    start 1 duration 3
    stroke-path test2 (path) width 5 color (yello + 10.10.10)
]

view [
    canvas: base 600x400 beige rate 120
    on-create [parse-anim path-block face]
]
