function FadeInObject(o::Object, T = 1)
  nframes = floor(T * framerate)
  interpol(t) = t
  #TODO dont do this , return an iterator instead
  ret = []
  Iterators.map( t -> ()->(o.opacity = interpol(t))  , range(0,T,length=nframes) ) 
  for (i, t) in enumerate(range(0, T, length = nframes))
    push!(ret, () -> (o.opacity = interpol(t)))
  end
  ret
end

function CreateObject(o::Object, T::Real = 1; easefn = easeinoutcubic)
  nframes = floor(T * framerate)
  ret = []
  #TODO dont do this , return an iterator instead
  for (i, t) in enumerate(range(0, T, length = nframes))
    push!(ret, () -> (o.transform = x -> drawpartial(x, easefn(t, 0, 1, T))))
  end
  ret
end

function Wait(T::Real = 1.0;)
  nframes = floor(T * framerate)
  ret = []
  #TODO dont do this , return an iterator instead
  for (i, t) in enumerate(range(0, T, length = nframes))
    push!(ret, () -> nothing)
  end
  ret
end

function Play(actions...)
  # actions is a list like 
  # [ [f1,f2,f3..]  , [g1,g2,g3...],... ]
  # where fi,gi are all functions 
  nframes = maximum(length.(actions))
  i = 1
  while (i <= nframes)
    for action in actions
      if i <= length(action)
        action[i]()
      end
    end
    write(vidwriter,drawframe() )
    #push!(frames, drawframe())
    i = i + 1
  end
end
