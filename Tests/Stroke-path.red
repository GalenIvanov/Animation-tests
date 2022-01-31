Red [
    title: "Animation tests - stroke-path"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

path: [
   arc 100x50 50x50 180 -90  ; note that only the x of radius is used! (circular arcs)
   line 100x100 220x100 180x200 250x200
   arc 250x250 50x50 270 90 
   bezier 300x250 320x400 450x200 500x300
   line 500x300 500x325
   arc 535x325 35x35 180 -180
]

path-block: compose [
    line-width 15
    line-cap round
       
    start 1 duration 2 ease :ease-in-out-quad
    stroke-path test (path) width 15 color (papaya - 10.10.10) expires after 4
	on-start [print "Starting path1"]
    on-exit [print "Ending path1"]
	on-time [canvas/parent/text: form time]
    start 1 duration 2
    stroke-path test2 (path) width 5 color (yello + 10.10.10) expires after 3
	on-exit [print "Ending path2"]
] 
print "Stroke-path test"

view compose [
    canvas: base 600x400 beige rate 60
    on-create [animate path-block face]
]
