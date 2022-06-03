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

states: ["red" on "yellow" on]

change-caption: func [type][
    rejoin [pick ["Pause " "Resume "] states/:type: not states/:type type]
]

path-block: compose [
    line-width 15
    line-cap round
       
    start 0 duration 5 ease 'ease-in-out-quad
    stroke-path red-path (path) width 15 color (papaya - 10.10.10) expires after 8
    on-start [print "Starting path1"]
    on-exit [print "Ending path1"]
    on-time [canvas/parent/text: form time]
    start 2 duration 2
    stroke-path yellow-path (path) width 5 color (yello + 10.10.10) expires after 8 speed 1.2
    on-exit [print "Ending path2"]
] 
print "Stroke-path test"

view compose [
    below
    canvas: base 600x400 beige rate 67 draw animate path-block
    across
    button "Pause red" [
        toggle-animation 'red-path
        face/text: change-caption "red"
    ] 
    button "Pause yellow" [
        toggle-animation 'yellow-path
        face/text: change-caption "yellow"
    ]
]
