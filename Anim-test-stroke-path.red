Red [
    title: "Animation tests - stroke-path"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

path: [
   line 100x100 200x100 200x200 250x200
   arc 250x250 50 270 90  ; note that radius 50 is an integer! and not a pair!
   bezier 300x250 320x400 450x200 500x300
]

path-block: compose [
    pen white
	line-width 5
	line-cap round
   	
    start 1.0 duration 5.0
	stroke-path test (path)
   
]

view [
    canvas: base 600x400 beige rate 1
    on-create [parse-anim path-block face]
]