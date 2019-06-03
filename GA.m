%% �Ŵ��㷨���
clear;clc;close all;
% �����м���
load tmp.mat

%% ԭʼ������������
% W = 1600;
% TOTAL_PLANS = 3;
% PLANS_COST_TABLE = [50000, 40000, 30000];
% MAX_COST = 200000;
% VALUE_MAX = 35000000;

len_targets = length(attacked_targets);
len_entrances = length(entrances);
len_paths = len_targets * len_entrances;

addpath('genetic_algorithm');
addpath('genetic_algorithm\genetic')

%% ɸѡһ�飬�����Ϊ0�ĵ�ɾ��
lens = plans_types{1} - 1;
lens = sum(lens, 2);
tmp_lens_index = find(lens < 0);

%% �Ŵ��㷨�����趨

% ��ѡ��ĸ���
total_used_points = tmp_lens_index;
len_total_used_points = length(tmp_lens_index); 

% ���̽�����ĸ�����Χ
M_min = MAX_COST / max(PLANS_COST_TABLE);
M_max = MAX_COST / min(PLANS_COST_TABLE);

% 
best_solution_points = [];
best_solution_plans = [];
global_max_val = 0;

M = 4;                      % ���ѡ��5����ͬ�ĵ����
%% ̽��̽������Χ�ռ�
% ������ʼ��
N = 500;                   % ��Ⱥ����
MAX_GENERATIONS = 150;      % ����������
pc = 0.5;                   % �������
pm = 0.1;                   % �������

gen_process = zeros(MAX_GENERATIONS, floor(M_max) - floor(M_min) + 1);

for M = M_min:M_max
    
    % ��ʼ����Ⱥ
    populations = [];
    % ѡ���ʼ��
    populations.points = zeros(N, M);
    % ̽����������ʼ����1 2 3 (TOTAL_PLANS)�ַ���������ֱ��ʹ��ʵ����������
    populations.plans = zeros(N, M);
    for i = 1:N
        % ����
        tmp_idx = randperm(len_total_used_points);
        % ���
        populations.points(i, :) = tmp_idx(1:M);

        while 1
            tmp_plan_idx = unidrnd(TOTAL_PLANS, 1, M);
            [~, is_reasonable] = calculate_cost(tmp_plan_idx, PLANS_COST_TABLE, MAX_COST);

            % TODO������
            % fprintf('index:%d, cost:%d, reasonable:%d \n', i, cost, is_reasonable);

            if is_reasonable
                populations.plans(i, :) = tmp_plan_idx;
                break;
            end
        end



    end

    %% �Ŵ��㷨������
    solution_points = [];
    solution_plans = [];
    best_val = 0;
    for i = 1:MAX_GENERATIONS
        % ������Ӧ��ֵ
        P = populations;
        fitv = fitness(populations, plans_types, len_paths, PLANS_RADIUS);
        % �ڶ��⿪ʼ
%         fitv = fitness_1(populations, plans_types, len_paths, PLANS_RADIUS);
    %     fitV = ranking(fitv);
        % step1:ǿ��ɸѡ���ŽⱣ�浽ģ����
        % �������Ž�
        top_idx = find(fitv == max(fitv));        
        top_populations = [];
        top_populations.points = populations.points(top_idx, :);
        top_populations.plans = populations.plans(top_idx, :);
       
        % �������Ž�
        solution_points = top_populations.points(1, :);
        solution_plans = top_populations.plans(1, :);
        best_val = max(fitv);
        
        % ���ڻ�ͼ
        gen_process(i, (M - M_min + 1)) = best_val;
        
        % ��¼ȫ�����Ž�
        if global_max_val < max(fitv)
            
            best_solution_points = solution_points;
            best_solution_plans = solution_plans;
            global_max_val = max(fitv);
        end
        % ��ӡ���Ž�
        fprintf('generation:%d, best val:%.3f\n', i, max(fitv));
        fprintf('ѡ�㣺')
        disp(top_populations.points(1, :));
        fprintf('������')
        disp(solution_plans);

        rest_idx = find(fitv ~= max(fitv));
        tmp_p = populations;
        populations.points = tmp_p.points(rest_idx, :);
        populations.plans = tmp_p.plans(rest_idx, :);
        fitv = fitv(rest_idx);
        % ʣ�µĲ���ѡ�񣬱��죬����
%         if length(top_idx) >= 0.8 * N
%             populations = P;
%         end

        % ����
    %     fitv = fitness(populations);
    % %     fitV = ranking(fitv);
    %     fprintf('####before########best val:%d \n', max(fitv));

        % step2: ѡ��
        tmp_populations = [populations.points  populations.plans];
        tmp_populations = select('sus',tmp_populations,fitv,1);%select
        populations.points = tmp_populations(:, 1:M);
        populations.plans = tmp_populations(:, M+1:2*M);

    %     % ����
    %     costs = cul_costs(populations.plans, PLANS_COST_TABLE, MAX_COST);
    %     disp(['ѡ���max cost: ', num2str(max(costs))])
    %     
        % step3������
        populations = cross(populations, pc, PLANS_COST_TABLE, MAX_COST);

    %     % ����
    %     costs = cul_costs(populations.plans, PLANS_COST_TABLE, MAX_COST);
    %     disp(['�����max cost: ', num2str(max(costs))])

        % step4������
        populations = mutate_own(populations, pm, PLANS_COST_TABLE, MAX_COST, total_used_points);

    %     % ����
    %     costs = cul_costs(populations.plans, PLANS_COST_TABLE, MAX_COST);
    %     disp(['�����max cost: ', num2str(max(costs))])

        % ����
    %     fitv = fitness(populations);
    % %     fitV = ranking(fitv);
    %     fprintf('####after########best val:%d \n', max(fitv));

        % step5�����
%         if size(populations.points, 1) + size(top_populations.points, 1) ~= N
%             continue;
%         end
        tmp_p = populations;
        populations = [];
        populations.points = [top_populations.points; tmp_p.points];
        populations.plans = [top_populations.plans; tmp_p.plans];

    end

    %% ���չʾ
    plot_solution(W, H, block_size, cordinates, attacked_targets, entrances, blocked_areas_index, all_paths, PLANS_RADIUS, solution_points, solution_plans, best_val);

end
%% �������չʾ
plot_solution(W, H, block_size, cordinates, attacked_targets, entrances, blocked_areas_index, all_paths, PLANS_RADIUS, best_solution_points, best_solution_plans, global_max_val);
% ��ӡ���ս��
fprintf('̽����ѡ�㣺');
disp(best_solution_points);
fprintf('̽��������');
disp(best_solution_plans);
fprintf('���̽����');
disp(global_max_val);

% �Ŵ��㷨����������չʾ������ͼ
x = 1:MAX_GENERATIONS;
for i = 1:size(gen_process, 2)
    figure;
    plot(x, gen_process(:, i))
    title(['Genetic algorithm process, num of dectators:', num2str(i + M_min - 1)]);
end

