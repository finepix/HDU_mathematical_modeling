function [ new_populations ] = cross(populations, pc, PLANS_COST_TABLE, MAX_COST)
%UNTITLED7 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    N = size(populations.points, 1);
    new_populations = [];
    
    new_points = zeros(size(populations.points));
    new_plans = zeros(size(populations.plans));
    for i = 1:floor(N/2)
%         father = [populations.points(i), populations.plans(i)];
%         mother = [populations.points(i) + N/2, populations.plans(i) + N/2];
        father = populations.points(i, :);
        mother = populations.points(i + floor(N/2), :);
        
        father_plans = populations.plans(i, :);
        mother_plans = populations.plans(i + floor(N/2), :);
        
        father_old = father;
        mother_old = mother;

        father_plans_old = father_plans;
        mother_plans_old = mother_plans;
        
        if rand() > pc                  % �жϽ�����
            new_points(i, :) = father_old;
            new_points(i + floor(N/2), :) = mother_old;

            new_plans(i, :) = father_plans_old;
            new_plans(i + floor(N/2), :) = mother_plans_old;
            continue;
        end
        
        % ����������
        % ���켯��
        [father_left, father_left_idx] = setdiff(father, mother);
        [~, mother_left_idx] = setdiff(mother, father);
        
        if length(father_left) < 1      % ������ȫһ��
            new_points(i, :) = father_old;
            new_points(i + floor(N/2), :) = mother_old;

            new_plans(i, :) = father_plans_old;
            new_plans(i + floor(N/2), :) = mother_plans_old;
            continue;
        end
        
        swich_num = 1;
        if length(father_left) > 2      % ���������ĸ�������2����ô�ཻ������
            swich_num = 2;
        end
        
        % ����
        count = 0;  % ������������̫��ﲻ������ֱ������
        while 1
            tmp_swich_idx = randperm(length(father_left));
            tmp_swich_idx = tmp_swich_idx(1:swich_num);
            
            father_swich_idx = father_left_idx(tmp_swich_idx);
            mother_swich_idx = mother_left_idx(tmp_swich_idx);
                
            tmp_father_points = father(father_swich_idx);
            tmp_father_plans = father_plans(father_swich_idx);

            father(father_swich_idx) = mother(mother_swich_idx);
            father_plans(father_swich_idx) = mother_plans(mother_swich_idx);

            mother(mother_swich_idx) = tmp_father_points;
            mother_plans(mother_swich_idx) = tmp_father_plans;
            
            % �жϷ����Ƿ����
            [cost1, f_is_reasonable] = calculate_cost(father_plans, PLANS_COST_TABLE, MAX_COST);
            [cost2, m_is_reasonable] = calculate_cost(mother_plans, PLANS_COST_TABLE, MAX_COST);
            
            if f_is_reasonable && m_is_reasonable
                % ��ֵ
                new_points(i, :) = father;
                new_points(i + floor(N/2), :) = mother;

                new_plans(i, :) = father_plans;
                new_plans(i + floor(N/2), :) = mother_plans;
                
                break;
            end
            % ������ν������ɹ�
            if count > 5
                new_points(i, :) = father_old;
                new_points(i + floor(N/2), :) = mother_old;

                new_plans(i, :) = father_plans_old;
                new_plans(i + floor(N/2), :) = mother_plans_old;
                
                break;
            end
            
            count = count + 1;
        end
        
    end
    
    if new_points(N, 1) == 0
        tmp_idx = unidrnd(N - 1);
        new_points(N, :) = new_points(tmp_idx, :);
        new_plans(N, :) = new_plans(tmp_idx, :);
    end
    
    new_populations.points = new_points;
    new_populations.plans = new_plans;

end

