Red [
    title: "Animation dialect tests"
    author: "Galen Ivanov"
    needs: view
]

st-time: 0
img: load %Atari_section2.jpg

;------------------------------------------------------------------------------------------------
; easing functions
; the argument must be in the range 0.0 - 1.0
;------------------------------------------------------------------------------------------------
ease-linear: func [x][x]

ease-steps: func [x n][round/to x 1 / n]

ease-in-sine: func [x][1 - cos x * pi / 2]
ease-out-sine: func [x][sin x * pi / 2]
ease-in-out-sine: func [x][(cos pi * x) - 1 / -2]
; the next 4 easing functions familiescan be combined to one family: ease-...-powerN - N [2 3 4 5]
ease-in-quad:      func [x][x ** 2]
ease-out-quad:     func [x][2 - x * x]  ; shorter for [1 - (1 - x ** 2)]
ease-in-out-quad:  func [x][either x < 0.5 [x ** 2 *  2][1 - (-2 * x + 2 ** 2 / 2)]]

ease-in-cubic:     func [x][x ** 3]
ease-out-cubic:    func [x][1 - (1 - x ** 3)] 
ease-in-out-cubic: func [x][either x < 0.5 [x ** 3 *  4][1 - (-2 * x + 2 ** 3 / 2)]]

ease-in-quart:     func [x][x ** 4]
ease-out-quart:    func [x][1 - (1 - x ** 4)]
ease-in-out-quart: func [x][either x < 0.5 [x ** 4 *  8][1 - (-2 * x + 2 ** 4 / 2)]]

ease-in-quint:     func [x][x ** 5]
ease-out-quint:    func [x][1 - (1 - x ** 5)]
ease-in-out-quint: func [x][either x < 0.5 [x ** 5 * 16][1 - (-2 * x + 2 ** 5 / 2)]]

ease-in-expo:      func [x][2 ** (10 * x - 10)]
ease-out-expo:     func [x][1 - (2 ** (-10 * x))]
ease-in-out-expo:  func [x][
    either x < 0.5 [
        2 ** (20 * x - 10) / 2
    ][
        2 - (2 ** (-20 * x + 10)) / 2
    ]
]

ease-in-circ: func [x][1 - sqrt 1 - (x * x)] 
ease-out-circ: func [x][sqrt 1 - (x - 1 ** 2)]
ease-in-out-circ: func [x][
    either x < 0.5 [
        (1 - sqrt 1 - (2 * x ** 2)) / 2
    ][
        (sqrt 1 - (-2 * x + 2 ** 2)) + 1 / 2
    ]
]

ease-in-back: func [x /local c1 c3][
    c1: 1.70158
    c3: c1 + 1
    x ** 3 * c3 - (c1 * x * x)
]
ease-out-back: func [x /local c1 c3][
    c1: 1.70158
    c3: c1 + 1
    x - 1 ** 3 * c3 + 1 + (x - 1 ** 2 * c1) 
]
ease-in-out-back: func [x /local c1 c2][
    c1: 1.70158           ; why two constants? 
    c2: c1 * 1.525
    either x < 0.5 [
        2 * x ** 2 * (c2 + 1 * 2 * x - c2) / 2
    ][
        2 * x - 2 ** 2 * (c2 + 1 * (x * 2 - 2) + c2) + 2 / 2
    ]
]

ease-in-elastic: func [x /local c][
    c: 2 * pi / 3
    negate 2 ** (10 * x - 10) * sin x * 10 - 10.75 * c
] 
ease-out-elastic: func [x /local c][
    c: 2 * pi / 3
    (2 ** (-10 * x) * sin 10 * x - 0.75 * c) + 1
]
ease-in-out-elastic: func [x /local c][
    c: 2 * pi / 4.5
    either x < 0.5 [
        2 ** ( 20 * x - 10) * (sin 20 * x - 11.125 * c) / -2
    ][
        2 ** (-20 * x + 10) * (sin 20 * x - 11.125 * c) / 2 + 1
    ]
]
 
ease-in-bounce: func [x][1 - ease-out-bounce 1 - x] 
ease-out-bounce: func [x /local n d][
    n: 7.5625
    d: 2.75
    case [
        x < (1.0 / d) [n * x * x]
        x < (2.0 / d) [n * (x: x - (1.5   / d)) * x + 0.75]
        x < (2.5 / d) [n * (x: x - (2.25  / d)) * x + 0.9375]
        true          [n * (x: x - (2.625 / d)) * x + 0.9984375]
    ]
]
ease-in-out-bounce: func [x][
    either x < 0.5 [
        (1 - ease-out-bounce -2 * x + 1) / 2
    ][
        (1 + ease-out-bounce  2 * x - 1) / 2
    ]
]
;------------------------------------------------------------------------------------------------

tween: func [
    {Interpolates a value between value1 and value2 at time t
    in the stretch start .. start + duration using easing function ease}
    target   [word! path!] {}
    value1   [number!]     {Value to interpolate from}
    value2   [number!]     {Value to interpolate to}
    start    [float!]      {Start of the time period}
    duration [float!]      {Duration of the time period}
    t        [float!]      {Current time}
    ease     [function!]   {Easing function}
    /local
][
    if all [t >= start t < (start + duration)][
        ; not only integer! - should be a parameter!
        set target to integer! (ease t - start / duration) * (value2 - value1) + value1 
    ]
]

fnt: make font! [name: "Verdana" size: 30 color: 255.255.255.255]


view [
    title "Animate"
    base 650x300 teal rate 120
    draw compose [
        image (img) 200x0
        font (fnt)
        txt: text 220x30 "Alpha test"
        line 0x180 650x180
        fill-pen yello
        slide: translate 0x0 [line-width 1 box 50x10 100x60] 
        fill-pen papaya circ1: circle 30x110 25
        fill-pen sky bx1: box 50x150 80x180
        fill-pen sky bx2: box 50x200 80x230
        fill-pen sky bx3: box 50x250 80x280
    ]
    on-time [
        tm: to float! difference now/precise st-time
        ;slide/2/x: to integer! tween  0 500 0.0 4.0 tm :ease-in-out-elastic
        ;circ1/2/x: to integer! tween 30 580 0.0 4.0 tm func[x][ease-steps x 8]

        tween 'bx1/3/x     80 600 1.0 2.0 tm :ease-in-bounce
        tween 'bx2/3/x     80 600 1.0 2.0 tm :ease-in-out-bounce
        tween 'bx3/3/x     80 600 1.0 2.0 tm :ease-out-bounce
        tween 'fnt/color/4 255 0 2.0 1.0 tm :ease-in-sine
        tween 'fnt/color/4 0 255 4.5 0.5 tm :ease-in-sine
        tween 'img/alpha   255 0 0.0 1.0 tm :ease-in-sine
        tween 'txt/2/x     220 700 4.0 1.0 tm :ease-in-expo
    ]
    on-create [st-time: now/precise]
]
