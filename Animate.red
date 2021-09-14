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
ease-linear:       func [x][x]

ease-in-sine:      func [x][1 - cos x * pi / 2]
ease-out-sine:     func [x][sin x * pi / 2]
ease-in-out-sine:  func [x][(cos pi * x) - 1 / -2]

ease-in-quad:      func [x][x * x]
ease-out-quad:     func [x][2 - x * x]
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
ease-in-out-expo:  func [x][either x < 0.5 [2 ** (20 * x - 10) / 2][2 - (2 ** (-20 * x + 10)) / 2]]

ease-in-circ:      func [x][1 - sqrt 1 - (x * x)] 
ease-out-circ:     func [x][sqrt 1 - (x - 1 ** 2)]
ease-in-out-circ:  func [x][
    either x < 0.5 [
        (1 - sqrt 1 - (2 * x ** 2)) / 2
    ][
        (sqrt 1 - (-2 * x + 2 ** 2)) + 1 / 2
    ]
]

ease-in-back:     func [x /local c1 c3][
    c1: 1.70158
    c3: c1 + 1
    x ** 3 * c3 - (c1 * x * x)
]
ease-out-back:    func [x /local c1 c3][
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

ease-in-out-elastic: func [x /local c][
    c: 2 * pi / 4.5
    either x < 0.5 [
        2 ** ( 20 * x - 10) * (sin 20 * x - 11.125 * c) / -2
    ][
        2 ** (-20 * x + 10) * (sin 20 * x - 11.125 * c) / 2 + 1
    ]
 ]

ease-steps: func [x n][round/to x 1 / n]
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
    base 650x300 teal rate 120
    draw [
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
        slide/2/x: to integer! tween  0 500 0.0 4.0 tm :ease-in-out-elastic
        circ1/2/x: to integer! tween 30 580 0.0 4.0 tm func[x][ease-steps x 8]

        bx1/3/x: to integer! tween 80 600 0.0 8.0 tm :ease-in-back
        bx2/3/x: to integer! tween 80 600 0.0 8.0 tm :ease-in-out-back
        bx3/3/x: to integer! tween 80 600 0.0 8.0 tm :ease-out-back
    ]
    on-create [st-time: now/precise]
]
