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

fade-bl1: fade-in-text/init 'fade-txt1 0.0 text1 fnt1 'lines 100x100 1.0 1.0 1.0 0.5 0.1
fade-bl2: fade-in-text/init 'fade-txt2 0.0 text2 fnt1 'words 100x700 1.0 1.0 5.0 0.4 0.1
fade-bl3: fade-in-text/init 'fade-txt3 0.0 text3 fnt1 'chars 100x1300 1.0 1.0 9.0 0.5 0.01

fade-bl4: fade-in-text/init 'fade-txt4 0.0 "Lines" fnt2 'words 380x2200 1.0 1.0 0.5 2.0 0.1
fade-bl5: fade-in-text/init 'fade-txt5 0.0 "Words" fnt2 'words 1500x2200 1.0 1.0 4.5 2.0 0.1
fade-bl6: fade-in-text/init 'fade-txt6 0.0 "Chars" fnt2 'words 2800x2200 1.0 1.0 9.0 2.0 0.1

view [
    title "Animate"
    bb: base 650x400 teal rate 60
    draw compose/deep [
        font fnt1
        fill-pen aqua
        pen yello
        scale 0.15 0.15 [
            box 0x0 5000x4000
            (fade-bl1)
            (fade-bl2)
            (fade-bl3)
            line-width 250
            line-cap round
            ln1: line 250x3300 950x3300
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
        
        tween 'ln1/2/y 3300 2300 0.5 2.0 tm :ease-in-out-elastic
        tween 'ln1/3/y 3300 2300 0.5 2.0 tm :ease-in-out-elastic
                
        tween 'ln1/2/x 250 1450 4.0 2.0 tm :ease-in-out-elastic
        tween 'ln1/3/x 950 2200 4.0 2.0 tm :ease-in-out-elastic
        
        tween 'ln1/2/x 1450 2750 8.0 2.0 tm :ease-in-out-elastic
        tween 'ln1/3/x 2200 3350 8.0 2.0 tm :ease-in-out-elastic
        
    ]
    on-create [print "start" st-time: now/precise]
]