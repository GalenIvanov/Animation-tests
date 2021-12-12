Red [
    title: "Animation tests - particles"
    author: "Galen Ivanov"
    needs: view
]

#include %Animate.red

d: particle/init-particles 'test particle/particle-base


view [
    base black 400x400 draw (d) rate 60
    on-time [particle/update-particles 'test]
]
