using Manimjl

Video("test2.mp4")

x = 1:2:20 
y=  5 .+ rand((-2,-1,0,1,2),10) 
y2=  5 .+ rand((-2,-1,0,1,2),10) 

plt1 = pngplot(x,y)
plt2 = pngplot(x,y2)
push!(Scene,plt1)
Play(CreateObject(plt1,5,easefn=easingflat))
Play(Transform(plt1,plt2,5))
Render(show=true)
