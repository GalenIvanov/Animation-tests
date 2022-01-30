Red [
    title: "Animation tests - morph-path"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

n-gon: function [n c r p][
    collect [
        keep 'line
        loop n + 1 [
            keep as-pair (r * cosine p) + c/x (r * sine p) + c/y
            p: 360.0 / n + p 
        ]
    ]
]

;path1: n-gon 13 200x200 140 0

path11: [
    line 100x100 300x100
    arc 300x150 50x50 270 90 
    line 350x150 350x250
    arc 300x250 50x50 0 90
    line 300x300 100x300 
    arc 100x250 50x50 90 90
    line 50x250 50x150
    arc 100x150 50x50 180 90
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

path4: [
    line 180x50 220x50 220x350 180x350 180x50
]

morph-path-block: compose/deep [
    pen red
    line-width 3
    line-cap round
    start 2 duration 2 ease :ease-in-out-quint
    morph-path (path1) into (path3) width 5 color red visible true expires after 2
    start 4 duration 2 ease :ease-in-out-quint
    morph-path (path3) into (path2) width 5 color red visible false
]

view compose [
    canvas: base 400x400 beige rate 60
    on-create [parse-anim morph-path-block face]
]
