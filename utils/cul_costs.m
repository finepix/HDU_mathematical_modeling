function [ total_costs ] = cul_costs(  plans, PLANS_COST_TABLE, MAX_COST )
%UNTITLED19 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    len = length(PLANS_COST_TABLE);
    % ���㿪��
    N = size(plans, 1);
    tmp = zeros(N, len);
    for i = 1:N
        for j = 1:len
            tmp(i, j) = length(find(plans(i, :) == j));
        end
    end
    total_costs = tmp * PLANS_COST_TABLE';
    
end
