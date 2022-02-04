# Animation dialect for Red

**Animate** is an experimental animation dialect. It's main goal is to provide the programmers with an easy declarartive way to describe simple animation as an extenson to Draw. It also provides mechanism for animating arbitrary word! or path! values.

## Tween

At the heart of Animate is the process known as Inbetweening - that is generating intermediate frames between two keyframes. Animate uses a function called `tween` for this. It's syntax is as follows:

    tween <target> <va11> <val2> <start> <duration> <t> <ease>
  
    <target>   :  the word or path to set to the calculated value (word! any-path!)      
    <val1>     :  Value to interpolate from  (number! pair! tuple!)
    <val2>     :  Value to interpolate to  (number! pair! tuple!) 
    <start>    :  Start of the time period (number!)
    <duration> :  Duration of the time period (number!)
    <t>        :  Current time (number!)   
    <ease>     :  Easing function (function!)
    

`tween` uses the indicated easing function to interpolate a value between `val1` and `val2` for time `t` in the time interval from `stat` to `start + duration`. The target can be any word or path. Using explicit calls to `tween` you can animate anithing in Red, including GUI controls.

There are severeal predefined easing functions:

- ease-linear
- ease-in-sine
- ease-out-sine
- ease-in-out-sine
- ease-in-out-power
- ease-in-quad
- ease-out-quad
- ease-in-out-quad
- ease-in-cubic
- ease-out-cubic
- ease-in-out-cubic
- ease-in-quart
- ease-out-quart
- ease-in-out-quart
- ease-in-quint
- ease-out-quint
- ease-in-out-quint
- ease-in-expo
- ease-out-expo
- ease-in-out-expo
- ease-in-circ
- ease-out-circ
- ease-in-out-circ
- ease-in-back
- ease-out-back
- ease-in-out-back
- ease-in-elastic
- ease-out-elastic
- ease-in-out-elastic
- ease-in-bounce
- ease-out-bounce
- ease-in-out-bounce
- ease-steps

## Animate and Draw

The main goal of Animate is to extend Draw in the time domain. This is done by using "augmented" draw block. Every block of Draw commands is a valid animation block. In order to animate the various Draw primitives, Animate introduces new keywords. Before we present them, let's see how the infrastructure works.

    anim-block: [
        ; Draw and Aniamate commands
    ]
    
    view [
        canvas: base 600x400 rate 60
        on-create [animate anim-block face]
    ]

The `animate` function parses a block of draw and animation commands, creates a Draw block for the given face and prepares all the tweens for the the animation.

    animate <commands> <face>
    
    <commands> : a block of Draw and animate commands (block!)
    <face>    :  a View face (a face to attach the generated Draw block to)

## Animation reference frames

Before we start to animate the parameters of Draw commands, we need to indicate the reference frames.

    start <start> <duration> <delay> <ease> <loop>
    
    <start>      : starting time (<anim-start>)
    <duration    : (optional) duration of the animation (number!). Default value 1.0
    <delay>      : (optional) delay between successive subanimations (number!). Default value 0.0
    <ease>       : (optional) easing function (function!). Default value  :ease-linear
    <loop>       : (optional) how does the animation repeat  (<anim-loop>). Default - no repetition
    <actors>     : (optional) actors for the animatin events (<anim-actors>)
        
    <anim-start> : <start-n> | <adverb> <ref> <end>
    <start-n>    : (optional) time in seconds (number!)
    <adverb>     : relation to the reference animation (word!)
    <ref>        : reference animation already declared (word!)
    <end>        : which side (word!)
    
    <adverb> is one of the following:
    - when
    - after
    - before 
    
    <end> is one of:
    - starts
    - ends
    
    anim-loop>  : <two-way> <count>
    <two-way>   : (optional) 'two-way (the animation repeats backwards)
    <count>     : (optional) 'forever | <n> 'times
    <n>         : how many times does the animatin repeat (integer!)
    
	
### Examples - start:

    ref: start 2.0 duration 5.0
    start 1.0 before ref starts duration 2.0                  
    start when ref starts duration 3.0 ease :ease-in-out-cubic                 
    start 2.0 after ref starts duration 5.0              
    start 2.0 before ref ends duration 2.0 delay 1.0 ease :ease-in-out-cubic loop two-way
    start when ref ends duration 5.0 loop two-way forever
    start 2.0 after ref ends ease :ease-in-elastic loop 3 times
    
## From

The values set by `start` are used until the next `start` construct. A set-word! can precede `start` and thus the following animation frames can refer to it.
The `start` declaration does not animate anything by itself. In order to animate a value, one needs to use `from value1 to value2` syntax:

    from <value> to <value> <actors>
    
    <value>  : start or end value to be animated (number! pair! tuple!)
    <actors> : (optional) <event> block!
    
    Actors specify blocks of code that is evaluated at specific animation events. Events are:
    
    on-start  : once, at the animation start
    on-exit   : once, when the animation ends
    on-time   : each time the animation is updated. 
    
 `on-time` is trigered at the rate specified by the face to which the draw block is attached. `time` word can be used within the block following `on-time` - it holds the time elapsed from the animation start.
    
    
All numeric values in an animation block can be animated using `from` - integers, floats, pairs and tuples (for colors).

### Examples - from

    line-width from 1 to 10
    pen from black to red
    translate from 0x0 to 100x25 on-start [started: true]
    scale from 0.0 to 1.0 1.0 on-time [label/data: time] 
    box 10x10 from 10x10 to 200x50 one-exit [print "Finished!"]
    
Each `from` construct is translated at the parse time to a call to `tween` function. 

If `delay` in a `start` reference frame is non-zero, each animation defined by `from` starts the amount of `delay` later than the previous. That is why the actors are defined at `from` level and not at the `start` level. `start` could define a reference frame that starts at 1.0 with duration 5.0 and delay 1.0. If there are 3 values animated with `from`, the first one will start at 1.0, the second - at 2.0 and the third will start at 3.0 and will finish at 8.0. With actors defined at `from` level one can monitor each effect independently. That wouldn't have been possible if actors were used at `start` level.
Next `start` resets the delay.


# Effects

`Animate` introduces several effects that are meant to automate some of the more frequently used tasks in animations.

## Particles

`particles` animates a simple particle system:

    particles <id> <prototype> <expires> <actors>
     
    <id>        : effect identifier (word!)
    <prototype> : a block describing the particles (block! word!)
    <expires>   : (optional) when to clear the effect's draw black
    <actors>    : (optional) actors for the events

Prototype is a block of set-word! and value pairs that is used to create each individual partilce as well as to set up the entire effect:

    
    number:     <integer!>
    emitter:    [<pair!> <pair!>]
    direction:  <integer float!>
    dir-rnd:    <integer float!>
    speed:      <integer float!>
    speed-rnd:  <integer float!>
    shapes:     <block!>
    limits:     <block!>
    new-coords: <block!>
    forces:     <block> 
    

All of the above pairs are optional. If some is not present, the default value is obtaind from the prototype object:

    particle-base: make object! [
        number:     100                  ; how many particles
        emitter:    [0x100 200x100]      ; where particles are born - a box
        direction:  90.0                 ; degrees
        dir-rnd:    0.0                  ; random spread of direction, symmetric
        speed:      1.0                  ; particle base speed
        speed-rnd:  0.2                  ; randomization of speed for each particle, always added
        shapes:     speck                ; a block of draw blocks (shapes to be used to render particles)
        limits:     []                   ; conditions for particle to be respawned - based on coordinates 
        new-coords: []                   ; where reposition the particle
        forces:     []                   ; what forces affect the particles motion - a block of words
    ]


### Generation

`emitter` is a block of two pairs that form a box. Each particle is born initially at a random place in this rectangular area. `direction` indicates in which direction the particle will be moving in degrees. `dir-rnd` adds randomness to the direction. `speed` and `speed-rnd` define the particle's speed. `shapes` is a block of draw block that are used to display the particles. The shapes in block are randomly chosen at the initialization phase.

### Movement

At each frame the position of each particle is updated using `speed`, `direction`. `speed` and `direction` are influenced by any functions in the `forces` block. There are two pre-defined functions: `gravity` and `drag`. Each force- function should receive two arguments - `dir` and `speed` (current partilce's direction anfle and speed) and should return a block [dir speed].

**Example force- function**

    drag: func [dir speed][
        speed: speed * 0.99
        reduce [dir speed]
    ]

### Respawn particles

Particles coordinates are tested against the rule for `x` and `y` in the `limits` block. If the rule returns `false`, the particle's position is reset using the the values for `x` and `y` set in `new-coords` block.

**Examples for `limits`**

    [x > 550 y < 60]
    [120.0 < sqrt x - 300.0 ** 2 + (y - 200.0 ** 2)] 
    
**Examples for `new-coords`**

    [x: 300.0 y: 200.0]
    [x: 455.0 + random 90.0 y: 340.0]    


### Expires

Since a particle effect usually displays hunderds and thousands of objects, it's to free the drawing resources when the effect finishes. `expires` and optional and if not present, the last drawn frame is kept in draw block. 

    expire after <time>
    
    <time>  : how many seconds after the beginning of the effect to clear the effect's draw commands (integer! float!)
    
The starting time of `particles` is taken from the last `start` (and subsequent `from`, if `delay` is non-zero). `duration` and `ease` - too. Looping doesn't make much sense for particle effects and that's why is not supported.


### Actors

`particles` and all other effects in `animate` support the same actors as `from`.


## Curve-fx

`curve-fx` flows a text or one or several draw blocks along a Bézier curve. Standard Bézier curves in Draw support 3 or 4 points. `curve-fx` supports up tp 30 points (not-thoroughly tested!).

    curve-fx <id> <effect> <value> <expires> <actors>
    
    <id>       : effect identifier (word!)
    <effect>   : effect data (block! word!)
    <value>    : position on the curve (float! <from value1 to value2>)
    <expires>  : (optional) when to clear the effects draw block (same as particles)
    <actors>   : (optional) on event actors (same as from)

Effect data is a block with set-word! and value pairs: 

    
    data: <string! block!>     (text or block of draw blocks)
    font: <object! word>       (optional - if data is a string)
    curve: <block!>            (a block of pairs - pointos of the Bézier curve)
    space-x: <float! integer!> (character spacing for strings - float!, or horizontal offset between blocks)

### Example - curve-fx

    fnt1: make font! [name: "Verdana" size: 16 color: black]
    red-text: "Red is a next-gen programming language, strongly inspired by REBOL"
    bez-pts: [50x40 370x-120 350x100 250x400 620x200] 
    red-info: [data: red-text font: fnt1 curve: bez-pts space-x: 0.98]
    
    block: [
        font fnt1
        start 1.0 duration 2.0 delay 1.0 ease :ease-in-out-cubic
        curve-fx Red-lang red-info from 1.0 to 0.0 expires after 5
    ]	
    

If the effect's data is block of draw blocks, the blocks are translated and orientd on the curve one after another starting at the current position and adding the offset along the curve.

## Text-fx

## Stroke-path

## Morph path



# Ideas for future work
There are many things that can be added to the animation system:

## Animation control
- pause
- resume
- stop
- rewind
- ffd
- change animation speed

## Text-fx to work on specified parts of text
Now it works on all components, depending on the mode - lines, words or characters. It would be good to specify which ones to animate. Possible parameters: index, range, or block of indices.

## Frames - an effect that changes the content of an image frame by frame

## 2d Arrays
- rectangular
- polar

## Parallax effect
