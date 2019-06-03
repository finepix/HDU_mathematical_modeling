function [ total_cost, is_reasonable ] = calculate_cost( plans, PLANS_COST_TABLE, MAX_COST)
%UNTITLED12 计算总的耗费，用于排除不符合标准的方案
%   此处显示详细说明
    len = length(PLANS_COST_TABLE);
    % 计算开销
    tmp = zeros(len, 1);
    for i = 1:len
        tmp(i) = length(find(plans == i));
    end
    total_cost = dot(tmp, PLANS_COST_TABLE);
    
    % 判断是否合理
    is_reasonable = 1;
    if total_cost > MAX_COST
        is_reasonable = 0;
    end
end

