function [ total_costs ] = cul_costs(  plans, PLANS_COST_TABLE, MAX_COST )
%UNTITLED19 此处显示有关此函数的摘要
%   此处显示详细说明
    len = length(PLANS_COST_TABLE);
    % 计算开销
    N = size(plans, 1);
    tmp = zeros(N, len);
    for i = 1:N
        for j = 1:len
            tmp(i, j) = length(find(plans(i, :) == j));
        end
    end
    total_costs = tmp * PLANS_COST_TABLE';
    
end
