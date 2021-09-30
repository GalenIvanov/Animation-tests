Red [
    title: "Animation dialect tests"
    author: "Galen Ivanov"
    needs: view
]

st-time: 0
pascal: none

text-data: make map! 100

;------------------------------------------------------------------------------------------------
; easing functions
; the argument must be in the range 0.0 - 1.0
;------------------------------------------------------------------------------------------------
ease-linear: func [x][x]

ease-steps: func [x n][round/to x 1 / n]

ease-in-sine: func [x][1 - cos x * pi / 2]
ease-out-sine: func [x][sin x * pi / 2]
ease-in-out-sine: func [x][(cos pi * x) - 1 / -2]

ease-in-out-power: func [x n][either x < 0.5 [x ** n * (2 ** (n - 1))][1 - (-2 * x + 2 ** n / 2)]]

ease-in-quad:      func [x][x ** 2]
ease-out-quad:     func [x][2 - x * x]  ; shorter for [1 - (1 - x ** 2)]
ease-in-out-quad:  func [x][ease-in-out-power x 2]

ease-in-cubic:     func [x][x ** 3]
ease-out-cubic:    func [x][1 - (1 - x ** 3)] 
ease-in-out-cubic: func [x][ease-in-out-power x 3]

ease-in-quart:     func [x][x ** 4]
ease-out-quart:    func [x][1 - (1 - x ** 4)]
ease-in-out-quart: func [x][ease-in-out-power x 4]

ease-in-quint:     func [x][x ** 5]
ease-out-quint:    func [x][1 - (1 - x ** 5)]
ease-in-out-quint: func [x][ease-in-out-power x 5]

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
][
    if all [t >= start t < (start + duration)][
        ; not only integer! - should be a parameter!
        set target to integer! (ease t - start / duration) * (value2 - value1) + value1 
    ]
]

;------------------------------------------------------------------------------------------------
pascals-triangle: function [
    {Creates the first n rows of the Pascal's triangle, referenced by nCk}
    n [integer!]
][
    row: make vector! [1]
    PT: make block! n
    append/only PT copy row
    collect/into [
        loop n [
            row: add append copy row 0 head insert copy row 0
            keep/only copy row
        ]
    ] PT
]

pascal: pascals-triangle 30; stores the precalculated values for the first 30 rows  

nCk: function [
    {Calculates the binomial coefficient, n choose k}
    n k
][
    pascal/(n + 1)/(k + 1)
]

bezier-n: function [
    {Calculates a point in the Bezier curve, defined by pts, at t}
    pts [block!] {a set of pairs}
    t   [float!] {offset in the curve, from 0.0 to 1.0}
][
    if t < 0.0 [return pts/1]
    if t > 1.0 [return last pts]
    n: (length? pts) - 1
    bx: by: i: 0
    foreach p pts [
        c: (nCk n i) * ((1 - t) ** (n - i)) * (t ** i)
        bx: c * p/x + bx
        by: c * p/y + by
        i: i + 1
    ]
    as-pair bx by
]

bezier-tangent: function [  ; needs a better name!
    {Calculates the tangent angle for a Bezier curve
     defined with pts at point t}
    pts [block!] {a set of pairs}
    t   [float!] {offset in the curve, from 0.0 to 1.0}
][
    p1: bezier-n pts t
    p2: bezier-n pts t + 0.01
    arctangent2 p2/y - p1/y p2/x - p1/x
]

bezier-lengths: function [
    {Returns a block of accumulated lengths of the linear segments
     a bezier curve can be simplified to}
    pts  [block!]   {a set of 2d points defining a Bezier curve}
    segn [integer!] {number of linear segments to divide the curve into}
][
    t: 0.0
    length: 0.0
    p0: bezier-n pts t
    collect [
        repeat n segn [
           t: 1.0 * n / segn
           p1: bezier-n pts t
           keep length: length + sqrt p1/1 - p0/1 ** 2 + (p1/2 - p0/2 ** 2)
           p0: p1
        ]
    ]
]

half: func [a b][to integer! a + b / 2]

b-search: function [
    {Returns the index of the largest element of src 
    that is less than or equal to target}
    src    [block!]  {block of numbers}
    target [number!] {the number to be searched}
][
    L: 1
    R: length? src
    M: half L R
    while [L < R][
        case [
            src/:M = target [break]
            src/:M < target [L: M + 1]
            src/:M > target [R: M - 1]
        ]
        M: half L R
    ]
    M
]

bezier-lerp: function [
    {Returns a point in a Bezier curve. The distance from the 
    starting point is linearly interpolated.}
    u    [float!] {parameter of the interpolation, from 0.0 to 1.0}
    seg  [block!] {a precalculated block of segment lengths}
][
    ; !!! The points around 0.0 and 1.00 are much sparsely located!
    ;     This leads to uneven placement of objects along the curve !!!
    
    len: to integer! u * last seg 
    either len = seg/(idx: b-search seg len) [
        to float! idx / length? seg
    ][
        if idx = length? seg [return 1.0]
        l1: seg/:idx
        l2: seg/(idx + 1)
        seg-t: to float! len - l1 / (l2 - l1)
        to float! (idx + seg-t / length? seg)
    ]
]

;------------------------------------------------------------------------------------------------
; Text-related functions
;------------------------------------------------------------------------------------------------
char-offsets: function [
    {Calculates the offsets of the characters
    in a text for a given font settings}
    src [string!]
    fnt [object!]
][
    new-src: head append copy src "M"  ; to find the last offset
    size: as-pair fnt/size * length? new-src fnt/size
    ; as a general rule, never use make face!, only make-face
    txt: make make-face 'rich-text compose [size: (size) text: (new-src)]
    txt/font: copy fnt
    next collect [repeat n length? new-src [keep caret-to-offset txt n]]
]

text-box-size: function [
    {Calculates the size of the bounding box
    of a text for a given font settings}
    src [string!]
    fnt [object!]
][
    size: as-pair fnt/size * length? src fnt/size  ; * number of lines?
    txt: make face! compose [size: (size)  type: 'text text: (src)]
    txt/font: copy fnt
    size-text txt
]

split-text: function [
    {Splits src on characters, words (on spaces and newlines) 
    or lines (on newlines) and returns a block of blocks,  
    each consisting of a position and a substring}
    src  [string!]   {Text to split}
    fnt  [object!]   {Font to use for measurements}
    mode [any-word!] {chars, words or lines}
][
    size: as-pair fnt/size * length? src fnt/size
    txt: make make-face 'rich-text compose [size: (size) text: (src)]
    txt/font: copy fnt
    rule: select [chars [skip] words [space | newline] lines [newline]] mode
    
    collect [
        parse src [
            any [
                p: copy t thru [rule | end] 
                (keep/only reduce [caret-to-offset txt index? p t])
              | skip
            ]
        ]
    ]
]

fade-in-text: function [
    {Animates the text so that each element (character, word or line)
    fades-in from transparent to the chosen font color}
    id         [any-word!] {identifier for the effect}
    t          [float!]    {current time}
    /init
        txt    [string!]   {text to animate}
        fnt    [object!]   {font to use}
        mode   [any-word!] {chars, words or lines} 
        pos    [pair!]     {were to place the text}
        sp-x   [number!]   {scale factor for the offset in horizontal direction}
        sp-y   [number!]   {scale factor for the offset in vertical direction}
        start  [float!]    {start time of the animation}
        dur    [float!]    {duration of the animation}
        delay  [number!]   {how much is delayed the animaiton for each element}
][
    either init [   ; initialize
        chunks: split-text txt fnt mode
        n: 1
        forall chunks [
            fnt-name: rejoin [id "-fnt-" n]
            st: delay * n + start 
            append chunks/1 reduce [st dur]
            insert chunks/1 fnt-name
            n: n + 1        
        ]
        put text-data id compose/deep [
            chunks: [(chunks)]
            fnt: (fnt)
            pos: (pos)
        ]
        collect [
            foreach item chunks [
                fnt-name: to-word rejoin [item/1 "_"]
                set fnt-name copy fnt
                fnt-id: to set-word! item/1
                keep compose [
                    (fnt-id) font (get fnt-name)
                    text (pos + item/2) (item/3)
                ]
            ]
        ]    
    ][  ; animate
        foreach item text-data/:id/chunks [
            fnt-id: get to word! rejoin [item/1 "_"]
            tween 'fnt-id/color/4 255 0 item/4 item/5 t :ease-in-out-quart
        ]
    ]
]

text-along-curve: function [
    {Flow a text along Bezier curve}
    id       [word!]   {effect identificator}
    t        [number!] {point on the curve} 
    /init          
        txt  [string!] {text to be displayed}  
        fnt  [object!] {font to use}
        crv  [block!]  {point of the Bezier curve}  
        spacing [number!] {multiplier for the space between the characters}
][
    either init [
        txt-ofs: char-offsets txt fnt
        len: last txt-ofs      ; text length
        txt-sz: 0x1 * text-box-size txt fnt  ; only the text height
        bez-segs: bezier-lengths crv 500
        
        put text-data id compose/deep [  ; the map of id's and objects 
            txt-ofs: [(txt-ofs)]
            len: (len)       
            txt-sz: (txt-sz)
            crv: [(crv)]            
            bez-segs: [(bez-segs)]
            spacing: (spacing)
        ]    
        
        draw-buf: make block! 10 * length? txt
        append draw-buf [scale 0.1 0.1]

        append/only draw-buf collect [
            repeat n length? txt [
                id-t: to set-word! rejoin [id "-t-" n] ;translate
                id-r: to set-word! rejoin [id "-r-" n] ; rotate
                keep compose/deep [
                    (id-t) translate 10000x0 [
                        (id-r) rotate 0 0x0
                        text 0x0 (to-string txt/:n)
                    ]
                ]
            ]
        ]
        draw-buf
    ][
        tt: t        
        d: d0: 0x0
        obj: text-data/:id
        txt-ofs: obj/txt-ofs
        len: obj/len
        txt-sz: obj/txt-sz
        crv: obj/crv
        bez-segs: obj/bez-segs
        spacing: obj/spacing
        
        repeat n length? txt-ofs [
            d: txt-ofs/:n - d0 + txt-sz / 2
            u: d/x / len/x * spacing + tt
            ttt: bezier-lerp u bez-segs
            if ttt > 0.999 [break]
            
            c-offs: bezier-n crv ttt
            angle: round/to bezier-tangent crv ttt 0.01
           
            id-t: to word! rejoin [id "-t-" n] ;translate
            id-r: to word! rejoin [id "-r-" n] ; rotate
            change at get id-t 2 c-offs - d
            change at get id-r 2 angle
            change at get id-r 3 d
            
            tt: (to-float txt-ofs/:n/x / len/x * spacing) + t
            d0: txt-ofs/:n
        ]
    ]
]

;------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------

fnt1: make font! [name: "Verdana" size: 100 color: 255.255.255.255]
fnt2: make font! [name: "Verdana" size: 170 color: 0.0.0.0]
fnt3: make font! [name: "Verdana" size: 120 style: 'bold color: 255.155.55.255]
text1: "Red is a next-gen programming language, strongly inspired by REBOL"
text2: {Lorem ipsum dolor sit amet, consectetur adipiscing elit.
In elementum orci neque, eu tincidunt nisl finibus sit amet.
Ut consectetur pellentesque consectetur.}
text3: {Donec non vulputate nisi. Pellentesque sodales ut justo
at commodo. Aliquam rutrum dui in turpis lobortis luctus.
Phasellus ultricies ipsum eu dui bibendum finibus.}
text4: {In urna libero, ultrices sed rhoncus ut, consequat et magna.
Sed a tortor a ex sodales pretium. Nulla bibendum nec quam
a sollicitudin. Vivamus vulputate erat odio, in consectetur
sapien tempor id.}

bez-test: make block! 200
tt: 0.0
lim: 100 ; fow many points to calculate in the be\ier curve
bez-pts: [500x400 3700x-1200 3500x1000 2500x4000 6200x2000]  ; 10x for sub-pixel precision

st-txt: 10000 ; for animating text-along-curve

draw-bl: make block! 10 * length? text1
draw-bl: text-along-curve/init 'text1 1.0 text1 fnt2 bez-pts 0.98
fade-bl1: fade-in-text/init 'fade-txt1 0.0 text2 fnt1 'lines 100x100 1.0 1.0 1.0 1.0 1.0
fade-bl2: fade-in-text/init 'fade-txt2 0.0 text3 fnt1 'words 100x700 1.0 1.0 5.0 0.5 0.2
fade-bl3: fade-in-text/init 'fade-txt3 0.0 text4 fnt1 'chars 100x1300 1.0 1.0 11.0 0.5 0.01

fade-bl4: fade-in-text/init 'fade-txt4 0.0 "Lines" fnt3 'words 380x2200 1.0 1.0 0.5 2.0 0.1
fade-bl5: fade-in-text/init 'fade-txt5 0.0 "Words" fnt3 'words 1500x2200 1.0 1.0 4.5 2.0 0.1
fade-bl6: fade-in-text/init 'fade-txt6 0.0 "Chars" fnt3 'words 2800x2200 1.0 1.0 10.5 2.0 0.1



append bez-test [line-cap round line-width 350 fill-pen transparent scale 0.1 0.1]
append/only bez-test collect [
    keep 'line
    repeat n lim [
        keep bezier-n bez-pts tt
        tt: n / lim
     ]
]    

view [
    title "Animate"
    bb: base 650x400 teal rate 120
    draw compose/deep [
        font fnt1
        fill-pen aqua
        pen yello
        scale 0.15 0.15 [
            box 0x0 5000x4000
            ;translate 0x300
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
        font fnt2
        pen1: pen 80.108.142.255
        translate 1000x50
        ;(bez-test)
        bz2: (draw-bl)
        
    ]
    on-time [
        tm: to float! difference now/precise st-time
        tween 'pen1/2/4 255 0 1.1 2.0 tm :ease-in-out-cubic
        tween 'st-txt  10000 0 1.5 6.0 tm :ease-in-out-quint
        text-along-curve 'text1 st-txt / 10000.0
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
        
        tween 'ln1/2/x 1450 2750 10.0 2.0 tm :ease-in-out-elastic
        tween 'ln1/3/x 2200 3350 10.0 2.0 tm :ease-in-out-elastic
        
    ]
    on-create [print "start" st-time: now/precise]
]
