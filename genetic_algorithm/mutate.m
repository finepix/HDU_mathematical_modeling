function [ output_args ] = mutate_own( populations, pm, PLANS_COST_TABLE, MAX_COST, total_used_points )
%UNTITLED13 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    total_points = populations.points;
    total_plans = populations.plans;
    
    used_size = length(total_used_points);
    plans_table_len = length(PLANS_COST_TABLE);
    
    N = size(total_points, 1);
    M = size(total_points, 2);
    % ѭ������ÿһ������
    for i = 1:N
        points_old = total_points(i);
        plans_old = total_plans(i);
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
                while 1
                    point_idx = unidrnd(used_size);
                    point = total_used_points(point_idx);
                    if ~ismember(point, points_old)
                        break;
                    end
                end
                total_points(i, mute_idx_points) = point;
            end
            
            % �ı䷽��
            if situ == 2 || situ == 3
                mute_idx_plans = unidrnd(M);
                % ���巽��
                plan = unidrnd(plans_table_len);
                total_plans(i, mute_idx_plans) = plan;
            end
            
            % �������ж�
            [~, is_reasonable] = calculate_cost(total_plans(i), PLANS_COST_TABLE, MAX_COST);
            if is_reasonable
                break;
            end
            
            % �����жϣ��ع�
            if count > 7
%                 total_points(i, :) = points_old;
                total_plans(i, :) = plans_old;
                break;
            end
            count = count + 1;
        end
    end

end

