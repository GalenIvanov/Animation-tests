Red [
    title: "Animation tests - markers"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" size: 140 color: 255.255.255.0]

anim-block: [
    pen sky fill-pen sky line-width 2
    line 200x40 200x350
    line 250x40 250x350
    line 300x40 300x350
    line 350x40 350x350
    line 400x40 400x350
    line 450x40 450x350
    line 500x40 500x350
    line 550x40 550x350
    line 600x40 600x350
    line 650x40 650x350
    line 700x40 700x350
    line 750x40 750x350
    
    font fnt1 text 155x100 "Ref"
    text 45x150 "start along Ref"
    text 10x200 "start 2.0 along Ref"    
    text 45x250 "start after Ref"
    text 10x300 "start 2.0 after Ref"    
    
    start 1.0 duration 12.0
    pen papaya
    translate from 0x0 to 600x0 [line 200x40 200x350]
    
    ref: start 1.0 duration 5.0
        translate from 0x0 to 250x0 [box 200x100 220x120]
    start along ref duration 5.0
        translate from 0x0 to 250x0 [box 200x150 220x170]
    start 2.0 along ref duration 5.0
        translate from 0x0 to 250x0 [box 200x200 220x220]    
    start after ref duration 5.0
        translate from 0x0 to 250x0 [box 200x250 220x270]    
    start 2.0 after ref duration 5.0
        translate from 0x0 to 250x0 [box 200x300 220x320]    
]

view [
    title "Animate - markers"
    canvas: base 800x400 black rate 120
    on-create [parse-anim anim-block face]
]