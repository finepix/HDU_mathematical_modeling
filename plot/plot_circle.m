function [ ] = plot_circle( x,y,r )
    theta=0:0.1:2*pi;  
    Circle1=x+r*cos(theta);  
    Circle2=y+r*sin(theta);  
    c=[123,14,52];  
    plot(Circle1,Circle2,'r','linewidth',1);  
    axis equal  
    xlabel('x'); % xÖá×¢½â  
    ylabel('y'); % yÖá×¢½â  
end
