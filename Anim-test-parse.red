Red [
    title: "Animation tests - parsing animation block"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

logo: load %red-logo.png
font-1: make font! [name: "Verdana" style: 'bold size: 200 color: 255.255.255.0]
font-2: make font! [name: "Verdana" size: 120 color: 255.125.55.0]

ani-bl1: compose/deep [
    scale 0.1 0.1
    start 10.0 duration 1.5 ease :ease-in-expo
        translate from 0x0 to -7000x0
    start 1.0 duration 2.0 ease :ease-in-out-quad
        image (logo) 350x250 from 350x250 to 1500x1500
        font (font-1)
        text from 6700x600 to 1600x600 "Red Programming language"
    start 3.0 delay 0.5 ease :ease-out-back
        font (font-2) 
        text from 6700x1800 to 700x1800 "- Human-friendly syntax"
        text from 6700x2100 to 700x2100 "- Homoiconic"
        text from 6700x2400 to 700x2400 "- Functional, imperative, reactive and symbolic programming"
        text from 6700x2700 to 700x2700 "- Rich set of built-in datatypes (50+)"
        text from 6700x3000 to 700x3000 "- Powerful PEG parser DSL included"
        text from 6700x3300 to 700x3300 "- Cross-platform native GUI system, with a UI DSL and drawing DSL"
]

view [
    title "Animate"
    canvas: base 670x400 49.39.39 rate 120
    on-create [parse-anim ani-bl1 face]
]
