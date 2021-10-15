Red [
    title: "Animation dialect tests"
    author: "Galen Ivanov"
    needs: view
]

st-time: now/precise
pascal: none
text-data: make map! 100

random/seed now

effect: make object! [
    val1:  0.0          ; starting value to change
    val2:  1.0          ; end value
    start: 0.0          ; starting time
    dur:   1.0          ; duration of the animation
    delay: 0.0          ; delay between successive subanimations
    ease:  none         ; easing function
    loop:  'once        ; repetition of the effect in time
    fns:   copy []      ; a block of callback functions ; arity 2: [id time]
]

timeline: make map! 100 ; the timeline of effects key: value <- id: effect
                        ; there should be a record for each face!

text-effect: make object! [
    text: ""        ; text to render   
    font: none      ; font to use
    mode: 'chars    ; how to split the text  
    from: 'center   ; origin of scaling
    posXY: 0x0      ; where to place the text  
    sp-x:  1.0      ; spacing factor for X direction
    sp-y:  1.0      ; spacing factor for Y direction
    start: 1.0      ; starting time
    dur:   1.0      ; duration 
    delay: 0.1      ; delay between subanimations
]

process-timeline: has [
    t target w
][
    t: to float! difference now/precise st-time
    foreach [_ val] timeline [
        w: val/2
        tween val/1 w/val1 w/val2 w/start w/dur t :w/ease
    ]
]

parse-anim: function [
    {Takes a block of draw and animate commands and generates a draw block
    for the target face and a timeline for the animations}
    spec   [block!]               {A block of draw and animate commands}
    target [word! path! object!]  {A face to render the draw block and animations}
][
    value: [number! | pair! | tuple! | string! | object! | image!]
    
    start: [
        ['start set st number! (start-v: st)
            opt [
                'after set ref word! (ref-ofs: 10 {ref's start + dur})  ; relative to the end of the specified animation
              | 'along set ref word! (ref-ofs: 20 {ref's start})  ; relative to the start of the specified animation
            ]
        ] (ani-bl append clear ani-bl compose [start: (st + ref-ofs)])
    ]
    
    dur: [['duration set d number!] (append ani-bl compose [dur: (d)])]
    
    delay: [['delay set dl number!](delay-v: dl append ani-bl compose [delay: (dl)])]
    ; ease should be able to accept user-defined functions as well!
    ease: [['ease set e any-word!](append ani-bl compose [ease: (e)])]
    
    from: [
        ['from keep p1: value 'to p2: value]
        (    
             append ani-bl compose [val1: (p1/1)]
             append ani-bl compose [val2: (p2/1)]
             cur-effect: make effect ani-bl
             trgt: to-path reduce [to-word cur-target val-ofs + 1]
             start-v: start-v + delay-v
             cur-effect/start: start-v
             put timeline to-string trgt reduce [trgt cur-effect]
             val-ofs: val-ofs + 1
         )
    ]
    
    ; non-standard Draw parameters and -fx parameters
    from-fx: [
        ['from p1: value 'to p2: value]
        (   
            append ani-bl compose [val1: (p1/1)]
            append ani-bl compose [val2: (p2/1)]
            cur-effect: make effect ani-bl
            trgt: to-path reduce [to-word cur-target cur-fld]
            start-v: start-v + delay-v
            cur-effect/start: start-v
            put timeline to-string trgt reduce [trgt cur-effect]
        )
    ]
    
    word: [p: word! (val-ofs: 1                        ; Draw commands and markers for them
           cur-target: rejoin [p/1 cur-idx: cur-idx + 1])
           :p keep (to-set-word cur-target)
           keep word!
    ]
    
    font: [
        keep 'font keep [set font-name word! | object!]
        (cur-target: either font-name [
             font-name
         ][
            rejoin ['ani-font cur-idx: cur-idx + 1]
        ]
        )
        any [
            ['font-size  (cur-fld: 'size)
          | 'font-color (cur-fld: 'color)
          | 'font-angle (cur-fld: 'angle)]
             [from-fx | integer! | tuple!]
        ] 
    ]
    
    ;word: [
    ;    sw: [opt set-word!] (print sw/1 cur-target: sw/1 setw: true)
    ;    p: word!                        ; Draw commands and markers for them         
    ;    (val-ofs: val-ofs + 1
    ;    unless setw [cur-target: rejoin [p/1 cur-idx: cur-idx + 1]])
    ;    :p if (not setw) keep (to-set-word cur-target) skip keep word! (setw: false)
    ;]
        
    command: [
        opt start
        opt dur
        opt delay
        opt ease
        opt 'loop
        opt font
    ]
    
    anim-rule: [
        collect [
            some [
                    command
                    opt keep set-word!                             ; displaces the value a set-word! is pointing to!
                    word                                           ; Draw command
                    any [keep value (val-ofs: val-ofs + 1) | from] ; parameters, incl. animated ones
               | into anim-rule                                    ; block 
            ]
        ]    
    ]

    ani-bl: copy [ease: :ease-linear]
    draw-block: make block! 1000
    cur-effect: make block! 20
    delay-v: 0.0
    start-v: 0.0
    ref-ofs: 0.0
    val-ofs: 1
    cur-idx: 0
    cur-target: none
    cur-effect: none
    cur-fld: none
    font-name: none
    setw: false
    
    draw-block: parse spec anim-rule
    ;probe draw-block
    ;probe ani-bl
    target/draw: draw-block
    
    actors: make block! 10
    append clear actors [on-time: func [face event][process-timeline]]
    target/actors: object actors
    
    st-time: now/precise  
]

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

tween: function [
    {Interpolates a value between value1 and value2 at time t
    in the stretch start .. start + duration using easing function ease}
    target   [word! any-path!]          {the word or path to set}
    val1     [number! pair! tuple!] {Value to interpolate from}
    val2     [number! pair! tuple!] {Value to interpolate to}
    start    [float!]               {Start of the time period}
    duration [float!]               {Duration of the time period}
    t        [float!]               {Current time}
    ease     [function!]            {Easing function}
][
    end-t: start + duration * 0.995  ; depends on the easing!
    if all [t >= start t <= end-t][
        either tuple? val1 [
            val: val1
            repeat n length? val1 [
                val/:n: to integer! val1/:n + (val2/:n - val1/:n * ease t - start / duration) % 256
            ]
        ][
            val: val1 + (val2 - val1 * ease t - start / duration)  
            if integer? val1 [val: to integer! val]
        ]    
        set target val
    ]
    if all [t > end-t t <= (start + duration)][
        set target val2
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
    new-src: head append copy src "|"  ; to find the last offset
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
    size: as-pair fnt/size * length? src fnt/size
    txt: make face! compose [size: (size)  type: 'text text: (src)]
    txt/font: copy fnt
    size-text txt
]

split-text: function [
    {Splits src on characters, words (on spaces and newlines) 
    or lines (on newlines) and returns a block of blocks,  
    each consisting of position, size and substring}
    src  [string!]   {Text to split}
    fnt  [object!]   {Font to use for measurements}
    mode [any-word!] {chars, words or lines}
][
    size: as-pair fnt/size * length? src fnt/size
    txt: make make-face 'rich-text compose [size: (size) text: (src)]
    txt/font: copy fnt
    txt1: make face! compose [size: (size)  type: 'text text: (src)]
    txt1/font: copy fnt
    rule: select [chars [skip] words [space | newline] lines [newline]] mode
    
    collect [
        parse src [
            any [
                p: copy t thru [rule | end] 
                (keep/only reduce [
                    caret-to-offset txt index? p  ; offset
                    size-text/with txt1 t         ; size 
                    t                             ; text
                ])
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
        t-spec [block!]    {specification of the text effect}
    /rand    
][
    either init [   ; initialize
        t-obj: make text-effect t-spec
        chunks: split-text t-obj/text t-obj/font t-obj/mode
        starts: collect [
            st: t-obj/start
            repeat n length? chunks [
                keep st
                st: st + t-obj/delay
            ]
        ]
        if rand [random starts]
        
        repeat n length? chunks [
            fnt-name: rejoin [id "-fnt-" n]
            insert chunks/:n fnt-name
            append chunks/:n reduce [starts/:n t-obj/dur]
        ]
        
        put text-data id compose/deep [chunks: [(chunks)]]
        
        collect [
            foreach item chunks [
                fnt-name: to-word rejoin [item/1 "_"]
                set fnt-name copy t-obj/font
                fnt-id: to set-word! item/1
                posx: item/2/x * t-obj/sp-x
                posy: item/2/y * t-obj/sp-y
                p: as-pair posx posy
                keep compose [
                    (fnt-id) font (get fnt-name)
                    text (t-obj/posXY + p) (item/4)
                ]
            ]
        ]    
    ][  ; animate
        foreach item text-data/:id/chunks [
            fnt-id: get to word! rejoin [item/1 "_"]
            name: get to word! item/1
            name/4: name/4  ; refresh
            tween 'fnt-id/color/4 255 0 item/5 item/6 t :ease-in-out-quart
        ]
    ]
]

scale-text: function [
    {Animate the text so that each component scales up
    from zero to its actual size, centered about itself}
    id         [any-word!] {identifier for the effect}
    t          [float!]    {current time}
    /init
        t-spec [block!]    {specification of the text effect}
    /rand    
][
    either init [   ; initialize
        t-obj: make text-effect t-spec
        chunks: split-text t-obj/text t-obj/font t-obj/mode
        starts: collect [
            st: t-obj/start
            repeat n length? chunks [
                keep st
                st: st + t-obj/delay
            ]
        ]
        if rand [random starts]
        
        repeat n length? chunks [
            append chunks/:n reduce [starts/:n t-obj/dur]
            name: to-set-word rejoin [id "_" n]
            insert chunks/:n name
        ]
        put text-data id compose/deep [effect: (t-obj)chunks: [(chunks)]]
        
        collect [
            n: 0
            foreach item chunks [
                keep compose/deep [
                    (item/1)
                    translate 0x0 [
                        scale 0.0 0.0
                        text 0x0 (item/4)      
                    ]    
                ]
            ]
        ]    
    ][  ; animate
        t-obj: text-data/:id/effect
        set [sc-p sc-x sc-y] select [     ; scale adjustments
            top-left:     [0x0 0.0 0.0]
            top:          [0x0 1.0 0.0]
            top-right:    [2x0 0.0 0.0]
            left:         [0x0 0.0 1.0]
            center:       [1x1 0.0 0.0]
            right:        [2x0 0.0 1.0]
            bottom-left:  [0x2 0.0 0.0]
            bottom:       [0x2 1.0 0.0]
            bottom-right: [2x2 0.0 0.0]
        ] t-obj/from
              
        foreach item text-data/:id/chunks [
            name: get item/1
            posx: item/2/x * t-obj/sp-x 
            posy: item/2/y * t-obj/sp-y
            p: as-pair posx posy
            d: item/3 / 2
            
            tr1: t-obj/posXY + p + (d * sc-p)
            tr2: t-obj/posXY + p
            tween 'name/2     tr1    tr2 item/5 item/6 t :ease-in-out-elastic ; translate
            tween 'name/3/2   sc-x   1.0 item/5 item/6 t :ease-in-out-elastic ; scale
            tween 'name/3/3   sc-y   1.0 item/5 item/6 t :ease-in-out-elastic
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

; tests were moved to separate files
