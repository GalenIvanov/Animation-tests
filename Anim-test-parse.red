Red [
    title: "Animation tests - parsing animation block"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

logo: load %red-logo.png
font-1: make font! [name: "Verdana" style: 'bold size: 200 color: 255.255.255.255]
font-2: make font! [name: "Verdana" size: 120 color: white ] ;255.125.55.0]

ani-bl1: compose/deep [
    start 1.0 duration 2.0 ease :ease-in-out-quad
        image logo from 600x600 to 350x350 from 600x600 to 1500x1500
        font font-1
        parameter font-1/color from 255.255.255.255 to 255.50.20.0
        text from 6700x600 to 1600x600 "Red Programming language"
    start 3.0 duration 3.0
       font font-2
       parameter font-2/color from (transparent) to (255.125.55.0)
       parameter font-2/size from 300 to 120
    start 3.0 delay 0.5 ease :ease-out-back
        text from 6700x1800 to 700x1800 "- Human-friendly syntax"
        text from 6700x2100 to 700x2100 "- Homoiconic"
        text from 6700x2400 to 700x2400 "- Functional, imperative, reactive and symbolic programming"
        text from 6700x2700 to 700x2700 "- Rich set of built-in datatypes (50+)"
        text from 6700x3000 to 700x3000 "- Powerful PEG parser DSL included"
        text from 6700x3300 to 700x3300 "- Cross-platform native GUI system, with a UI DSL and drawing DSL"
    start 9.0 duration 2.0 ease :ease-in-cubic
        fill-pen from (transparent) to 0.0.0.0
        box 0x0 6700x4000
]

view [
    title "Animate"
    canvas: base 670x400 49.39.39 rate 120
    
    on-create [parse-anim ani-bl1 face]
]
