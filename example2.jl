using LinearAlgebra
include("./manim.jl")
using .manim

Video("test.mp4")
L1 = Line(ORIGIN,50*(RIGHT),1.0)
Lx = Line(ORIGIN,500*(RIGHT),0.5)
Lπby4 = Line(ORIGIN,500*(DOWN+RIGHT),0.5)
L2πby4 = Line(ORIGIN,500*(DOWN),0.5)
#L2 = Line(ORIGIN,200*UP,1.0)
C1 = Circle(ORIGIN,50,0.5)
push!(Scene,L1,C1,Lπby4,L2πby4,Lx)
#Play(CreateObject(L1,2),CreateObject(L1,2),UncreateObject(L1,2))
#Play(CreateObject(L1,2))#,CreateObject(L1,2),UncreateObject(L1,2))
#push!(Scene,L2)
Iden = Matrix(I,(3,3))
Play(Wait(1))
Play(LinearTransform(L1,3.0,2*Iden ))
Play(Wait(1))
Play(LinearTransform(L1,3.0,0.75*Iden ))
Play(Wait(1))
Play(Rotate(L1,π/4.0,3.0))
Play(Wait(1))
Play(Seq(Rotate(L1,π/4.0,3.0),LinearTransform(L1,2.0,1e-10*Iden)) )
Play(Wait(5))
Render(show=true)
