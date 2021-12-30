using Luxor
using LinearAlgebra
using FileIO,ImageMagick,Colors,FixedPointNumbers,VideoIO

res = [640,480]
const framerate = 30
Luxor.Point(x::Array) = Luxor.Point(Tuple(x[1:2]))

O      = [ 0.0,  0, 0]
UP     = [ 0.0, -1, 0]
DOWN   = [ 0.0,  1, 0]
LEFT   = [-1.0,  0, 0]
RIGHT  = [ 1.0,  0, 0]

abstract type Object
end

mutable struct Arc<:Object
  centre::Array
  radius::Float64
  angle1::Real
  angle2::Real
  opacity::Float64
  transform::Function
  misc::Dict
end
#constructors
Arc(o::Array,r::Float64,a1::Real,a2::Real) = Arc(o,r,a1,a2,0,x->x,Dict([]))
Arc(o::Array,r::Float64,a1::Real,a2::Real,op::Float64) = Arc(o,r,a1,a2,op,x->x,Dict([]))
Circle(o::Array,r::Float64) = Arc(o,r,0,2π)

function drawobject(o::Arc)
  setopacity(o.opacity)
  Luxor.arc(o.centre[1],o.centre[2],o.radius,o.angle1,o.angle2,:stroke) 
  setopacity(0)
end
function drawpartial(a::Arc,frac::Real)
  angle2 = a.angle1 + frac*a.angle2
  return Arc(a.centre,a.radius,a.angle1,angle2,a.opacity)
end

mutable struct Line<:Object
  beginp::Array
  endp::Array
  opacity::Float64
  transform::Function
  misc::Dict
end
#constructors
Line(b::Array,e::Array) = Line(b,e,0.0,x->x,Dict([]))
Line(b::Array,e::Array,op::Float64) = Line(b,e,op,x->x,Dict([]))

function drawobject(o::Line;part=1.0)
  setopacity(o.opacity)
  Luxor.line(Point(o.beginp),Point(o.endp),:stroke)
  setopacity(0)
end
function drawpartial(l::Line,frac::Real)
  endp = l.beginp + frac .* (l.endp .- l.beginp)
  return Line(l.beginp, endp,l.opacity)
end

mutable struct Polygon<:Object
  points::Array{Array}
end

function FadeInObject(o::Object,T=1)
  nframes = floor(T*framerate)
  interpol(t) = t
  for (i,t) in enumerate(range(0,T,length=nframes))  
    o.opacity = interpol(t) 
    push!(frames,drawframe())
  end
end

function CreateObject(o::Object,T::Real=1)
  nframes = floor(T*framerate)
  for (i,t) in enumerate(range(0,T,length=nframes))
    o.transform = x->drawpartial(x,t/T)
    push!(frames,drawframe())
  end
end

function Wait(T::Real=1.0)
  nframes= floor(T*framerate)
  for (i,t) in enumerate(range(0,T,length=nframes))
    push!(frames,drawframe())
  end
end


function drawframe()
  img = Drawing(res...,:image)
  origin()
  sethue("white")
  for o in objects
    drawobject(o.transform(o))
  end
  return image_as_matrix() 
end

C1 = Circle(O,10.0)
C1.opacity=1.0
C2 = Circle(O.+50*UP,10.0);
L1 = Line(O,20*UP)
objects = Array{Object}([C1,C2,L1])
img = drawframe()
save("test.png",Array{RGB{N0f8}}(img))

frames = Array{ Matrix{RGB{N0f8}} }([])
CreateObject(C1,2)
L1.opacity=1.0
CreateObject(L1,1)
Wait(1)
save("test.mp4",frames,framerate=30)
run(`mpv test.mp4`)

#a = Drawing(500,500,:image)
#origin()
#setcolor("red")
#circle(Point(0,1),100,:fill)
#mat = image_as_matrix()
#finish()
