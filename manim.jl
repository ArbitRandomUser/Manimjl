using Luxor
using FileIO,ImageMagick,Colors,FixedPointNumbers,VideoIO
res = [640,480]
#canvas = Drawing(res...,"/tmp/drawing.svg")
jlc(x) = @imagematrix juliacircles(x) res[1]  res[2] 
#jlc(100)
#save("test2.png",ans)
#b = zeros(ARGB32,res[2],res[1],100)
frames = Array{ Matrix{RGB{N0f8}} }([])
const framerate = 30
#save("test.mp4",frames,framerate=30)
#jlcfix(i) = Matrix{RGB{N0f8}}(jlc(i))
#
abstract type Object
end

struct Circle<:Object
  centre::Array
  radius::Float64
  visible::Float64
end

O = [0,0,0]
UP = [0,1,0]
DOWN = [0,-1,0]
LEFT = [-1,0,0]
RIGHT = [1,0,0]

objects = Array{Object}([Circle(O,1),Circle(O.+UP,1)])

function CreateObject(o::Object,t=1)
  Δt = t/framerate
end
