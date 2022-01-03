using Revise
includet("manim.jl")
#import Luxor: easeinoutcubic as easefn
using .manim
C1 = Circle(ORIGIN, 10.0)
C2 = Circle(ORIGIN .+ 50 * UP, 10.0, 1.0)
L1 = Line(ORIGIN, C2.centre, 1.0)
C3 = Circle((C1.centre + C2.centre) / 2.0, 100.0, 1.0)

Video()
grid = UniformGrid(50, 0.0)
append!(Scene, grid)
setproperty!.(grid[begin:(end ÷ 2)], :opacity, 0.5)
setproperty!.(grid[(end ÷ 2 + 1):end], :opacity, 0.5)

Play(
  CreateObject.(grid[begin:(end ÷ 2)], easefn = easeinoutcubic, 2)...,
  CreateObject.(grid[(end ÷ 2 + 1):end], 2, easefn = easeinoutcubic)...
)
Play(Wait(1))

push!(Scene, C1)
Play(FadeInObject(C1, 1))
push!(Scene, C2, L1)
push!(Scene, C3)

Play(
     CreateObject(C3, 3), CreateObject(C2, 2),
     CreateObject(L1, 3, easefn = easingflat)
)
Play(Wait(2))
ClearScene()
Play(Wait(2))

Render(show = true)
