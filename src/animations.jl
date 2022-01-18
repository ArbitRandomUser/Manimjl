function SetOpacity(o::Object,op::Float64, T=1)#::Base.Generator{Vector{Function},typeof(indentity)}
  nframes = floor(T*framerate)
  curr_op = o.opacity
  Δop = op - curr_op 
  ret = (()-> o.opacity = easingflat(t,curr_op,Δop,T) for t in range(0,T,length=nframes) )
  ret
end
function CreateObjectPartial(o::Object,p::Real, T::Real = 1; easefn = easeinoutcubic)#::Array{Function}
  #draws p fraction of the object
  """Creates the object partially, 
  `o` is the object
  `p` is the fraction of which it should be drawn
  `T` is the Time taken to create the object
  """
  @assert 0<=p<=1
  if !(o  in Scene)
    push!(Scene,o)
  end
  nframes = floor(T * framerate)
  t_index = length(o.transforms)
  push!(o.transforms, x->x ) #push a new transform
  ret= ( () -> o.transforms[t_index+1] = x -> drawpartial(x, easefn(t, 0, p, T)) for t in range(0,T,length=nframes) )
  ret
end
function UncreateObjectPartial(o::Object,p::Real, T::Real = 1; easefn = easeinoutcubic)
  """Uncreates the object ,""" 
  #undraws p fraction of the object
  @assert 0<=p<=1
  nframes = floor(T * framerate)
  t_index = length(o.transforms)
  push!(o.transforms, x->x) #push a new transform
  ret= ( () -> o.transforms[t_index+1] = x -> drawpartial(x, easefn(t, 1, -p, T)) for t in range(0,T,length=nframes))
  ret
end

function TransformPartial(o::Object,o2::Object,p::Real,T::Real=1.0,easefn=easeinoutcubic)
  nframes = floor(Int,T*framerate)
  t_index = length(o.transforms)
  push!(o.transforms, x->x)
  ret = ( () -> o.transforms[t_index+1] = x-> drawtransformed(x,o2,easefn(t,0,1,T)) for t in range(0,T,length=nframes) ) 
end

function Transform(o::Object,o2::Object,T::Real=1.0,easefn=easeinoutcubic)
  TransformPartial(o,o2,1.0,T,easefn)
end

function LinearTransform(o::Object,T::Real=1.0,m::Matrix=Matrix(I,(3,3));  easefn = easingflat)
  nframes = floor(Int,T*framerate)
  #cur_ltransform = deepcopy(o.ltransform)
  t_index = length(o.ltransforms)
  push!(o.ltransforms, Matrix(I,(3,3)) ) #push a new transform
  function f(o::Object,p::Real)
    mp = p*m + (1-p)*I
    #o.ltransform =   mp*cur_ltransform[:,1:2] cur_ltransform[:,3]+mp[:,3] 
    o.ltransforms[t_index+1] = mp#*cur_ltransform  
    #o.ltransform[2] = () ->( setmatrix([1.0,0,0,1.0,0,0]))
  end
  ret = (() ->  f(o,easefn(t,0,1,T)) for t in range(0,T,length=nframes) )
  ret
end

function Rotate(o::Object,θ::Real,T::Real=1.0;  easefn = easingflat)
  nframes = floor(Int,T*framerate)
  #cur_ltransform = deepcopy(o.ltransform)
  t_index = length(o.ltransforms)
  push!(o.ltransforms, Matrix(I,(3,3)) ) #push a new transform
  function f(o::Object,fθ::Real)
    o.ltransforms[t_index+1] =  rotationmatrix(fθ) #*cur_ltransform  
    #o.ltransform[2] = () ->( setmatrix([1.0,0,0,1.0,0,0]))
  end
  ret = (() ->  f(o,easefn(t,0,θ,T)) for t in range(0,T,length=nframes) )
  ret
end

function FadeInObject(o::Object, T = 1)
  SetOpacity(o,1.0,T)
end

function FadeOutObject(o::Object, T = 1)
  SetOpacity(o,0.0,T)
end
function CreateObject(o::Object, T::Real = 1; easefn = easeinoutcubic)
  CreateObjectPartial(o,1.0,T,easefn=easefn)
end


function UncreateObject(o::Object, T::Real = 1; easefn = easeinoutcubic)
  UncreateObjectPartial(o,1,T,easefn=easefn)
end

function Wait(T::Real = 1.0;)
  nframes = floor(T * framerate)
  ret = (()->nothing for t in range(0,T,length=nframes))
  ret
end

function Play(actionlists...)
  """
  usage:
  `Play( Animation1(...) , Animation2(...))`
  where `Animation` is one of the animation functions.
  every Animation is played simultaneusly, if you want 
  Animation1 , to be played while Animation2 and Animation3 are played in
  sequence use the Seq function

  `Play( Animation1(...) , Seq( Animation2(...) , Animation3(...)))`

  actionlists is an array of actionlist.
  actionlist is an array(or iterable) of functions,
  typically returned by the animation functions.
  something like [ [f1,f2,f3...] , [g1,g2,g3...], [h1,h2,h3... ]
  where fi and gi are functions.
  

  every action in an actionlist is argless function 
  the function typically modifies objects properties
  Play then runs f1,g1,h1... which modify the objects
  then a frame is drawn. Next it runs f2,g2,h2.... which modify
  the objects for the next frame .. and so on. Thus animations are made

  """
  nframes = maximum(length.(actionlists))
  i=0 #state of generator
  while (i < nframes)
    for actionlist in actionlists
      action = iterate(actionlist,i)
      if action!=nothing 
        action[1]()   
      end
    end
    write(vidwriter,drawframe() )
    i = i + 1
  end
end
