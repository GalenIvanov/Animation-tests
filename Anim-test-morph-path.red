Red [
    title: "Animation tests - stroke-path"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

n-gon: function [n c r p][
    collect [
        keep 'line
        loop n + 1 [
            keep as-pair (r * cosine p) + c/x (r * sine p) + c/y
            p: 360 / n + p
        ]
    ]
]

path1: n-gon 3 200x200 140 270
path2: n-gon 6 200x200 150 270

probe morph-path-block: compose/deep [
    pen white
    line-width 5
    line-cap round
    start 2 duration 2 ease :ease-in-out-quint
    (path1)
    (path2)
    morph-path (path1) into (path2) width 5 color red
]

view compose [
    canvas: base 400x400 beige rate 60
    on-create [parse-anim morph-path-block face]
]
