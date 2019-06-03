function [ A ] = fitness_1( populations, plans_types, len_paths, PLANS_RADIUS)
%UNTITLED11 ��Ӧ�Ⱥ���
%   �˴���ʾ��ϸ˵��
    plans = populations.plans;
    points = populations.points;
    
    L = length(PLANS_RADIUS);
    [N, M] = size(points);
    
    P_success = zeros(N, 1);
    for i = 1:N
        p_i_success = 0;
        for j = 1:len_paths
            % ��i��������j����·��ʧ����������
            p_i_j_fail = 1;
            for k = 1:M
                
                point_i_k = points(i, k);
                plans_i_k = plans(i, k);
                
                p_i_j_fail = plans_types{plans_i_k}(point_i_k, j) * p_i_j_fail;
                
                
%                 p_i_j_fail = p_i_j_fail * plans_types_matrix(plan_i_k, point_i_k, j);
            end
            p_i_success = p_i_success + (1 - p_i_j_fail) / len_paths;
        end
        
        P_success(i) = p_i_success;
    end
    % ���ճɹ���
    A = P_success;
end


%     % step2�� ����ÿ��·��
%     P_success = zeros(N, 1);
%     for i = 1:len_paths
%         % ��ʼ��ʧ����Ϊ1
%         p_i_fail_all = 1;
%         
%         
%         p_i_j_k = plans_types{plans}(points, i);
%         
%         % ����ÿһ������
%         for j = 1:N
%             for k = 1:M
%                 p_i_j_k = plans_types{plans(j,k)}(points(j, k), i);
%                 p_i_fail_all = p_i_fail_all * p_i_j_k;
%             end
%         end
%         % �������سɹ���
%         p_i_success = 1 - p_i_fail_all;
%         p_success = p_success + p_i_success;
%     end

