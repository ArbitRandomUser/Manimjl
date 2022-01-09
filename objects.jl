function lineartransformpartial(o::Object,m::Matrix)
  cur_ltransform = o.ltransform
  #o.ltransform[1] = () ->( cur_ltransform[1](), transform([m [o.centre]]) )
  #o.ltransform[2] = () ->( cur_ltransform[2](), transform([m^-1 -1.0*[o.centre]]))
end

#Arc and Circle
mutable struct Arc <: Object
  centre::Array
  radius::Real
  angle1::Real
  angle2::Real
  opacity::Real
  transform::Function #transforms in manim, f:Object -> Object
  ltransform::Function # 2 element array ,transform,and its inverse in luxor f:void->void
  misc::Dict
end

#nulltrnsfrm = ()->()
#constructors
Arc(o::Array, r::Real, a1::Real, a2::Real) = Arc(o, r, a1, a2, 0, x->x,()->(), Dict([]))
Arc(o::Array, r::Real, a1::Real, a2::Real, op::Real) =
Arc(o, r, a1, a2, op, x->x, ()->(), Dict([]))
Circle(o::Array, r::Real) = Arc(o, r, 0, 2π)
Circle(o::Array, r::Real, op::Real) = Arc(o, r, 0, 2π, op)

function drawobject(o::Arc)#m::Matrix=I)
  setopacity(o.opacity)
  Luxor.arc(o.centre[1], o.centre[2], o.radius, o.angle1, o.angle2, :stroke)
  setopacity(0)
end

function drawpartial(a::Arc, frac::Real)
  angle2 = a.angle1 + frac * a.angle2
  #setopacity(a.opacity)
  #Luxor.arc(a.centre[1],a.centre[2], a.radius, a.angle1, angle2,:stroke)
  #setopacity(0)
  return Arc(a.centre, a.radius, a.angle1, angle2, a.opacity)
end


#Line
mutable struct Line <: Object
  beginp::Array
  endp::Array
  opacity::Real
  transform::Function
  ltransform::Function
  misc::Dict
end
#constructors
Line(b::Array, e::Array) = Line(b, e, 0.0, x -> x,()->(), Dict([]))
Line(b::Array, e::Array, op::Real) = Line(b, e, op, x -> x,()->(), Dict([]))

function drawobject(o::Line; part = 1.0)
  setopacity(o.opacity)
  Luxor.line(Point(o.beginp), Point(o.endp), :stroke)
  setopacity(0)
end
function drawpartial(l::Line, frac::Real)
  endp = l.beginp + frac .* (l.endp .- l.beginp)
  return Line(l.beginp, endp, l.opacity)
end

function UniformGrid(spacing=10.0,vis=0.0)
  ret = Array{Object}([])
  left_edge = (ORIGIN .- [manim.res[1],0,0]./2)[1]
  right_edge = (ORIGIN .+ [manim.res[1],0,0]./2)[1]
  top_edge = (ORIGIN .+ [0,manim.res[2],0]./2)[2]
  bottom_edge = (ORIGIN .- [0,manim.res[2],0]./2)[2]
  res = manim.res
  xs = [ 0.0-spacing*n for n in -res[1]÷2:res[1]÷2]
  ys = [ 0.0-spacing*n for n in -res[2]÷2:res[2]÷2]
  for y in ys
    startp = [left_edge,y,0]
    endp = [right_edge,y,0]
    vis = vis
    push!(ret,Line(startp,endp,vis))
  end
  for x in xs
     startp = [x,bottom_edge,0]
     endp = [x,top_edge,0]
     vis = vis
     push!(ret,Line(startp,endp,vis))
  end
  return ret
end
