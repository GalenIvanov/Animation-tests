Red [
    title: "Animation tests - markers"
    author: "Galen Ivanov"
    needs: view
]

#include %../animate.red

fnt1: make font! [name: "Verdana" size: 11 color: 255.255.255.0]

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
    text  5x150 "start 1.0 before Ref starts"
    text 40x200 "start when Ref starts"
    text 15x250 "start 2.0 after Ref starts"
    text 10x300 "start 2.0 before Ref ends"
    text 45x350 "start when Ref ends"
    text 20x400 "start 2.0 after Ref ends"    
    
    start 0.0 duration 16.0
    pen papaya fill-pen yello
    line line 300x30 300x450
    line line 550x30 550x450
    translate from 0x0 to 800x0 on-time [timer/3: form round/to time 0.01]
	[
        line 200x45 200x450
        timer: text 200x25 "0.00"
    ]
    
    ref: start 2.0 duration 5.0
        translate from 0x0 to 250x0 [box 300x100 320x120]
    start 1.0 before ref starts duration 5.0                  
        translate from 0x0 to 250x0 [box 300x150 320x170]
    start when ref starts duration 5.0                  
        translate from 0x0 to 250x0 [box 300x200 320x220]
    start 2.0 after ref starts duration 5.0              
        translate from 0x0 to 250x0 [box 300x250 320x270]    
    start 2.0 before ref ends duration 5.0                  
        translate from 0x0 to 250x0 [box 300x300 320x320]        
    start when ref ends duration 5.0                  
        translate from 0x0 to 250x0 [box 300x350 320x370]    
    start 2.0 after ref ends duration 5.0              
        translate from 0x0 to 250x0 [box 300x400 320x420]    
]

view [
    title "Animate - markers"
    canvas: base 900x450 black rate 67
    draw animate anim-block
]
