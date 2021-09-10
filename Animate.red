Red [
    Title: "Animation with Red"
    Author: "Galen Ivanov"
]

rot: 0
trans: 0x0
st-time: 0

; Easing functions
easeInOutQubic: func [x][either x < 0.5 [x ** 3 * 4][1 - (-2 * x + 2 ** 3 / 2)]]



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

roll-the-box: func [
    /local frame val
]    
[
    now/precise 
    frame: to float! difference now/precise st-time 
    frame: frame % 1.0 ; map to 0..1 by getting the fractional part = one second
	    
    rot: 90 * val: easeInOutQubic frame
    if frame > 0.97   [
        st-time: now/precise
        rot: 0
        trans: trans + 100x0 % 700x10
        roll/2: trans
    ]
    roll/3/2: rot
]

view [
    title "Rolling box"
    base 600x200 teal rate 120
    draw [
        line 0x180 600x180
        fill-pen yello
        roll: translate 0x0 [rotate 0 0x180 [box -100x80 0x180]]
		slide: translate 0x0 [box 0x10 20x30]
		box2: scale 1 1 scale 'pen 1 1 [fill-pen sky bx: box 50x50 80x80]
    ]
    on-time [
    	;roll-the-box
		slide/2/x: to integer! tween 0 580 0.0 10.0 to float! difference now/precise st-time :easeInOutQubic
		;box2/2: tween 1 10 0.0 5.0 to float! difference now/precise st-time :easeInOutQubic
		bx/3/x: to integer! tween 80 500.0 2.0 4.0 to float! difference now/precise st-time :easeInOutQubic
		;box2/6: tween 1 0.1 0.0 5.0 to float! difference now/precise st-time :easeInOutQubic
	]
    on-create [st-time: now/precise]
]