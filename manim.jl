module manim

export Arc,
  Object,
  Circle,
  Line,
  FadeInObject,
  FadeOutObject,
  CreateObjectPartial,
  CreateObject,
  UncreateObjectPartial,
  UncreateObject,
  Scene,
  Render,
  ORIGIN,
  Play,
  DOWN,
  UP,
  LEFT,
  RIGHT,
  Wait,
  UniformGrid,
  ClearScene,
  Video,
  remove!

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
export easingflat

import Base
using Luxor
#using OrderedCollections
using LinearAlgebra
using FileIO, ImageMagick, Colors, FixedPointNumbers, VideoIO

res = (640,480)
framerate = 30 
vidwriter = nothing
videoname = "test.mp4"

#vidwriter = open_video_out("test.mp4",RGB{N0f8},reverse(res),framerate=framerate) 
function Video(fvideoname="test.mp4",fres=(640,480),fframerate=30)
 global res = fres 
 global framerate = fframerate 
 global videoname = fvideoname
 global vidwriter = open_video_out(videoname,RGB{N0f8},reverse(res),framerate=framerate) 
end

Luxor.Point(x::Array) = Luxor.Point(Tuple(x[1:2]))

abstract type Object end

mutable struct ObjectGroup
  elements::Array
end


include("constants.jl")
include("objects.jl")
include("animations.jl")

function drawframe()
  """
    go to every object in Scene, apply its respective transform,
    draw ! , return drawing as frame(Matrix{RGB{N0f8}}). 
  """
  Drawing(res..., :image)
  origin()
  sethue("white")
  for o in Scene
    #new_o = deepcopy(o) 
    o.ltransform[1]()
    drawobject(o.transform(o))
    o.ltransform[2]() #invert
  end
  img =  image_as_matrix()
  finish()
  return Matrix{RGB{N0f8}}(img)
end

"""This is the scene , an array of Objects
drawframe uses this to draw onto the screen
"""
Scene = Array{Object}([])

function remove!(obj,scene::Array{Object}=Scene)
  """
  remove object from scene
  """
  for (i,o) in enumerate(scene)
    if o==obj
      deleteat!(scene,i)
    end
  end
end

function ClearScene(scene::Array{Object}=Scene)
  """
  clears the scene of all objects
  """
  while(length(scene)!=0)
    pop!(scene)
  end
end

function Render(;show=false,player="mpv")
  """
  writes the video to file and closes file.
  if show is true , will play the video with mpv.
  Note that Render does not clear the Scene, new Video's made
  after Render will still contain Objects that were added;
  use ClearScene after Render to clear the Scene.
  """
  #save("test.mp4", frames, framerate = 30)
  close_video_out!(vidwriter)
  if show==true
    try
      run(`$(player) $(videoname)`)
    catch e
      if e isa IOError
        println(e.msg, " try passing a different player")
      end
    end
  end
end

end #close module manim
