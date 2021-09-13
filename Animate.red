Red [
    title: "Animation dialect tests"
    author: "Galen Ivanov"
    needs: view
]

start-t: 0

;------------------------------------------------------------------------------------------------
; easing functions
; the argument must be in the range 0.0 - 1.0
;------------------------------------------------------------------------------------------------
easeLinear:     func [x][x]

easeInOutSine:  func [x][(cos pi * x) - 1 / -2]

easeInOutQuad:  func [x][either x < 0.5 [x ** 2 *  2][1 - (-2 * x + 2 ** 2 / 2)]]

easeInOutCubic: func [x][either x < 0.5 [x ** 3 *  4][1 - (-2 * x + 2 ** 3 / 2)]]

easeInOutQuart: func [x][either x < 0.5 [x ** 4 *  8][1 - (-2 * x + 2 ** 4 / 2)]]

easeInOutQuint: func [x][either x < 0.5 [x ** 5 * 16][1 - (-2 * x + 2 ** 5 / 2)]]

easeInOutExpo:  func [x][either x < 0.5 [2 ** (20 * x - 10) / 2][2 - (2 ** (-20 * x + 10)) / 2]]

easeInOutCirc:  func [x][
    either x < 0.5 [
        (1 - sqrt 1 - (2 * x ** 2)) / 2
    ][
        (sqrt 1 - (-2 * x + 2 ** 2)) + 1 / 2
    ]
]

easeInOutBack: func [x /local c1 c2][
    c1: 1.70158           ; why two constants? 
    c2: c1 * 1.525
    either x < 0.5 [
        2 * x ** 2 * (c2 + 1 * 2 * x - c2) / 2
    ][
        2 * x - 2 ** 2 * (c2 + 1 * (x * 2 - 2) + c2) + 2 / 2
    ]
]

easeInOutElastic: func [x /local c][
    c: 2 * pi / 4.5
    either x < 0.5 [
        2 ** ( 20 * x - 10) * (sin 20 * x - 11.125 * c) / -2
    ][
        2 ** (-20 * x + 10) * (sin 20 * x - 11.125 * c) / 2 + 1
    ]
 ]

easeSteps: func [x n][round/to x 1 / n]
;------------------------------------------------------------------------------------------------

rot: 0
trans: 0x0
st-time: 0

tween: func [
    {Interpolates a value between value1 and value2 at time t
    in the stretch start .. start + duration using easing function ease}
    value1   [number!]   {Value to interpolate from}
    value2   [number!]   {Value to interpolate to}
    start    [float!]    {Start of the time period}
    duration [float!]    {Duration of the time period}
    t        [float!]    {Current time}
    ease     [function!] {Easing function}
    /local
][
    tmp: case [
        t < start [value1]
        t >= (start + duration) [value2]
        true [(ease t - start / duration) * (value2 - value1) + value1]
    ]    
]


view [
    title "Animate"
    base 650x200 teal rate 120
    draw [
        line 0x180 650x180
        fill-pen yello
        slide: translate 0x0 [line-width 1 box 50x10 100x60] 
        fill-pen sky bx: box 50x150 80x180
        circ1: circle 30x110 25
    ]
    on-time [
        tm: to float! difference now/precise st-time
        slide/2/x: to integer! tween 0 500 0.5 3.0 tm :easeInOutElastic
        bx/3/x: to integer! tween 80 550 2.0 4.0 tm :easeInOutExpo
        circ1/2/x: to integer! tween 30 550 0.0 6.0 tm func[x][easeSteps x 10]
    ]
    on-create [st-time: now/precise]
]
