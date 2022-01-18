@userplot plotpartial

function partialxy(x,y,p)
  Δys = y[2:end] - y[1:end-1]
  Δxs = x[2:end] - x[1:end-1]
  lengths = sqrt.(Δys.^2 + Δxs.^2)
  partlength = p*sum(lengths)
  suml=0
  ind = 0
  indices=[]
  fracp=0
  if p==0
    return [x[1],],[y[1],]
  end
  while(suml<partlength)
    suml = suml+lengths[ind+1]
    fracp = partlength-suml
    push!(indices,ind+1)
    ind+=1
    #println("EXIT ind $ind ", suml," ", sum(lengths))
  end
  dir = [x[ind+1],y[ind+1]] .- [x[ind],y[ind]]
  endp = [x[ind+1],y[ind+1]] .+ fracp.* (dir/ sqrt( sum( dir.^2) )  )
  retx = [x[indices];endp[1]]
  rety = [y[indices];endp[2]]
  return retx,rety 
end

@recipe function f(plt::plotpartial;p::Real,sz=(640,480),border=0.2)
  xs,ys = plt.args
  size := sz 
  seriestype := :path
  @series begin
    subplots := 1
    xlims --> (minimum(xs)-border,maximum(xs)+border)
    ylims --> (minimum(ys)-border,maximum(ys)+border)
    partialxy(xs,ys,p)
  end
end

@userplot plottransition

function transit(xs1,ys1,xs2,ys2,p)
  retx = (1.0-p)*xs1 .+ p*(xs2) 
  rety = (1.0-p)*ys1 .+ p*(ys2) 
  return retx,rety 
end

@recipe function f(plt::plottransition;p::Real=0.0,sz=(640,480),border=0.2)
  xs1,ys1,xs2,ys2 = plt.args
  size :=sz
  seriestype := :path
  @series begin
    subplots :=1
    #limits are from first plot
    xlims --> (minimum(xs1)-border,maximum(xs1)+border)
    ylims --> (minimum(ys1)-border,maximum(ys1)+border)
    transit(xs1,ys1,xs2,ys2,p)
  end
end
