using Luxor
using LinearAlgebra
using FileIO,ImageMagick,Colors,FixedPointNumbers,VideoIO
res = [640,480]
const framerate = 30
Luxor.Point(x::Array) = Luxor.Point(Tuple(x[1:2]))

abstract type Object
end

mutable struct Arc<:Object
  centre::Array
  radius::Float64
  angle1::Real
  angle2::Real
  opacity::Float64
  misc::Dict
end
#constructors
Arc(o::Array,r::Float64,a1::Real,a2::Real) = Arc(o,r,a1,a2,0,Dict([]))
Circle(o::Array,r::Float64) = Arc(o,r,0,2π)

function drawobject(o::Arc)
  setopacity(o.opacity)
  Luxor.arc(o.centre[1],o.centre[2],o.radius,o.angle1,o.angle2,:stroke) 
  setopacity(0)
end

mutable struct Line<:Object
  beginp::Array
  endp::Array
  centre::Array
  opacity::Float64
  misc::Dict
end
#constructors
Line(b::Array,e::Array) = Line(b,e,(b.-e)/2, 0,Dict([]))

function drawobject(o::Line;part=1.0)
  setopacity(o.opacity)
  Luxor.line(Point(o.beginp),Point(o.endp),:stroke)
  setopacity(0)
end

mutable struct Polygon<:Object
  points::Array{Array}
end

O = [0.0,0,0]
UP = [0.0,1,0]
DOWN = [0.0,-1,0]
LEFT = [-1.0,0,0]
RIGHT = [1.0,0,0]

function FadeInObject(o::Object,t=1)
  nframes = floor(t*framerate)
  interpol(t) = t
  for (i,t) in enumerate(range(0,t,length=nframes))  
    o.opacity = interpol(t) 
    push!(frames,drawframe())
  end
end

function CreateObject(o::Object,t=1)
  nframes -= floor(t*framerate)
  for (i,t) in enumerate(range(0,t,length=nframes))
    
    push!(frames,drawframe())
  end
end

function drawframe()
  img = Drawing(res...,:image)
  origin()
  sethue("white")
  for o in objects
    drawobject(o)
  end
  return image_as_matrix() 
end

objects = Array{Object}([Circle(O,10.0),Circle(O.+50*UP,10.0),Line(O,20*UP)])
img = drawframe()
save("test.png",Array{RGB{N0f8}}(img))

frames = Array{ Matrix{RGB{N0f8}} }([])
FadeInObject(objects[1],2)
FadeInObject(objects[3],2)
save("test.mp4",frames,framerate=30)
run(`mpv test.mp4`)

#a = Drawing(500,500,:image)
#origin()
#setcolor("red")
#circle(Point(0,1),100,:fill)
#mat = image_as_matrix()
#finish()
