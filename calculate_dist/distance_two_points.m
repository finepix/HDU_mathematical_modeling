function [ dist ] = distance_two_points( A, B )
%UNTITLED6 ��������֮���ŷ����þ���
%   �˴���ʾ��ϸ˵��
    dist_x = A(1) - B(1);
    dist_y = A(2) - B(2);
    dist = sqrt(dist_x^2 + dist_y^2);

end

