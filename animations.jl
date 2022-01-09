function SetOpacity(o::Object,op::Float64, T=1)#::Base.Generator{Vector{Function},typeof(indentity)}
  nframes = floor(T*framerate)
  curr_op = o.opacity
  Δop = op - curr_op 
  ret = (()-> o.opacity = easingflat(t,curr_op,Δop,T) for t in range(0,T,length=nframes) )
  ret
end
function CreateObjectPartial(o::Object,p::Real, T::Real = 1; easefn = easeinoutcubic)#::Array{Function}
  #draws p fraction of the object
  @assert 0<=p<=1
  nframes = floor(T * framerate)
  curr_transform = o.transform
  ret= ( () -> o.transform = x -> drawpartial(curr_transform(x), easefn(t, 0, p, T)) for t in range(0,T,length=nframes) )
  ret
end
function UncreateObjectPartial(o::Object,p::Real, T::Real = 1; easefn = easeinoutcubic)
  #undraws p fraction of the object
  @assert 0<=p<=1
  nframes = floor(T * framerate)
  curr_transform = o.transform
  ret= ( () -> o.transform = x -> drawpartial(curr_transform(x), easefn(t, 1, -p, T)) for t in range(0,T,length=nframes))
  ret
end

function LinearTransformPartial(o::Object,T::Real=1.0,m::Matrix=Matrix(I,(2,2));  easefn = easingflat)
  nframes = floor(Int,T*framerate)
  cur_ltransform = o.ltransform
  function f(o::Object,p::Real)
    mp = p*m + (1-p)*I 
    o.ltransform = () ->( cur_ltransform(), transform([mp [0,0]]) )
    #o.ltransform[2] = () ->( setmatrix([1.0,0,0,1.0,0,0]))
  end
  ret = (() ->  f(o,easefn(t,0,1,T)) for t in range(0,T,length=nframes) )
end

function Rotate(o::Object,p::Real,T::Real=1.0;  easefn = easingflat)
  @assert 0<=p<=1
  nframes = floor(Int,T*framerate)
  cur_ltransform = o.ltransform
  function f(o::Object,frac::Real)
    o.ltransform = () ->( cur_ltransform(), rotate(frac) )
    #o.ltransform[2] = () ->( setmatrix([1.0,0,0,1.0,0,0]))
  end
  ret = (() ->  f(o,easefn(t,0,p,T)) for t in range(0,T,length=nframes) )
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
  # actions is a list like 
  # [ [f1,f2,f3..]  , [g1,g2,g3...],... ]
  # where fi,gi are all functions 
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
