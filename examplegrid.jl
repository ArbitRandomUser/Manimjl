grid = UniformGrid(50, 0.0)
append!(Scene, grid)
setproperty!.(grid[begin:(end ÷ 2)], :opacity, 0.5)
setproperty!.(grid[(end ÷ 2 + 1):end], :opacity, 0.5)

Play(
  CreateObject.(grid[begin:(end ÷ 2)], easefn = easeinoutcubic, 2)...,
  CreateObject.(grid[(end ÷ 2 + 1):end], 2, easefn = easeinoutcubic)...
)
Play(Wait(1))
push!(Scene, C1,C2,C3,L1)

