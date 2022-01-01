function FadeInObject(o::Object, T = 1)
  nframes = floor(T * framerate)
  interpol(t) = t
  #TODO dont do this , return an iterator instead
  ret = []
  for (i, t) in enumerate(range(0, T, length = nframes))
    push!(ret, () -> (o.opacity = interpol(t)))
  end
  ret
end

function CreateObject(o::Object, T::Real = 1; easefn = easingflat)
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
  nframes = maximum(length.(actions))
  i = 1
  while (i <= nframes)
    for action in actions
      if i <= length(action)
        action[i]()
      end
    end
    push!(frames, drawframe())
    i = i + 1
  end
end
