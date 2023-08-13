



function forward!(dir, x, y, mov, view)

    theta = 0.0;
    x0 = 0.0;
    y0 = 0.0;
    view0 = 0.0;

    if length(view) == 1 
        x0 = x[end]
        y0 = y[end]
        theta = view[end]
        view0 = view[end]
    elseif length(view) > 1 
        x0 = x[end]
        y0 = y[end]
        theta = sum(view);
        view0 = view[end]
    end

    #display(theta)
    push!(mov, dir)
    push!(view, 0.0 )
    push!(x, x[end] - abs(dir)*cos(theta*pi/180.0));
    push!(y, y[end] + abs(dir)*sin(theta*pi/180.0));

end

function rotate!(angle, x,y, mov, view)

    theta = 0.0;
    x0 = 0.0;
    y0 = 0.0;

    if length(view) == 1 
        x0 = x[end]
        y0 = y[end]
        theta = view[end] + angle
    elseif length(view) > 1 
        x0 = x[end]
        y0 = y[end]
        theta = view[end] + angle;
    end

    push!(mov, 0.0)
    push!(view, theta)
    push!(x, x0 );
    push!(y, y0 );
    
end


function curDisplay(x,y,mov,view)

    
    x0 = 0.0
    y0 = 0.0
    theta = 0.0


    if length(view) >= 1 
        x0 = x[end]
        y0 = y[end]
        theta = sum(view)
    end
    xc, yc, cur = calcCursor(theta*pi/180.0)

    xc = xc .+ x0;
    yc = yc .+ y0;

    plotCursor(xc,yc,cur)

end


function calcCursor(thetaRad)

    N::Int64 = 10; 
    cursorNew = zeros(Int8,10,10);

    cursor = Int8[
        [0 0 0 0 0 0 0 0 0 0];  #10
        [0 0 0 0 0 0 0 1 1 1];  #09
        [0 0 0 0 0 1 1 1 1 1];  #08
        [0 0 0 1 1 1 1 1 0 0];  #07
        [1 1 1 1 1 1 1 0 0 0];  #06
        [1 1 1 1 1 1 1 0 0 0];  #05
        [0 0 0 1 1 1 1 1 0 0];  #04
        [0 0 0 0 0 1 1 1 1 1];  #03
        [0 0 0 0 0 0 0 1 1 1];  #02
        [0 0 0 0 0 0 0 0 0 0];  #01
    ]; 

    xC = Float64[
        [0 1 2 3 4 5 6 7 8 9];  #10
        [0 1 2 3 4 5 6 7 8 9];  #09
        [0 1 2 3 4 5 6 7 8 9];  #08
        [0 1 2 3 4 5 6 7 8 9];  #07
        [0 1 2 3 4 5 6 7 8 9];  #06
        [0 1 2 3 4 5 6 7 8 9];  #05
        [0 1 2 3 4 5 6 7 8 9];  #04
        [0 1 2 3 4 5 6 7 8 9];  #03
        [0 1 2 3 4 5 6 7 8 9];  #02
        [0 1 2 3 4 5 6 7 8 9];  #01
    ]; 

    yC = Float64[
        [0 0 0 0 0 0 0 0 0 0];  #10
        [1 1 1 1 1 1 1 1 1 1];  #09
        [2 2 2 2 2 2 2 2 2 2];  #08
        [3 3 3 3 3 3 3 3 3 3];  #07
        [4 4 4 4 4 4 4 4 4 4];  #06
        [5 5 5 5 5 5 5 5 5 5];  #05
        [6 6 6 6 6 6 6 6 6 6];  #04
        [7 7 7 7 7 7 7 7 7 7];  #03
        [8 8 8 8 8 8 8 8 8 8];  #02
        [9 9 9 9 9 9 9 9 9 9];  #01
    ]; 

    xC = xC .+ 1.0;
    yC = yC .+ 1.0;

    xC = xC .- N/2;
    yC = yC .- N/2;

    center_i = Int8(N/2);
    center_j = Int8(N/2);

    for i = 1:N
        for j = 1:N

            i_ = Int8( round( cos(thetaRad)*(i-center_i) + sin(thetaRad)*(j-center_j) + center_i));
            j_ = Int8( round(-sin(thetaRad)*(i-center_i) + cos(thetaRad)*(j-center_j) + center_j));
            if (i_ < 1 || j_ < 1)
                continue;
            end
            if (i_ >= N)
                continue;
            end
            if (j_ >= N)
                continue;
            end
            cursorNew[i,j] = cursor[i_,j_];
        end
    end

    return xC, yC, cursorNew; 

end

function plotCursor(xC,yC,cursor)

    N = size(xC,1)
    for i = 1:N
        for j = 1:N
            if cursor[i,j] == 1
               plot(xC[i,j], yC[i,j],"sk", markersize = 1.0 )
               #plot(xC[i,j], yC[i,j],"sk", markersize = 1.0, color = [1-cursorNew[i,j],1-cursorNew[i,j],1-cursorNew[i,j] ] )
            end
        end
    end
end



function X!(n,x,y,mov,view)
    if n>0 
        LL!("X+YF+",n,x,y,mov,view);
    end
end
function Y!(n,x,y,mov,view)
    if n>0 
        LL!("-FX-Y",n,x,y,mov,view);
    end
end


function LL!(s,n,x,y,mov,view)


     for i = 1:length(s)
         c = s[i];
         if c == '+'
            rotate!(-90.0,x,y,mov,view) ## left
            forward!(0.0,x,y,mov,view)
         elseif c == '-' 
            rotate!( 90.0,x,y,mov,view) ## right
            forward!(0.0,x,y,mov,view)
         elseif c == 'X'
             X!(n-1,x,y,mov,view)
         elseif c == 'Y'
             Y!(n-1,x,y,mov,view)
         elseif c == 'F'
            forward!(12.0,x,y,mov,view)
         end

     end

end


function runDragon()
    
    
    x = []  ## x-coord
    y = []  ## y-coord
    mov = [] ## discrete movement 
    view = [] ## discrete rotation
    scale = 1.0; 


    push!(x, 0.0)
    push!(y, 0.0)
    push!(mov, 0.0)
    push!(view, 0.0)
  
    figure(1)
    clf();

    curDisplay(x,y,mov,view)
    forward!(15.0,x,y,mov,view)
    curDisplay(x,y,mov,view)
    forward!(15.0,x,y,mov,view)
    curDisplay(x,y,mov,view)
    rotate!(-90.0,x,y,mov,view) # left
    curDisplay(x,y,mov,view)
    forward!(15.0,x,y,mov,view) 
    curDisplay(x,y,mov,view)
    forward!(30.0,x,y,mov,view) 
    curDisplay(x,y,mov,view)
    rotate!(90.0,x,y,mov,view) ## right
    curDisplay(x,y,mov,view)
    forward!(30.0,x,y,mov,view)
    curDisplay(x,y,mov,view)
    rotate!(90.0,x,y,mov,view) 
    curDisplay(x,y,mov,view)
    forward!(100.0,x,y,mov,view)
     curDisplay(x,y,mov,view)
    rotate!(-45.0,x,y,mov,view) 
    curDisplay(x,y,mov,view)
    forward!(50.0,x,y,mov,view)
     curDisplay(x,y,mov,view)
     rotate!(200.0,x,y,mov,view) 
     curDisplay(x,y,mov,view)
     forward!(50.0,x,y,mov,view)
     curDisplay(x,y,mov,view)

    plot(x,y, "-r", linewidth = 1.0 )

    xlim(-250,250)
    ylim(-250,250)


end

function runDragonCurve()
    
    
    x = []  ## x-coord
    y = []  ## y-coord
    mov = [] ## discrete movement 
    view = [] ## discrete rotation
    scale = 1.0; 

    push!(x, 0.0)
    push!(y, 0.0)
    push!(mov, 0.0)
    push!(view, 0.0)

    X!(13,x,y,mov,view)

    lw = 1.0;
    figure(1)
    clf();

    plot(x,y, "-r", linewidth = lw )
    #axis("equal")

    #display(x)
    #display(y)

end

