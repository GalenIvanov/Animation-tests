Red [
    title: "Animation tests - markers"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" size: 140 color: 255.255.255.0]

anim-block: compose [
    pen white fill-pen sky line-width 2
    box  0x60 900x450
    fill-pen (sky + 20.20.20)
    box 200x60 250x450
    box 300x60 350x450
    box 400x60 450x450
    box 500x60 550x450
    box 600x60 650x450
    box 700x60 750x450
    box 800x60 850x450
    
    font fnt1 text 155x100 "Ref"
    text  300x5 "Ref start"
    text  550x5 "Ref end"
    text  5x150 "start -2.0  along Ref"
    text 50x200 "start along Ref"
    text 15x250 "start 2.0 along Ref"
    text 10x300 "start -2.0 after Ref"
    text 55x350 "start after Ref"
    text 20x400 "start 2.0 after Ref"    
    
    start 0.0 duration 16.0
    pen papaya fill-pen yello
    line line 300x30 300x450
    line line 550x30 550x450
    translate from 0x0 to 800x0 [
        line 200x45 200x450
        elapsed: text 200x25 "0.00"
    ]
    
    ref: start 2.0 duration 5.0
        translate from 0x0 to 250x0 [box 300x100 320x120]
    start -1.0 along ref duration 5.0                  
        translate from 0x0 to 250x0 [box 300x150 320x170]
    start along ref duration 5.0                  
        translate from 0x0 to 250x0 [box 300x200 320x220]
    start 2.0 along ref duration 5.0              
        translate from 0x0 to 250x0 [box 300x250 320x270]    
    start -2.0 after ref duration 5.0                  
        translate from 0x0 to 250x0 [box 300x300 320x320]        
    start after ref duration 5.0                  
        translate from 0x0 to 250x0 [box 300x350 320x370]    
    start 2.0 after ref duration 5.0              
        translate from 0x0 to 250x0 [box 300x400 320x420]    
]

view [
    title "Animate - markers"
    canvas: base 900x450 black rate 120
    on-create [
        parse-anim anim-block face 
        append body-of :face/actors/on-time [
            elapsed/3: to-string round/to to float! difference now/precise st-time 0.1
        ]
    ]    
]
