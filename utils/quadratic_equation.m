function [a, b, c] = quadratic_equation(point1, point2)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    x1 = point1(1);
    x2 = point2(1);
    y1 = point1(2);
    y2 = point2(2);
    
    a = y2 - y1;
    b = x1 - x2;
    c = x2*y1 - x1*y2;

end

