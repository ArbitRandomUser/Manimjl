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

@recipe function f(plt::plotpartial;p::Real,sz=(640,480))
  xs,ys = plt.args
  size := sz 
  seriestype := :path
  @series begin
    subplots := 1
    xlims --> (minimum(xs),maximum(xs))
    ylims --> (minimum(ys),maximum(ys))
    partialxy(xs,ys,p)
  end
end
