#Arc and Circle
mutable struct Arc <: Object
  centre::Array
  radius::Float64
  angle1::Real
  angle2::Real
  opacity::Float64
  transform::Function
  misc::Dict
end
#constructors
Arc(o::Array, r::Float64, a1::Real, a2::Real) = Arc(o, r, a1, a2, 0, x -> x, Dict([]))
Arc(o::Array, r::Float64, a1::Real, a2::Real, op::Float64) =
  Arc(o, r, a1, a2, op, x -> x, Dict([]))
Circle(o::Array, r::Float64) = Arc(o, r, 0, 2π)
Circle(o::Array, r::Float64, op::Float64) = Arc(o, r, 0, 2π, op)

function drawobject(o::Arc)
  setopacity(o.opacity)
  Luxor.arc(o.centre[1], o.centre[2], o.radius, o.angle1, o.angle2, :stroke)
  setopacity(0)
end
function drawpartial(a::Arc, frac::Real)
  angle2 = a.angle1 + frac * a.angle2
  return Arc(a.centre, a.radius, a.angle1, angle2, a.opacity)
end

#Line
mutable struct Line <: Object
  beginp::Array
  endp::Array
  opacity::Float64
  transform::Function
  misc::Dict
end
#constructors
Line(b::Array, e::Array) = Line(b, e, 0.0, x -> x, Dict([]))
Line(b::Array, e::Array, op::Float64) = Line(b, e, op, x -> x, Dict([]))

function drawobject(o::Line; part = 1.0)
  setopacity(o.opacity)
  Luxor.line(Point(o.beginp), Point(o.endp), :stroke)
  setopacity(0)
end
function drawpartial(l::Line, frac::Real)
  endp = l.beginp + frac .* (l.endp .- l.beginp)
  return Line(l.beginp, endp, l.opacity)
end

