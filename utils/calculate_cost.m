function [ total_cost, is_reasonable ] = calculate_cost( plans, PLANS_COST_TABLE, MAX_COST)
%UNTITLED12 �����ܵĺķѣ������ų������ϱ�׼�ķ���
%   �˴���ʾ��ϸ˵��
    len = length(PLANS_COST_TABLE);
    % ���㿪��
    tmp = zeros(len, 1);
    for i = 1:len
        tmp(i) = length(find(plans == i));
    end
    total_cost = dot(tmp, PLANS_COST_TABLE);
    
    % �ж��Ƿ����
    is_reasonable = 1;
    if total_cost > MAX_COST
        is_reasonable = 0;
    end
end

