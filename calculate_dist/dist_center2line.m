function [ dist ] = dist_center2line( P, a, b, c )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明

    dist = abs(a*P(1)+b*P(2)+c)/sqrt(a^2+b^2);
end

