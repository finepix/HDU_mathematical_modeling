function [ new_populations ] = mutate_own( populations, pm, PLANS_COST_TABLE, MAX_COST, total_used_points )
%UNTITLED13 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    new_populations = [];
    
    total_points = populations.points;
    total_plans = populations.plans;
    
    plans_table_len = length(PLANS_COST_TABLE);
    
    N = size(total_points, 1);
    M = size(total_points, 2);
    % ѭ������ÿһ������
    for i = 1:N
        points_old = total_points(i, :);
        plans_old = total_plans(i, :);
        % �жϱ�����
        if rand() > pm
            continue;
        end
            
        % ����
        count = 0;
        while 1
            % ���������1,�������ı�ڵ�λ�ã�2���ı䷽����3�����ı�
            situ = unidrnd(3);
            
            % �ı�ڵ�λ��
            if situ == 1 || situ == 3
                mute_idx_points = unidrnd(M);
                % ��Ҫ�仯�ĵ�
                tmp_be_used_points = setdiff(total_used_points, points_old);
                used_size = length(tmp_be_used_points);
                while 1
                    point_idx = unidrnd(used_size);
                    point = tmp_be_used_points(point_idx);
                    if ~ismember(point, points_old)
                        break;
                    end
                end
                check(total_points, N, M);
%                 if ismember(point, points_old)
%                     disp(total_points(i, :))
%                 end
%                 disp('new')
%                 disp(total_points(i, :))
                total_points(i, mute_idx_points) = point;
                flag = check(total_points, N, M);
                if flag == 1
                    % ����
                    total_points(i, :) = points_old;
                end
            end
            
            % �ı䷽��
            if situ == 2 || situ == 3
                mute_idx_plans = unidrnd(M);
                % ���巽��
                plan = unidrnd(plans_table_len);
                total_plans(i, mute_idx_plans) = plan;
            end
            
            % �������ж�
            [~, is_reasonable] = calculate_cost(total_plans(i, :), PLANS_COST_TABLE, MAX_COST);
            
%             if cost > 200000
%                 disp(1);
%             end
            if is_reasonable
%                 if cost > 200000
%                     disp(1);
%                 end
                break;
            end
            
            % �����жϣ��ع�
            if count > 7
%                 total_points(i, :) = points_old;
                total_plans(i, :) = plans_old;
                
%                 [cost, ~] = calculate_cost(plans_old, PLANS_COST_TABLE, MAX_COST);
%                 if cost > 200000
%                     disp(1);
%                 end
                break;
            end
            count = count + 1;
        end
    end
    
    new_populations.points = total_points;
    new_populations.plans = total_plans;
end

function [flag] = check(total_points, N, M)
    flag = 0;
    for j = 1:N
        if length(unique(total_points(j, :))) ~= M
            flag = 1;
        end
    end
end
