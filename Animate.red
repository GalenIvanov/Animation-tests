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
    ease:  func [x][x]  ; easing function
    ease:  none         ; easing function
    loop:  'once        ; repetition of the effect in time
    fns:   copy []      ; a block of callback functions ; arity 2: [id time]
]

timeline: make map! 100 ; the timeline of effects key: value <- id: effect
                        ; there should be a record for each face!
time-map: make map! 100 ; for the named animations

particles-map: make map! 10 ; 

text-effect: make object! [
    id: none        ; 
    text: ""        ; text to render   
    font: none      ; font to use
    mode: 'chars    ; how to split the text  
    from: 'center   ; origin of scaling
    posXY: 0x0      ; where to place the text  
    sp-x:  1.0      ; spacing factor for X direction
    sp-y:  1.0      ; spacing factor for Y direction
    start: 0.0      ; starting time
    dur:   1.0      ; duration 
    delay: 0.1      ; delay between subanimations
    random: false
]

process-timeline: has [
    t target w
][
    t: to float! difference now/precise st-time
    foreach [_ val] timeline [
        w: val/2
        if w/val1 <> w/val2 [ tween val/1 w/val1 w/val2 w/start w/dur t :w/ease]
    ]
    ani-start/2: 0.1  ; refresh the draw block in case onli font or image parameters have been changed
]

particle: context [
    speck: [[fill-pen 200.200.255.50 circle 0x0 30]] ; a default template for particles

    particle-base: make object! [
        number:  1500                ; how many particles
        emitter: [10x-100 390x0]     ; where particles are born - a box
        velocity: [0.0 1.0]          ; x and y components of particle's speed.  
        scatter: [1.2 2.5 1.5 4.55]  ; variation of velocity [left rigth up down]
        shapes: copy speck           ; a block of blocks (shapes to be used to render particles)
        lifespan: 1.0                ; life of a particle in seconds
        forces: copy []              ; what forces affect the particles motion - a block of functions
    ]
    
    create-particle: func [
        proto [object!]
    ][
        pos: (proto/emitter/1 + random proto/emitter/2 - proto/emitter/1) * 10x10

        p-v: proto/velocity
        p-s: proto/scatter
        vel-x: p-v/1 - p-s/1 + random p-s/1 + p-s/2
        vel-y: p-v/2 - p-s/3 + random p-s/3 + p-s/4
        
        birth: round/to random proto/lifespan 0.001
        shape: random/only proto/shapes
        reduce [reduce [pos/x + vel-x pos/y + vel-y] reduce [vel-x vel-y] birth shape]
    ]
    
    init-particles: func [
        id    [word!]       ; particles set identifier
        proto [object!]     ; a copy of particle-base
        /local particles particles-draw
    ][
        particles-draw: make block! proto/number * 4
        append particles-draw compose [(to-set-word id) scale 0.1 0.1 translate 0x0]
        
        particles: collect [loop proto/number [keep/only create-particle proto]]
        put particles-map id particles
        
        append/only particles-draw collect [
            repeat i length? particles [
                keep compose/deep [
                    (to-set-word rejoin [id "-" i])
                    translate (as-pair round particles/:i/1/1 particles/:i/1/2)
                    [(particles/:i/4)]
                ]
            ]
        ] 
    ]
    
    update-particles: func [
        id [word!]
    ][
        p: particles-map/:id
        repeat i length? p [
            p/:i/1/1: p/:i/1/1 + p/:i/2/1
            p/:i/1/2: p/:i/1/2 + p/:i/2/2
            poke get to-word rejoin [id "-" i] 2 as-pair round p/:i/1/1 round p/:i/1/2
        ]
    ]

]

context [
    ani-bl: copy []
    draw-block: make block! 1000
    cur-effect: make block! 20
    delay-v: 0.0
    start-v: 0.0
    start-anchor: 0
    dur-v: 0.0
    ease-v: none
    ref-ofs: 0.0
    val-ofs: 1
    val-idx: 1
    cur-idx: 0
    target: none
    cur-target: none
    user-target: none
    cur-effect: none
    time-id: none
    cur-ref: none
    scaled: none
    from-count: 0
    text-fx-id: 1
    t-fx: none
    st: none
    time-dir: 1  ; for referencing animations anchors, -1 means backwards
    t-offs: none
    
    make-effect: does [
        ani-bl: copy/part to-block effect 10
        append ani-bl [ease: none] 
        ani-bl/val1: v1
        ani-bl/val2: v2
        ani-bl/start: start-v
        ani-bl/dur: any [dur-v 1.0]
        ani-bl/delay: any [delay-v 0.0]
        ani-bl/ease: any [:ease-v to get-word! "ease-linear"]
    ]    
    
    do-not-scale: [
        [circle 3]
        [circle 4]
        [circle 5] 
        [arc 4]
        [arc 5]
        [rotate 2]          ; assuming no 'pen or 'fill-pen !!!   
        [scale 2]           ; assuming no 'pen or 'fill-pen !!!
        [scale 3]           ; assuming no 'pen or 'fill-pen !!!
        [skew 2]
        [skew 3]
        [transform 2]       ; rotate  - I need to account for <center> where necessary
        [transform 3]       ; scale x - I need to account for <center> where necessary
        [transform 4]       ; scale y - I need to account for <center> where necessary
    ]
    
    rescale: does [
        if all [
            find [integer! float! pair!] type?/word scaled
            not find/only do-not-scale reduce[target val-idx]
        ] [scaled: scaled * 10]
    ]
    
    value: [set scaled [float! | tuple! | string! | object! | image! | integer! | pair!] (rescale)]
    
    start: [
        [
            p: 'start  (
                start-v: 0.0
                time-dir: 1
                ease-v: none
                ref-ofs: 0
                if cur-ref [   ; reg the previously named entry
                    put time-map cur-ref reduce [start-anchor dur-v delay-v from-count]
                    time-map/:cur-ref 
                ]
            ) 
            [
            set st [number! ahead not ['when | 'after | 'before]] (start-v: st)
            | [
                opt set t-offs number!
                ['when | 'after | 'before (time-dir: -1)]
                set ref word! (id: time-map/:ref start-v: id/1)
                [
                    'starts (ref-ofs: 0)
                  | 'ends (
                        ref-ofs: id/3 * id/4 + id/2
                        from-count: 0 ; ???
                    )
                ]
            ]
            ]
        ](
            t-offs: any [t-offs 0.0] 
            start-v: t-offs * time-dir + ref-ofs + start-v
            start-anchor: start-v
            cur-ref: time-id
            ref-ofs: 0
            t-offs: none
            delay-v: 0.0
            st: none
        )
    ]
    
    dur: [['duration set d number!] (dur-v: d)]
    
    delay: [['delay set dl number!](delay-v: dl)]
    
    ease: ['ease set ease-v any-word!]
    
    from-value: [set v2 word! | value (v2: scaled)]
    
    from: [
        ['from p1: [[set v1 keep word!] | value keep (scaled) (v1: scaled)]
         'to p2: from-value] (
            make-effect
            cur-effect: make effect ani-bl
            trgt: to-path reduce [to-word cur-target val-ofs]
            cur-effect/start: start-v
            ;print ["current ani-bl" form ani-bl]
            put timeline to-string trgt reduce [trgt cur-effect]
            start-v: start-v + delay-v
            from-count: from-count + 1
         )
    ]
    
    ; non Draw parameters and -fx parameters - too similar to form - must be merged!
    ; I need to automatically scale up the font sizes !!!
    from-fx: [
        ['from p1: from-value 'to p2: from-value] (   
            val-ofs: val-ofs + 1
            ani-bl/val1: p1/1
            ani-bl/val2: p2/1
            cur-effect: make effect ani-bl
            cur-effect/start: start-v
            start-v: start-v + delay-v
            put timeline rejoin [to-string cur-target cur-idx] reduce [cur-target cur-effect]
            from-count: from-count + 1
        )
    ]
     
    
    param: [
        'parameter
        set t [path! | word!] (cur-target: t cur-idx: cur-idx + 1)
        from-fx
    ]
    
    word: [                             ; Draw commands and markers for them
        opt set user-target set-word!
        p: word! (                
            val-ofs: 1
            val-idx: 1
            target: p/1
            cur-target: any [user-target rejoin [p/1 cur-idx: cur-idx + 1]]
            if find [image font linear radial diamond pattern bitmap] p/1 [val-ofs: val-ofs + 1]
            user-target: none
        )
        :p keep (to-set-word cur-target)
        keep word!
    ]
    
    scale-origin:  func [
        txt  "target text object"
        n    "index of text part to adjust"
        mode "scale origin"
        sc   "scale factor"
    ][
       sc-p: select [     ; scale adjustments
            top-left:     -2x-2
            top:          -2x-2 
            top-right:    2x-2 
            left:         -2x-2 
            center:       0x0 
            right:        2x-2 
            bottom-left:  -2x2 
            bottom:       -2x2 
            bottom-right: 2x2 
        ] mode
        pos: txt/:n/2 
        size: txt/:n/3
        size / 2 * sc-p * sc + size / 2 + pos
    ]
    
    scale-adjust: func [
        txt  "target text object"
        n    "index of text part to adjust"
        mode "scale origin"
        sc   "scale factor"
    ][
       sc-adj: select [  
            top-left:     0x0
            top:          0x0 
            top-right:    -2x0 
            left:         0x0 
            center:       -1x-1 
            right:        -2x0
            bottom-left:  0x-2 
            bottom:       0x-2
            bottom-right: -2x-2 
        ] mode
        sc-adj * sc * txt/:n/3 / 2
    ]
    
    scale-text-fx: func [
        txt-obj
        v1
        v2
        time
    ][
        txt: text-data/(txt-obj/id)/2
        mode: text-data/(txt-obj/id)/4/from
        sp-x: text-data/(txt-obj/id)/4/sp-x
        sp-y: text-data/(txt-obj/id)/4/sp-y
        
        dly: delay-v / text-data/(txt-obj/id)/4/delay
        
        repeat n length? txt [
            make-effect            
            ani-bl/start: txt/:n/5 * dly + time
            
            cur-target: to-path reduce [to-word rejoin [t-obj/id "-" n] 5 2]
            ani-bl/val1: v1/1
            ani-bl/val2: v1/2
            cur-effect: make effect ani-bl
            put timeline to-string rejoin [cur-target cur-idx] reduce [cur-target cur-effect]
            
            cur-target: to-path reduce [to-word rejoin [t-obj/id "-" n] 5 3]
            ani-bl/val1: v2/1
            ani-bl/val2: v2/2
            cur-effect: make effect ani-bl
            put timeline to-string rejoin [cur-target cur-idx] reduce [cur-target cur-effect]
                        
            sc-t: max v1/1 v2/1
            ani-bl/val1: scale-origin txt n mode sc-t
            if any [v1/1 > v1/2 v2/1 > v2/2] [
                ani-bl/val1: ani-bl/val1 + scale-adjust txt n mode sc-t
            ]
            
            sc-t: max v1/2 v2/2
            ani-bl/val2: (scale-origin txt n mode sc-t) + scale-adjust txt n mode sc-t
            scale-from: text-data/(txt-obj/id)/effect/from
            if (scale-from <> 'center) and to logic! any [v1/1 > v1/2 v2/1 > v2/2] [
                ani-bl/val2: scale-origin txt n mode sc-t
            ]
            
            ;txt/:n/2: ani-bl/val2
            ;txt/:n/3/x: to integer! txt/:n/3/x * sc-t
            ;txt/:n/3/y: to integer! txt/:n/3/y * sc-t
             
            cur-effect: make effect ani-bl
            cur-target: to-path reduce [to-word rejoin [t-obj/id "-" n] 4]
            put timeline to-string rejoin [cur-target cur-idx] reduce [cur-target cur-effect]
        ]
        cur-idx: cur-idx + 1 
    ]
    
    text-color: func [
        txt-obj
        v1
        v2
        time
    ][
        txt: text-data/(txt-obj/id)
        dly: delay-v / text-data/(txt-obj/id)/4/delay
        n: 1
        foreach item txt/chunks [
            make-effect            
            ani-bl/start: item/5 * dly + time
            ani-bl/val1: v1
            ani-bl/val2: v2
            cur-effect: make effect ani-bl
            fnt-id: to word! rejoin [item/1 "-fnt"]
            cur-target: to path! reduce [fnt-id 'color]
            put timeline to-string rejoin [fnt-id cur-idx] reduce [cur-target cur-effect]
            n: n + 1
        ]
        cur-idx: cur-idx + 1 
    ]
    
    text-move: func [
        txt-obj
        val
        time
    ][
        txt: text-data/(txt-obj/id)
        val: val * 10
        dly: delay-v / text-data/(txt-obj/id)/4/delay
        n: 1
        foreach item txt/chunks [
            make-effect            
            ani-bl/start: item/5 * dly + time
            ani-bl/val1: item/2
            ani-bl/val2: item/2 + val
            cur-effect: make effect ani-bl
            cur-target: to-path reduce [to-word rejoin [t-obj/id "-" n] 4]
            put timeline to-string rejoin [cur-target cur-idx] reduce [cur-target cur-effect]
            n: n + 1
        ]
        cur-idx: cur-idx + 1 
    ]
   
    from-text: [['from set v1 value 'to set v2 value] | set v1 value (v2: v1)]
    
    text-fx: [
        'text-fx
        [set txt-w word! | object!] (
            t-obj: get txt-w
            unless text-data/(t-obj/id) [
                fx-data: init-text-fx t-obj/id t-obj delay-v
                text-fx-id: text-fx-id + 1
            ]    
            from-count: length? text-data/(t-obj/id)/chunks  ; counted only once for text-scale, tex-color and text-move
        )
        if (text-data/(t-obj/id)) keep (fx-data)
        opt [['text-scale from-text (val1: reduce [v1 v2]) from-text (val2: reduce [v1 v2])]
            (scale-text-fx t-obj val1 val2 start-v)]
        opt ['text-move set v1 value (text-move t-obj v1 start-v)]
        opt ['text-color from-text (text-color t-obj v1 v2 start-v)]
    ]
    
    command: [
        (time-id: none)
        opt [set time-id [set-word! ahead 'start]]   ; named animation
        opt start
        opt dur
        opt delay
        opt ease
        ;opt 'loop
    ]
    
    anim-rule: [
        collect [
            some [
                command
                opt [
                    param
                  | text-fx
                  | word                                ; Draw command
                    opt keep [not 'from not 'to word!](val-ofs: val-ofs + 1 val-idx: val-idx + 1)  ; word parameter, like font or image value
                    any [[from | value keep (scaled) ](val-ofs: val-ofs + 1 val-idx: val-idx + 1)]  ; parameters, incl. animated ones
                  | into anim-rule                      ; block 
                ]                                      
              
            ]
        ]    
    ]

    set 'parse-anim func [
        {Takes a block of draw and animate commands and generates a draw block
        for the target face and a timeline for the animations}
        spec   [block!]               {A block of draw and animate commands}
        target [word! path! object!]  {A face to render the draw block and animations}
    ][
        
        draw-block: parse spec anim-rule
        insert draw-block compose [(to set-word! "ani-start") scale 0.1 0.1]
        ;probe draw-block
        ;probe ani-bl
        target/draw: draw-block
       
        actors: make block! 10
        append clear actors [on-time: func [face event][process-timeline]]
        target/actors: object actors
        
        st-time: now/precise  
    ]
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
    target   [word! any-path!]      {the word or path to set}
    val1     [number! pair! tuple!] {Value to interpolate from}
    val2     [number! pair! tuple!] {Value to interpolate to}
    start    [float!]               {Start of the time period}
    duration [float!]               {Duration of the time period}
    t        [float!]               {Current time}
    ease     [function!]            {Easing function}
][
    end-t: duration * 1.09 + start  ; depends on the easing!
    if all [t >= start t <= end-t][
        either t < (start + duration) [
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
        ][set target val2]
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
    pos  [pair!]     {coordinates of the starting point}
    sx   [number!]   {x spacing factor}
    sy   [number!]   {y spacing factor} 
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
                (
                    c-offs: caret-to-offset txt index? p  
                    c-offs/x: to integer! c-offs/x * sx
                    c-offs/y: to integer! c-offs/y * sy
                    c-offs: 10x10 * pos + c-offs  
                    keep/only reduce [
                        c-offs                        ; position  
                        size-text/with txt1 t         ; size 
                        t                             ; text
                    ]
                )
              | skip
            ]
        ]
    ]
]

init-text-fx: function [
    id     [any-word!]
    t-spec [block!]
    delay  [number!]
][
    
    either not text-data/:id [        ;init
        t-obj: make text-effect t-spec
        t-obj/delay: delay
        ; t-obj/dur: duration
        t-obj/font/size: t-obj/font/size * 10  ; upscale the provided font!
        chunks: split-text t-obj/text t-obj/font t-obj/mode t-obj/posXY t-obj/sp-x t-obj/sp-y ; too many args
        starts: collect [
            st: 0.0
            repeat n length? chunks [
                keep st
                st: round/to st + delay 0.001
           ]
        ]
        
        if t-obj/random [random starts]
        
        repeat n length? chunks [
            fnt-name: rejoin [id "-" n]
            insert chunks/:n fnt-name
            append chunks/:n reduce [starts/:n t-obj/dur]
        ]
            
        put text-data id compose/deep [chunks: [(chunks)] effect: (t-obj)]
        
        collect [
            foreach item chunks [
                fnt-name: to-word rejoin [item/1 "-fnt"]
                fnt: copy t-obj/font
                set fnt-name fnt
                fnt-id: to set-word! item/1
                keep compose/deep [
                    (fnt-id) font (fnt-name)
                    translate (item/2) [ 
                        scale 1.0 1.0 
                        rotate 0.0 (item/3 / 2)
                        text 0x0 (item/4)
                    ]
                ]
            ]
        ] 
    ][  ; animate
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
