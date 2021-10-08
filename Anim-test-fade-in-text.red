Red [
    title: "Animation dialect tests"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

fnt1: make font! [name: "Verdana" size: 100 color: 255.255.255.255]
fnt2: make font! [name: "Verdana" size: 120 style: 'bold color: 255.155.55.255]

text1: {Lorem ipsum dolor sit amet, consectetur adipiscing elit.
In elementum orci neque, eu tincidunt nisl finibus sit amet.
Ut consectetur pellentesque consectetur.}
text2: {Donec non vulputate nisi. Pellentesque sodales ut justo
at commodo. Aliquam rutrum dui in turpis lobortis luctus.
Phasellus ultricies ipsum eu dui bibendum finibus.}
text3: {In urna libero, ultrices sed rhoncus ut, consequat et magna.
Sed a tortor a ex sodales pretium. Nulla bibendum nec quam
a sollicitudin. Vivamus vulputate erat odio, in consectetur
sapien tempor id.}

txt-bl1: compose [text: (text1)  font: (fnt1) mode: 'lines dur: 2.5 delay: 1.0 posXY: 100x100]
fade-bl1: fade-in-text/init 'fade-txt1 0.0 txt-bl1
txt-bl2: compose [text: (text2)  font: (fnt1) mode: 'words start: 5.0 dur: 0.5 delay: 0.1 posXY: 100x700]
fade-bl2: fade-in-text/init 'fade-txt2 0.0 txt-bl2
txt-bl3: compose [text: (text3)  font: (fnt1) mode: 'chars start: 8.0 dur: 0.5 delay: 0.01 posXY: 100x1300]
fade-bl3: fade-in-text/init 'fade-txt3 0.0 txt-bl3

txt-bl4: compose [text: "Lines" font: (fnt2) mode: 'lines start: 0.5 dur: 2.0 posXY: 380x2200]
fade-bl4: fade-in-text/init 'fade-txt4 0.0 txt-bl4
txt-bl5: compose [text: "Words" font: (fnt2) mode: 'words start: 4.5 dur: 2.0 posXY: 1500x2200]
fade-bl5: fade-in-text/init 'fade-txt5 0.0 txt-bl5
txt-bl6: compose [text: "Chars" font: (fnt2) mode: 'chars start: 8.0 dur: 2.0 posXY: 2800x2200]
fade-bl6: fade-in-text/init 'fade-txt6 0.0 txt-bl6

view [
    title "Animate"
    base 650x400 teal rate 60
    draw compose/deep [
        font fnt1
        fill-pen aqua
        pen yello
        scale 0.15 0.15 [
            box 0x0 4500x3000
            (fade-bl1)
            (fade-bl2)
            (fade-bl3)
            line-width 250 line-cap round
			tr: translate 0x3300 [line 250x0 950x0]	
            (fade-bl4)
            (fade-bl5)
            (fade-bl6)
        ]
    ]
    on-time [
        tm: to float! difference now/precise st-time

        fade-in-text 'fade-txt1 tm
        fade-in-text 'fade-txt2 tm
        fade-in-text 'fade-txt3 tm
        
        fade-in-text 'fade-txt4 tm
        fade-in-text 'fade-txt5 tm
        fade-in-text 'fade-txt6 tm
        
		tween 'tr/2    0x3300    0x2300 0.0 2.0 tm :ease-in-out-elastic
		tween 'tr/2    0x2300 1200x2300 4.0 2.0 tm :ease-in-out-elastic
		tween 'tr/2 1200x2300 2450x2300 7.0 2.0 tm :ease-in-out-elastic
    ]
    on-create [print "start" st-time: now/precise]
]
