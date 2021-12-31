using Luxor
using LinearAlgebra
using FileIO,ImageMagick,Colors,FixedPointNumbers,VideoIO

res = [640,480]
const framerate = 30
Luxor.Point(x::Array) = Luxor.Point(Tuple(x[1:2]))

O     = [ 0.0,  0, 0]
DOWN  = [ 0.0,  1, 0]
UP    = [ 0.0, -1, 0]
LEFT  = [ 1.0,  0, 0]
RIGHT = [ 1.0,  0, 0]

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
Circle(o::Array,r::Float64,op::Float64) = Arc(o,r,0,2π,op)

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
  ret = []
  for (i,t) in enumerate(range(0,T,length=nframes))  
    push!(ret, ()->(o.opacity = interpol(t)))
  end
  ret
end

function CreateObject(o::Object,T::Real=1;easefn=easingflat)
  nframes = floor(T*framerate)
  ret = []
  for (i,t) in enumerate(range(0,T,length=nframes))
    push!(ret, ()->(o.transform = x->drawpartial(x, easefn(t,0,1,T)  )))
  end
  ret
end

function Wait(T::Real=1.0)
  nframes= floor(T*framerate)
  ret = []
  for (i,t) in enumerate(range(0,T,length=nframes))
    push!(ret, ()->nothing)
  end
  ret
end

function Play(actions...)
  nframes = maximum(length.(actions))
  i=1
  while( i<=nframes)
    for action in actions
      if i<=length(action) 
       	action[i]()
      end
    end
    push!(frames,drawframe())
    i=i+1
  end
end

function drawframe()
  img = Drawing(res...,:image)
  origin()
  sethue("white")
  for o in scene 
    drawobject(o.transform(o))
  end
  return image_as_matrix() 
end
frames = Array{ Matrix{RGB{N0f8}} }([])

C1 = Circle(O, 10.0)
C2 = Circle(O.+50*UP, 10.0, 1.0)
L1 = Line(O,C2.centre, 1.0)
C3 = Circle((C1.centre + C2.centre)/2.0 .+10, 100.0, 1.0)

scene = Array{Object}([C1,])
Play( FadeInObject(C1,1) )
push!(scene,C2,L1)
push!(scene,C3)
Play( CreateObject(C3,3,easefn=easeinoutcubic), CreateObject(C2,2), CreateObject(L1,3)  )
Play( Wait(2) )


save("test.mp4",frames,framerate=30)
run(`mpv test.mp4`)

#a = Drawing(500,500,:image)
#origin()
#setcolor("red")
#circle(Point(0,1),100,:fill)
#mat = image_as_matrix()
#finish()
