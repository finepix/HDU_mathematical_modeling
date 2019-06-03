%% �ڶ���
%% �������ã�
%		1����������ͼ�ڽӾ���
%		2�����·����
%		3������ÿһ��block_size*block_size�����磬8*8���ĵ�ͼ��̽�������ܰ�װ�Ķ��㣻
%		4���ڸõ���ģ��TOTAL_PLANS��3����̽����������
%		5�����ÿһ��ģ����ÿһ�ַ��������ڸ���·����̽����Ӱ�졣
% PS��������ǰ������е�Ӱ�죬�������Ŵ��㷨�Ͳ��÷���ȥ���㣬����ֻ��Ҫ��ע����Ӧ�Ⱥ��������桢������Ծ��С�

%% ���·���Լ�����
clear;close all; clc;

addpath('calculate_dist');
addpath('plot');
addpath('utils');
addpath('genetic_algorithm');
clear;clc;close all;

%% ������������

% ��������
TOTAL_PLANS = 3;
MAX_COST = 200000;
% �����õĲ���
PLANS_COST_TABLE = [50000, 40000, 30000];
PLANS_RADIUS = [220 200 180];
PLANS_PH = [0.006 0.005 0.004];

% ��ͼ����
W = 1600;
H = 1600;
% seted_r = v * t
seted_r = 20 * 10;

% ���
entrances = [16 17 19 51 326 425 450 526 604];
% ������Ŀ��
attacked_targets = [412 587 618];
% �������
blocked_areas_index = [3 100 227 462];
% ���С
block_size = 25;
total_size = block_size * block_size;

%% 
% ��ȡÿһ�����ж�Ӧ������㣬 ԭʼ��Ϊ���1���Ͻǣ�0, 0��
index = 1 : block_size * block_size;
[x, y] = index2coordinate(index, W, H, block_size);

cordinates = [x; y]';

clear index x y
%% �����в��ֻ��Ҫ������·��
% ÿһ��С����ı߳�
piece_length = W / block_size;

% step1����ȡ��Ӱ���������Լ���Χ�����ߵķ��̻��߷�Χ
% blocked_cordinates = cordinates(blocked_areas_index);
% blocked_cordinates_x = [];
% blocked_cordinates_y = [];
% for i = 1:length(blocked_areas_index)
%     
% end

% step2: �����ڽӾ���
dist_matrix = zeros(block_size^2, block_size^2);
dist_matrix = build_dist_matrix(cordinates, blocked_areas_index, piece_length, dist_matrix);

dist_matrix = max(dist_matrix, dist_matrix');
dist_matrix = sparse(dist_matrix);

% step3�� ���·��
all_paths = cell(length(entrances), length(attacked_targets));

for i = 1:length(entrances)
    % ԭ��
    source = entrances(i);
    
    for j = 1:length(attacked_targets)
        % Ŀ�ĵ�
        target = attacked_targets(j);
        
        [distance , path, ~]=graphshortestpath(dist_matrix, source, target, 'Directed', false); % Directed�Ǳ�־ͼΪ�������������ԣ���ͼ������ͼ����Ӧ������ֵΪfalse����0��
        % TODO:ɾ��
        fprintf('origin: %d, target: %d, distance:%.2f, path:', source, target, distance);
        disp(path)
        all_paths{i, j} = path;
    end
end

all_paths = reshape(all_paths, length(entrances) * length(attacked_targets), 1);

% step4�� ��������·�����߶η���
% ����cell����
line_length = 0;
for i = 1:length(all_paths)
    path = all_paths{i};
    line_length = line_length + length(path) - 1;
end
% ȡ���߶�
lines = cell(1, line_length);
index = 1;
for i = 1:length(all_paths)
    path = all_paths{i};
    for j = 1:length(path)-1
        line = [path(j), path(j + 1)];
        lines{index} = line;
        index = index + 1;
    end
end

clear i j source target path line_length line

%% ���� 3 * 64 * 8��·��

plans_types = cell(TOTAL_PLANS, 1);

len_entrances = length(entrances);
len_targets = length(attacked_targets);

for i = 1:TOTAL_PLANS
    contributes = zeros(total_size, len_entrances*len_targets);
    % �����뾶
    radius = PLANS_RADIUS(i);
    for j = 1:total_size
        for k = 1:len_entrances*len_targets
            
            % ȡ��ÿһ��·��
            path = all_paths{k};
            % Ŀ���
            target_point_idx = path(length(path));
            target_point = cordinates(target_point_idx, :);
            
            % ����ÿһ����·��
            for v = 1:length(path)-1
                
                line = [path(v), path(v + 1)];
                pointA = cordinates(line(1), :);
                pointB = cordinates(line(2), :);
%                 % ����
%                 fprintf('line: %d %d, point: %d, length=\n', line(1), line(2), 29);      
%                 len = calculate_circle_line(cordinates(29, :), 200, pointA, pointB, target_point, seted_r)
                
                len = calculate_circle_line(cordinates(j, :), radius, pointA, pointB, target_point, seted_r);
                % TODO��ɾ��
                fprintf('line: %d %d, point: %d, length=%.2f\n', line(1), line(2), j, len);      
                
                contributes(j, k) = contributes(j, k) + len;
            end
        end
    end
    contributes = calculate_Pfail(contributes, PLANS_PH(i));
    
    % ��contributes�����ܵ�cell��
    plans_types{i} = contributes;
end

clear line lines pointA pointB len index i j k v len len_entrances len_targets lens line path contributes distance target_point target_point_idx  
save tmp.mat

%% ��������ֱ�ӽӵ�GA.m ʹ���Ŵ��㷨������⣬ֱ������GA.m���ɣ�һ����Կɣ�