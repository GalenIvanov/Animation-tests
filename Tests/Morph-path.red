Red [
    title: "Animation tests - morph-path"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

n-gon: function [n c r p][
    collect [
        keep 'line
        loop n + 1 [
            keep as-pair (r * cosine p) + c/x (r * sine p) + c/y
            p: 360.0 / n + p 
        ]
    ]
]

path1: [
    arc 200x200 180x180 180 180
    arc 200x200 180x180 0 180
]

path2: n-gon 3 200x200 180 210

path3: [
    line 100x100 250x100 arc 250x150 50x50 270 90 line 300x150 300x250
    bezier 300x250 250x350 200x250 150x200 100x250
    line 100x250 100x100
]

states: ["morph2" on]

change-caption: func [type][
    rejoin [pick ["Pause " "Resume "] states/:type: not states/:type type]
]

morph-path-block: compose/deep [
    pen red
    line-width 3
    line-cap round
    start 2 duration 2 ease 'ease-in-out-quint
    morph-path morph1 (path1) into (path3) visible true expires after 2.0
    on-start [print "morph 1"]
    on-exit [print "Ending morph 1"]
    on-time [time-t/text: form round/to time 0.01]
    start 4 duration 4 ease 'ease-in-out-quint
    pen from red to white on-start [print "Starting color tween!"]
    morph-path morph2 (path3) into (path2) visible false
    on-start [print "Morph 2"] speed 1.25 on-exit [quit] 
]

print "Morph-path test"

view compose [
    canvas: base 400x400 beige rate 67
    draw animate morph-path-block
    below
    time-t: text "0.0"
    button "Pause morph2" [
        toggle-animation 'morph2
        face/text: change-caption "morph2"
    ] 
]
