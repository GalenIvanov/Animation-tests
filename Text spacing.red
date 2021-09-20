Red [
    title: "caret-to-offset tests"
    author: "Galen Ivanov"
    needs: view
]

message: "Know your distance!"
font20: make font! [name: "Verdana" size: 20 color: black]
txt: make face! compose [size: 800X200 type: 'rich-text text: (message)]
txt/font: font20

len: collect [
    repeat n length? message [
        keep compose [line (p: 1x0 * caret-to-offset txt n) (p + 0x30)]
    ]
]

view compose [
    title "caret-to-offset"
    backdrop beige 
	base 280x50 beige
    draw compose[
	    translate 5x5
        font font20 text 0x0 (message)
        line-width 2 pen gray (len)
    ]
]
