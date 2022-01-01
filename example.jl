include("manim.jl")
#import Luxor: easeinoutcubic as easefn
using .manim
C1 = Circle(ORIGIN, 10.0)
C2 = Circle(ORIGIN .+ 50 * UP, 10.0, 1.0)
L1 = Line(ORIGIN, C2.centre, 1.0)
C3 = Circle((C1.centre + C2.centre) / 2.0 .+ 10, 100.0, 1.0)

push!(Scene, C1)
Play(FadeInObject(C1, 1))
push!(Scene, C2, L1)
push!(Scene, C3)
Play(CreateObject(C3, 3, easefn = easeinoutcubic), CreateObject(C2, 2), CreateObject(L1, 3))
Play(Wait(2))
Render()
