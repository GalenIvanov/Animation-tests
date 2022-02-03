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

## Animation events

Before we start to animate the parameters of Draw commands, we need to indicate the reference frames.

    start <start> <duration> <delay> <ease> <loop> <actors>
    
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
    <count>     : 'forever | <n> 'times
    <n>         : how many times does the animatin repeat (integer!)
    
    <actors> are
    
    on-start     : triggered when the animation starts (block!)
    on-exit      : triggered when the animation ends (block!)
    on-time      : at each on-time event of the face. `time` word refers to the time elapsed from animation start.
	
### Examples:

    ref: start 2.0 duration 5.0
    start 1.0 before ref starts duration 2.0                  
    start when ref starts duration 3.0 ease :ease-in-out-cubic                 
    start 2.0 after ref starts duration 5.0              
    start 2.0 before ref ends duration 2.0 delay 1.0 ease :ease-in-out-cubic loop two-way
    start when ref ends duration 5.0 loop two-way forever
    start 2.0 after ref ends ease :ease-in-elastic loop 3 times
    

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
