Manimish<br/>
Noobish<br/>
Very barebones for now<br/>
Questionable programming decisions<br/>
Javis.jl is probably what you really want<br/>
but if you insist on "declarative" animations<br/>
this might kinda help.<br/>

Minimal example

```julia
include("manim.jl")
using .manim
C1 = Circle(ORIGIN, 30.0) #invisble circle centre at origin , radius 30 (default opacity is 0)
C2 = Circle(ORIGIN .+ 80 * UP, 30.0) #invisible circle radius 30 , slightly higher up
C3 = Circle((C1.centre + C2.centre) / 2.0, 100.0, 1.0)#radius 100, visible circle whos centre is 
#midpoint of C1 and C2's centre 
L1 = Line(ORIGIN, C2.centre, 1.0) #visbile line(opacity=1.0) from origin to C2's centre

#setup video
Video("circlesnlines.mp4")
#add circle C3 to scene
push!(Scene,C3)
#"Draw" C3 and show its creation,
#by default , CreateObject uses cubic-in-out easing function
Play(CreateObject(C3, 3))

#"Draw" a line , with a linear easingfunction
push!(Scene,L1)
Play(CreateObject(L1, 3, easefn = easingflat))

#add C1 and C2 to Scene
push!(Scene,C1,C2)
#fadin animates the opacity from 0->1
#C1 and C2 were created with opacity 0 (default)
#Here we fade in C1 in 1 second
Play(FadeInObject(C1, 1))

#Play 2 animations simultaneuosly!
#Play() can be passed multiple arguments
#which will all be animated simultaneosly
#"Draw" C2 while fading it in,
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
Gives the following...<br/>

![](assets/circlesnlines.gif)

