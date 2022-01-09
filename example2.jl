using LinearAlgebra
include("./manim.jl")
using .manim

Video("test.mp4")
L1 = Line(ORIGIN,50*(UP+RIGHT),1.0)
Lx = Line(ORIGIN,500*(RIGHT),0.5)
Lπby4 = Line(ORIGIN,500*(UP+RIGHT),0.5)
L2πby4 = Line(ORIGIN,500*(-UP+RIGHT),0.5)
#L2 = Line(ORIGIN,200*UP,1.0)
C1 = Circle(ORIGIN,50,0.5)
push!(Scene,L1,C1,Lπby4,L2πby4,Lx)
#push!(Scene,L2)
Iden = Matrix(I,(2,2))
Play(Wait(1))
Play(LinearTransformPartial(L1,3.0,2*Iden ))
Play(Wait(1))
Play(Rotate(L1,π/4.0,3.0))
Play(Wait(1))
Play(Rotate(L1,π/4.0,3.0),LinearTransformPartial(L1,3.0,5*Iden) )
Play(Wait(1))
Render(show=true)