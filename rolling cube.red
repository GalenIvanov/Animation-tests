Red [
    Title: "Rolling box"
    Author: "Galen Ivanov"
    Date:   02-09-2021 
]
rot: 0
trans: 0x0
st-time: 0

easeInOutQubic: function [x][
    either x < 0.5 [x ** 3 * 4][1 - (-2 * x + 2 ** 3 / 2)]    
]

update: func [
    /local frame val
]    
[
    now/precise 
    frame: to float! difference now/precise st-time 
    frame: frame % 1.0
    
    rot: 90 * val: easeInOutQubic frame
    if val > 0.98   [
        st-time: now/precise
        rot: 0
        trans: trans + 100x0 % 700x10
        roll/2: trans
    ]
    roll/4: rot
]

view [
    title "Rolling box"
    base 600x200 teal rate 120
    draw [
        line 0x180 600x180
        fill-pen yello
        roll: translate 0x0 rotate 0 0x180 [box -100x80 0x180]
    ]
    on-time [ update ]
    on-create [st-time: now/precise]
]
