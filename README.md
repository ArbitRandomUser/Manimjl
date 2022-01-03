Manimish libarary for math animations 
Javis.jl is probably what you really want 

minimal example

```
include("manim.jl")
using .manim
C1 = Circle(ORIGIN, 30.0)
C2 = Circle(ORIGIN .+ 80 * UP, 30.0,)
L1 = Line(ORIGIN, C2.centre, 1.0)
C3 = Circle((C1.centre + C2.centre) / 2.0, 100.0, 1.0)

#setup video
Video("circlesnlines.mp4")
#add circle C3 to scene
push!(Scene,C3)
#Draw C3, default is to use an easing function 
Play(CreateObject(C3, 3))

#draw a line , linearly
push!(Scene,L1)
Play(CreateObject(L1, 3, easefn = easingflat))

#fade in circle1 in 1 second
push!(Scene,C1,C2)
Play(FadeInObject(C1, 1))
#play 2 animations simultaneuosly ...
#draw circle2 while fading it in,
#in 3 and 5 seconds respectively
Play(
     CreateObject(C2, 3), 
     FadeInObject(C2, 5),
)
#do nothing for 3 seconds
Play(Wait(3))
#Save it and show video(requires mpv)
Render(show = true)
```
gives the following 
![](assets/circlesnlines.gif)

