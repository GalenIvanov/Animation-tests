Red [
    title: "Animation dialect tests"
    author: "Galen Ivanov"
    needs: view
]

message: "This is a Simple text"
scale-factor: 1;system/view/metrics/dpi / 96.0
; font for draw
font18: make font! [name: "Verdana" size: 18 color: teal]
txt: make face! compose [size: 800X200 type: 'rich-text text: (message)]
txt/font: font18 ;make font! [name: "Verdana" size: 18 color: white]

lens: copy []
repeat n length? message [
    append lens compose [
        line (1x0 * (caret-to-offset txt n))
             (1x0 * (caret-to-offset txt n) + 0x30)         
    ]
]

;probe lens

view compose/deep [
    backdrop beige
    news: base 300x50 0.255.0.255
    draw compose[
        pen black
        ;box 0x0 (as-pair first last lens 30) 
        font font18 text 0x0 (message)
        pen black
        (lens)
    ]
]