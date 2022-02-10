Red [
    title: "Animation tests - parsing animation block"
    author: "Galen Ivanov"
    needs: view
]

#include %../Animate.red

logo: load %red-logo.png
font-1: make font! [name: "Verdana" style: 'bold size: 20 color: 255.255.255.255]
font-2: make font! [name: "Verdana" size: 12 color: white ] ;255.125.55.0]

ani-bl1: compose [
    start 1.0 duration 2.0 ease 'ease-in-out-quad
        image logo from 60x60 to 35x35 from 60x60 to 150x150
        font font-1
        parameter font-1/color from 255.255.255.255 to 255.50.20.0
        text from 670x60 to 160x60 "Red Programming language"
    start 3.0 duration 3.0
       font font-2
       parameter font-2/color from (transparent) to (255.125.55.0)
       parameter font-2/size from 300 to 120
    start 3.0 delay 0.5 ease 'ease-out-back
        text from 670x180 to 70x180 "- Human-friendly syntax"
        text from 670x210 to 70x210 "- Homoiconic"
        text from 670x240 to 70x240 "- Functional, imperative, reactive and symbolic programming"
        text from 670x270 to 70x270 "- Rich set of built-in datatypes (50+)"
        text from 670x300 to 70x300 "- Powerful PEG parser DSL included"
        text from 670x330 to 70x330 "- Cross-platform native GUI system, with a UI DSL and drawing DSL"
    start 9.0 duration 2.0 ease 'ease-in-cubic
        fill-pen from (transparent) to 0.0.0.0 on-exit [quit]
        box 0x0 670x400
]

view [
    title "Animate"
    canvas: base 670x400 49.39.39 rate 67
    draw animate ani-bl1
]
