function FadeInObject(o::Object, T = 1)
  nframes = floor(T * framerate)
  ret = (()-> o.opacity = easingflat(t,0,1,T) for t in range(0,T,length=nframes) )
  ret
end

function CreateObject(o::Object, T::Real = 1; easefn = easeinoutcubic)
  nframes = floor(T * framerate)
  ret= ( () -> (o.transform = x -> drawpartial(x, easefn(t, 0, 1, T))) for t in range(0,T,length=nframes)  )
  ret
end

function Wait(T::Real = 1.0;)
  nframes = floor(T * framerate)
  ret = []
  ret = ( ()->nothing for t in range(0,T,length=nframes))
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
        action[1]() #where 
      end
    end
    write(vidwriter,drawframe() )
    i = i + 1
  end
end
