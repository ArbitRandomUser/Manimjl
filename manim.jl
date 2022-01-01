module manim

export Arc,
  Circle,
  Line,
  FadeInObject,
  CreateObject,
  Scene,
  Render,
  ORIGIN,
  Play,
  DOWN,
  UP,
  LEFT,
  RIGHT,
  Wait

#export easing functions from Luxor
pre  = ["ease"]
mid  = ["in","out","inout"]
post = ["expo","circ","quad","cubic","quart","quint"]
for i in pre
  for j in mid
    for k in post
      eval(Meta.parse("export $(i*j*k)"))
    end
  end
end

using Luxor
using LinearAlgebra
using FileIO, ImageMagick, Colors, FixedPointNumbers, VideoIO
#TODO dont hold all frames in Array, use a VideoIO writer
frames = Array{Matrix{RGB{N0f8}}}([])
res = [640, 480]
const framerate = 30
Luxor.Point(x::Array) = Luxor.Point(Tuple(x[1:2]))
abstract type Object end

mutable struct ObjectGroup
  elements::Array
end



include("constants.jl")
include("objects.jl")
include("animations.jl")

function drawframe()
  img = Drawing(res..., :image)
  origin()
  sethue("white")
  for o in Scene
    drawobject(o.transform(o))
  end
  return image_as_matrix()
  finish()
end

Scene = Array{Object}([])

function Render()
  save("test.mp4", frames, framerate = 30)
  run(`mpv test.mp4`)
end

end #close module manim
