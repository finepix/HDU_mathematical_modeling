function [flag] = sameline(a_x,a_y,b_x,b_y,c_x,c_y,d_x,d_y)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
    num1 = compute(b_x-a_x,b_y-a_y,d_x-a_x,d_y-a_y);
    num2 = compute(b_x-a_x,b_y-a_y,c_x-a_x,c_y-a_y);
    num3 = compute(d_x-c_x,d_y-c_y,a_x-c_x,a_y-c_y);
    num4 = compute(d_x-c_x,d_y-c_y,b_x-c_x,b_y-c_y);
    if((num1*num2<0 && num3*num4<=0) || (num1*num2<=0 && num3*num4<0))
        flag=1;
    else
        flag=0;
    end
end

