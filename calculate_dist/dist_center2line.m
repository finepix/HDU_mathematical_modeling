function [ dist ] = dist_center2line( P, a, b, c )
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    dist = abs(a*P(1)+b*P(2)+c)/sqrt(a^2+b^2);
end

